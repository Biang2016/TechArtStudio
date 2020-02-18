using UnityEngine;

public partial class ThirdPersonCameraController
{
    public class CameraState_Automatic : IState
    {
        private ThirdPersonCameraController controller;

        public CameraState_Automatic(ThirdPersonCameraController controller)
        {
            this.controller = controller;
        }

        public CameraState GetState()
        {
            return CameraState.Automatic;
        }

        public void Update()
        {
            if (Input.GetMouseButton(1))
            {
                controller.SetState(CameraState.Manual);
                return;
            }

            controller._ComputeData();
            controller._LookAtObject(controller._Helper_GetClosestOOI(), true);
            controller._FollowAvatar(true);
        }

        public void OnEnter()
        {
        }

        public void OnLeave()
        {
        }
    }
}