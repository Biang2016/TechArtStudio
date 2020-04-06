using System.Collections.Generic;
using UnityEngine;

public class Flock : MonoBehaviour
{
    public int BoidNumber = 100;
    private List<Boid> Boids = new List<Boid>();
    public GameObjectPoolManager.PrefabNames BoidType;

    [SerializeField] private Transform CenterPivot;
    [SerializeField] private Transform Container;

    [Space] [Range(0, 10f)] public float MaxSpeed = 1f;
    [Range(0, 10f)] public float AccelerateScale = 1f;

    [Space] [Range(0, 10f)] public float GroupingWeight;
    [Range(0, 10f)] public float AvoidanceWeight;
    [Range(0, 10f)] public float AlignmentWeight;
    [Range(0, 10f)] public float AreaOfInterestWeight;

    [Space] public float BoidToGroupDist;
    [Space] public float BoidToGroupRadius;
    public float BoidToAlignRadius;
    public float BoidToAvoidRadius;

    internal void Initialize()
    {
        for (int i = 0; i < BoidNumber; i++)
        {
            PoolObject po = GameObjectPoolManager.Instance.PoolDict[BoidType].AllocateGameObject<PoolObject>(Container);
            Boid boid = po.GetComponent<Boid>();
            Boids.Add(boid);
            boid.transform.position = new Vector3(Random.Range(-50f, 50f), Random.Range(-50f, 50f), Random.Range(-50f, 50f));
            boid.Initialize(this);
        }

        RefreshCommonVars();
    }

    void LateUpdate()
    {
        RefreshCommonVars();
    }

    void RefreshCommonVars()
    {
        RefreshFlockCenter();
    }

    internal Vector3 FlockCenter = Vector3.zero;

    internal void RefreshFlockCenter()
    {
        Vector3 sum = Vector3.zero;
        foreach (Boid boid in Boids)
        {
            sum += boid.transform.position;
        }

        FlockCenter = sum / Boids.Count;
        CenterPivot.position = FlockCenter;
    }
}