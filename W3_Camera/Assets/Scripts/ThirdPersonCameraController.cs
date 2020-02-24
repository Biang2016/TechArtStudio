using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using DG.Tweening;
using UnityEngine;

public partial class ThirdPersonCameraController : MonoBehaviour
{
    #region Internal References

    [SerializeField] private Transform _cameraBaseTransform;
    [SerializeField] private Transform _cameraTransform;
    [SerializeField] private Transform _cameraLookTarget;
    [SerializeField] private Transform _avatarTransform;
    [SerializeField] private Rigidbody _avatarRigidbody;

    #endregion

    #region Public Tuning Variables

    [SerializeField] private Vector3 avatarObservationOffset_Base;
    [SerializeField] private float followDistance_Base;
    [SerializeField] private float verticalOffset_Base;
    [SerializeField] private float pitchGreaterLimit;
    [SerializeField] private float pitchLowerLimit;
    [SerializeField] private float fovAtUp;
    [SerializeField] private float fovAtDown;

    #endregion

    #region Persistent Outputs

    //Positions
    private Vector3 _camRelativePosition_Auto;

    //Directions
    private Vector3 _avatarLookForward;

    //Scalars
    private float _followDistance_Applied;
    private float _verticalOffset_Applied;

    //States
    private IState _currentState = null;

    #endregion

    private int LayerMask_OOI;

    private void Awake()
    {
        LayerMask_OOI = LayerMask.GetMask("OOI");
    }

    private void Start()
    {
        _ComputeData();
        _FollowAvatar(false);
        _LookAtObject(null, false);
        SetState(CameraState.Automatic);
    }

    private void LateUpdate()
    {
        _currentState?.Update();

        if (!_Helper_IsWalking())
        {
            _idleTimer += Time.deltaTime;
        }
        else
        {
            _idleTimer = 0;
        }
    }

    private void SetState(CameraState cameraState)
    {
        _currentState?.OnLeave();
        switch (cameraState)
        {
            case CameraState.Automatic:
            {
                _currentState = new CameraState_Automatic(this);
                break;
            }
            case CameraState.Manual:
            {
                _currentState = new CameraState_Manual(this);
                break;
            }
            case CameraState.Idle:
            {
                _currentState = new CameraState_Idle(this);
                break;
            }
        }

        _currentState.OnEnter();
    }

    #region Internal Logic

    float _standingToWalkingSlider = 0;

    private void _ComputeData()
    {
        _avatarLookForward = Vector3.Normalize(Vector3.Scale(_avatarTransform.forward, new Vector3(1, 0, 1)));

        if (_Helper_IsWalking())
        {
            _standingToWalkingSlider = Mathf.MoveTowards(_standingToWalkingSlider, 1, Time.deltaTime * 3);
        }
        else
        {
            _standingToWalkingSlider = Mathf.MoveTowards(_standingToWalkingSlider, 0, Time.deltaTime);
        }

        float _followDistance_Walking = followDistance_Base;
        float _followDistance_Standing = followDistance_Base * 1.5f;

        float _verticalOffset_Walking = verticalOffset_Base;
        float _verticalOffset_Standing = verticalOffset_Base * 2;

        _followDistance_Applied = Mathf.Lerp(_followDistance_Standing, _followDistance_Walking, _standingToWalkingSlider);
        _verticalOffset_Applied = Mathf.Lerp(_verticalOffset_Standing, _verticalOffset_Walking, _standingToWalkingSlider);
    }

    private void _FollowAvatar(bool lerp)
    {
        _camRelativePosition_Auto = _avatarTransform.position;

        float targetAngleOffset = _Helper_GetCameraAngleOffsetToAvatar();
        targetAngleOffset = Mathf.LerpAngle(targetAngleOffset, 0, Time.deltaTime * 60);
        Quaternion angleQuaternion = Quaternion.Euler(0, targetAngleOffset, 0);
        Vector3 cameraPos = _avatarTransform.position - angleQuaternion * _avatarLookForward * _followDistance_Applied + Vector3.up * _verticalOffset_Applied;

        if (lerp)
        {
            _cameraTransform.position = Vector3.Lerp(_cameraTransform.position, cameraPos, Time.deltaTime * 5);
        }
        else
        {
            _cameraTransform.position = cameraPos;
        }
    }

