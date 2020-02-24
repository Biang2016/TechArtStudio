using UnityEngine;

public partial class ThirdPersonCameraController
{
    public class CameraState_Manual : IState
    {
        private ThirdPersonCameraController controller;

        public CameraState_Manual(ThirdPersonCameraController controller)
        {
            this.controller = controller;
        }

        public CameraState GetState()
        {
            return CameraState.Manual;
        }

        public void Update()
        {
            if (!Input.GetMouseButton(1))
            {
                controller.SetState(CameraState.Automatic);
                return;
            }

            controller._FollowAvatar_Manual();
            controller._ManualControl();
            controller._idleTimer = 0;
        }

        public void OnEnter()
        {
        }

        public void OnLeave()
        {
        }
    }

    private void _ManualControl()
    {
        Vector3 _camEulerHold = _cameraTransform.localEulerAngles;

        if (!Input.GetAxis("Mouse X").Equals(0))
        {
            _camEulerHold.y += Input.GetAxis("Mouse X");
        }

        if (!Input.GetAxis("Mouse Y").Equals(0))
        {
            float rawAngle = _camEulerHold.x - Input.GetAxis("Mouse Y");
            rawAngle = (rawAngle + 360) % 360;

            float clampAngle = 80f;
            if (rawAngle < 180)
            {
                rawAngle = Mathf.Clamp(rawAngle, 0, clampAngle);
            }
            else
            {
                rawAngle = Mathf.Clamp(rawAngle, 360 - clampAngle, 360);
            }

            _camEulerHold.x = rawAngle;
        }

        _cameraTransform.localRotation = Quaternion.Lerp(_cameraTransform.localRotation, Quaternion.Euler(_camEulerHold), Time.deltaTime * 60);
    }

    private const int smoothRotateOffsetAngle = 20;

    private void _FollowAvatar_Manual()
    {
        _camRelativePosition_Auto = _avatarTransform.position;

        _cameraLookTarget.position = _avatarTransform.position + avatarObservationOffset_Base;

        Vector3 cameraForward = new Vector3(_cameraTransform.forward.x, 0, _cameraTransform.forward.z);

        float rot_Y = Vector3.SignedAngle(cameraForward, _avatarTransform.forward,Vector3.down);
        if (rot_Y > 180)
        {
            rot_Y = rot_Y - 360;
        }

        if (Mathf.Abs(rot_Y) > 180 - smoothRotateOffsetAngle)
        {
            float sign = Mathf.Sign(rot_Y);
            rot_Y = sign * 180 - rot_Y;
        }

        float rotateOffsetSign = Mathf.Clamp((rot_Y + smoothRotateOffsetAngle) / smoothRotateOffsetAngle - 1, -1f, 1f);

        Vector3 cameraPos = _avatarTransform.position - _cameraTransform.forward * _followDistance_Applied / 4f + _cameraTransform.right * -0.3f * rotateOffsetSign + Vector3.up * verticalOffset_Base;
        _cameraTransform.position = Vector3.Lerp(_cameraTransform.position, cameraPos, Time.deltaTime * 5);
    }
}