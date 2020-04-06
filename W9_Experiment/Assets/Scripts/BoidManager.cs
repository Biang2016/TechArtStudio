using System.Collections.Generic;
using UnityEngine;

public class BoidManager : MonoSingleton<BoidManager>
{
    internal Dictionary<string, Flock> FlockDict = new Dictionary<string, Flock>();

    void Start()
    {
        for (int i = 0; i < transform.childCount; i++)
        {
            GameObject child = transform.GetChild(i).gameObject;
            Flock flock = child.GetComponent<Flock>();
            FlockDict.Add(flock.name, flock);
        }

        foreach (KeyValuePair<string, Flock> kv in FlockDict)
        {
            kv.Value.Initialize();
        }
    }
}