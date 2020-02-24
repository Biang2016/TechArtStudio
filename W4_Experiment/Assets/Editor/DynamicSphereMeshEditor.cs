using System.ComponentModel;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(DynamicSphereMesh))]
public class DynamicSphereMeshEditor : Editor
{
    private DynamicSphereMesh MySphereMesh;

    private void Awake()
    {
        MySphereMesh = target as DynamicSphereMesh;
    }


}