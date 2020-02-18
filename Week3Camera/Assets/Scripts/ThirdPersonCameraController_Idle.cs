using System;
using UnityEngine;

public partial class ThirdPersonCameraController
{
    public class CameraState_Idle : IState
    {
        private ThirdPersonCameraController controller;

        public CameraState_Idle(ThirdPersonCameraController controller)
        {
            this.controller = controller;
        }

        public CameraState GetState()
        {
            return CameraState.Idle;
        }

        public void Update()
        {
            if (Input.GetMouseButton(0))
            {
                controller.SetState(CameraState.Automatic);
                return;
            }

            if (Input.GetMouseButton(1))
            {
                controller.SetState(CameraState.Manual);
                return;
            }
        }

        public void OnEnter()
        {
        }

        public void OnLeave()
        {
        }
    }

    private float _idleTimer;
}