public interface IState
{
    CameraState GetState();
    void Update();

    void OnEnter();

    void OnLeave();
}

public enum CameraState
{
    Manual,
    Automatic,
    Idle
}