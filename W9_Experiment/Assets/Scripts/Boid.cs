using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using Random = UnityEngine.Random;

public class Boid : MonoBehaviour
{
    internal Flock Flock;

    internal Vector3 Velocity = Vector3.zero;
    public Vector3 Acceleration = Vector3.zero;

    internal Vector3 GroupingAcceleration = Vector3.zero;
    internal Vector3 AvoidanceAcceleration = Vector3.zero;
    internal Vector3 AlignmentAcceleration = Vector3.zero;
    internal Vector3 AreaOfInterestAcceleration = Vector3.zero;

    void Awake()
    {
    }

    internal void Initialize(Flock parentFlock)
    {
        Flock = parentFlock;
    }

    void Update()
    {
        Sense();

        CalcAcceleration();
        CalcVelocity();
    }

    private List<Collider> boidsToGroupWith = new List<Collider>();
    private List<Collider> boidsToAlignWith = new List<Collider>();
    private List<Collider> boidsToAvoid = new List<Collider>();

    void Sense()
    {
        boidsToGroupWith.Clear();
        boidsToAlignWith.Clear();
        boidsToAvoid.Clear();

        boidsToGroupWith = Physics.OverlapSphere(transform.position + transform.forward * Flock.BoidToGroupDist, Flock.BoidToGroupRadius).ToList();
        boidsToAlignWith = Physics.OverlapSphere(transform.position, Flock.BoidToAlignRadius).ToList();
        RaycastHit[] rchs = Physics.SphereCastAll(new Ray(transform.position, transform.forward), Flock.BoidToAvoidRadius);
        foreach (RaycastHit hit in rchs)
        {
            Collider c = hit.collider;
            boidsToAvoid.Add(c);
        }
    }

    private void LateUpdate()
    {
        transform.position += Velocity * Time.deltaTime;
        ;
    }

    void CalcAcceleration()
    {
        Grouping();
        Avoidance();
        Alignment();
        AreaOfInterest();
        Acceleration = (GroupingAcceleration * Flock.GroupingWeight
                        + AvoidanceAcceleration * Flock.AvoidanceWeight
                        + AlignmentAcceleration * Flock.AlignmentWeight
                        + AreaOfInterestAcceleration * Flock.AreaOfInterestWeight
                       ) * Flock.AccelerateScale;
    }

    void CalcVelocity()
    {
        Velocity = Velocity + Acceleration * Time.deltaTime;
        Vector3.ClampMagnitude(Velocity, Flock.MaxSpeed);
    }

    #region Desires

    void Grouping()
    {
        if (boidsToGroupWith.Count > 0)
        {
            Vector3 sum = Vector3.zero;
            foreach (Collider c in boidsToGroupWith)
            {
                sum += c.transform.position;
            }

            Vector3 centerOfGroup = sum / boidsToGroupWith.Count;
            Vector3 diff = centerOfGroup - transform.position;
            GroupingAcceleration = diff.normalized;
        }
        else
        {
            GroupingAcceleration = Vector3.zero;
        }
    }

    void Avoidance()
    {
        if (boidsToAvoid.Count > 0)
        {
            Vector3 sum = Vector3.zero;
            foreach (Collider c in boidsToAvoid)
            {
                sum += c.transform.position;
            }

            Vector3 centerOfAvoid = sum / boidsToAvoid.Count;
            AvoidanceAcceleration = Quaternion.Euler(0, 90, 0) * (transform.position - centerOfAvoid).normalized * boidsToAvoid.Count;
        }
        else
        {
            AvoidanceAcceleration = Vector3.zero;
        }
    }

    void Alignment()
    {
        if (boidsToAlignWith.Count > 0)
        {
            Vector3 sum = Vector3.zero;
            foreach (Collider c in boidsToAlignWith)
            {
                sum += c.transform.forward;
            }

            Vector3 avgOfAlign = sum / boidsToAlignWith.Count;
            AlignmentAcceleration = avgOfAlign.normalized;
        }
        else
        {
            AlignmentAcceleration = Vector3.zero;
        }
    }

    void AreaOfInterest()
    {
        // float dist = Vector3.Distance(transform.position, Flock.FlockCenter);
        // dist = Mathf.Clamp(dist, 0, 10);
        // AreaOfInterestAcceleration = (Flock.FlockCenter - transform.position).normalized * (dist * dist) / 100f;
    }

    #endregion
}