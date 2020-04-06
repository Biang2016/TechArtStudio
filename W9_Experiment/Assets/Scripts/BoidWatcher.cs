using System;
using UnityEngine;

public class BoidWatcher : MonoBehaviour
{
    [SerializeField] private Flock TargetFlock;

    private void LateUpdate()
    {
        transform.LookAt(TargetFlock.FlockCenter);
    }
}