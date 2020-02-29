using System;
using System.Collections.Generic;
using UnityEngine;

public class TerrainChunk : MonoBehaviour
{
    [SerializeField] private int divPerUnit = 64;

    [SerializeField] private float noiseOctaveScale = 1;

    private Mesh myTerrainChunkMesh;

    [SerializeField] private MeshRenderer MeshRenderer;
    [SerializeField] private MeshFilter MeshFilter;
    private Vector3[,] positions;

    void Start()
    {
        positions = new Vector3[divPerUnit + 1, divPerUnit + 1];
        myTerrainChunkMesh = new Mesh();
        MeshFilter.mesh = myTerrainChunkMesh;
    }

    private void Update()
    {
        RefreshMesh();
    }

    void RefreshMesh()
    {
        for (int i = 0; i <= divPerUnit; i++)
        {
            for (int j = 0; j <= divPerUnit; j++)
            {
                float xPos = transform.position.x + (float) i / divPerUnit;
                float zPos = transform.position.z + (float) j / divPerUnit;
                float yPos = Perlin.Noise(xPos * noiseOctaveScale, zPos * noiseOctaveScale);

                positions[i, j] = new Vector3(xPos - transform.position.x, yPos, zPos - transform.position.z);
            }
        }

        List<int> _trisList = new List<int>();
        List<Vector3> _vertList = new List<Vector3>();

        List<Vector3> _normalList = new List<Vector3>();
        for (int i = 0; i < divPerUnit; i++)
        {
            for (int j = 0; j < divPerUnit; j++)
            {
                _vertList.Add(positions[i, j]);
                _vertList.Add(positions[i, j + 1]);
                _vertList.Add(positions[i + 1, j + 1]);
                _vertList.Add(positions[i + 1, j + 1]);
                _vertList.Add(positions[i + 1, j]);
                _vertList.Add(positions[i, j]);

                Vector3 v1 = positions[i, j] - positions[i, j + 1];
                Vector3 v2 = positions[i + 1, j + 1] - positions[i, j + 1];
                Vector3 nor1 = Vector3.Cross(v1, v2).normalized;
                _normalList.Add(nor1);
                _normalList.Add(nor1);
                _normalList.Add(nor1);

                Vector3 v3 = positions[i + 1, j + 1] - positions[i + 1, j];
                Vector3 v4 = positions[i, j] - positions[i + 1, j];
                Vector3 nor2 = Vector3.Cross(v3, v4).normalized;
                _normalList.Add(nor2);
                _normalList.Add(nor2);
                _normalList.Add(nor2);

                int offset = (i * divPerUnit + j) * 6;

                for (int k = 0; k < 6; k++)
                {
                    _trisList.Add(k + offset);
                }
            }
        }

        myTerrainChunkMesh.vertices = _vertList.ToArray();
        myTerrainChunkMesh.triangles = _trisList.ToArray();
        myTerrainChunkMesh.normals = _normalList.ToArray();
    }
}