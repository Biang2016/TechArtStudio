using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoSingleton<GameManager>
{
    void Awake()
    {
        Application.targetFrameRate = 60;
    }

    void Start()
    {
    }

    void Update()
    {
    }
}