    private Transform lookingAtOOI = null;

    [SerializeField] private float _leaveOOISpeedThreshold = -1f;

    private void _LookAtObject(Transform ooi, bool lerp)
    {
        lookingAtOOI = ooi;
        if (ooi)
        {
            Vector3 dirToAvatar = ooi.position - _avatarTransform.position;
            float product = Vector3.Dot(dirToAvatar, _moveDir);
            if (product < _leaveOOISpeedThreshold)
            {
                lookingAtOOI = null;
            }
        }

        Vector3 targetPos = lookingAtOOI ? lookingAtOOI.position : _avatarTransform.position + avatarObservationOffset_Base;

        if (lerp)
        {
            if (lookingAtOOI)
            {
                _cameraLookTarget.position = Vector3.Lerp(_cameraLookTarget.position, targetPos, Time.deltaTime * 1);
            }
            else
            {
                _cameraLookTarget.position = Vector3.Lerp(_cameraLookTarget.position, targetPos, Time.deltaTime * 5);
            }
        }
        else
        {
            _cameraLookTarget.position = targetPos;
        }

        _cameraTransform.LookAt(_cameraLookTarget);
    }

    #endregion

    #region Helper Functions

    private Vector3 _lastPos;
    private Vector3 _currentPos;
    private Vector3 _moveDir;

    private bool _Helper_IsWalking()
    {
        _lastPos = _currentPos;
        _currentPos = _avatarTransform.position;
        float velInst = Vector3.Distance(_lastPos, _currentPos) / Time.deltaTime;
        _moveDir = _currentPos - _lastPos;
        if (velInst > .15f)
            return true;
        else return false;
    }

    [SerializeField] private float OOI_Radius = 12.5f;
    [SerializeField] private float OOI_AngleMultiplyDistanceThreshold = 250;
    [SerializeField] private float OOI_AngleThreshold = 60;

    private bool _Helper_IsThereOOI(out Collider[] stuffInSphere)
    {
        stuffInSphere = Physics.OverlapSphere(_avatarTransform.position, OOI_Radius, LayerMask_OOI);
        return stuffInSphere.Length > 0;
    }

    private Transform _Helper_GetClosestOOI()
    {
        bool exist = _Helper_IsThereOOI(out Collider[] stuffInSphere);
        if (exist)
        {
            float minFloat = 999f;
            Transform closestTrans = null;
            foreach (Collider c in stuffInSphere)
            {
                Vector3 dir = Vector3.Scale(c.transform.position - _avatarTransform.position, new Vector3(1, 0, 1));
                Vector3 cameraForward = Vector3.Scale(_avatarLookForward, new Vector3(1, 0, 1));

                float angleToAvatarForward = Vector3.SignedAngle(dir, cameraForward, Vector3.down);
                float distance = dir.magnitude;

                if (Mathf.Abs(angleToAvatarForward) < OOI_AngleThreshold && (Mathf.Abs(angleToAvatarForward) + 20) * distance < OOI_AngleMultiplyDistanceThreshold)
                {
                    if (minFloat > Mathf.Abs(angleToAvatarForward))
                    {
                        minFloat = Mathf.Abs(angleToAvatarForward);
                        closestTrans = c.transform;
                    }
                }
            }

            return closestTrans;
        }
        else
        {
            return null;
        }
    }

    private float _Helper_GetCameraAngleOffsetToAvatar()
    {
        Vector3 cameraForward = new Vector3(_cameraTransform.forward.x, 0, _cameraTransform.forward.z);
        float rot_Y = Vector3.SignedAngle(cameraForward, _avatarTransform.forward, Vector3.down);
        return rot_Y;
    }

    #endregion
}