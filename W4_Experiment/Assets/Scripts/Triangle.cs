using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class Triangle : MonoBehaviour
{
    public Texture Texture;
    private MeshRenderer _meshRenderer;
    private MeshFilter _meshFilter;

    private Mesh _myMesh;

    private Vector3[] _verts;
    private int[] _tris;
    private Vector3[] _norms;
    private Color[] _colors;
    private Vector2[] _uvs;

    private Material _mat;

    void Start()
    {
        _meshRenderer = GetComponent<MeshRenderer>();
        _meshFilter = GetComponent<MeshFilter>();

        _myMesh = new Mesh();
        _myMesh.name = "steve";

        GenerateMaterial();

        MakeVertsAndTris();
        MakeNormals();
        MakeUVs();
        PassDateToMesh();
        PopulateComponents();
    }

    void Update()
    {
        // for (int i = 0; i < _uvs.Length; i++)
        // {
        //     _uvs[i].x -= Time.deltaTime;
        // }
        // _myMesh.uv = _uvs;

        for (int i = 0; i < _norms.Length; i++)
        {
            _norms[i] = Random.insideUnitSphere;
        }

        _myMesh.normals = _norms;
    }

    private int size = 10;

    private void MakeVertsAndTris()
    {
        List<Vector3> vertList = new List<Vector3>();
        List<int> triList = new List<int>();
        List<Color> colorList = new List<Color>();

        List<Vector3> normList = new List<Vector3>();
        List<Vector2> uvList = new List<Vector2>();

        int vertIndex = 0;
        for (int i = 0; i < size; i++)
        {
            for (int j = 0; j < size; j++)
            {
                vertIndex++;
                vertList.Add(new Vector3(i, j, 0));
                uvList.Add(new Vector2((float) i / size, (float) j / size));

                // normList.Add(new Vector3(0, 0, 1));
                normList.Add(new Vector3((float) i / size, (float) i / size, 1).normalized);
                colorList.Add(Color.blue);
                // colorList.Add(new Color((float) i / size, (float) i / size, 1));

                if (i < size - 1 && j < size - 1)
                {
                    triList.Add(i * size + j);
                    triList.Add((i + 1) * size + j);
                    triList.Add(i * size + j + 1);
                }
            }
        }

        for (int i = 0; i < size; i++)
        {
            for (int j = 0; j < size; j++)
            {
                vertIndex += 3;
                Vector3 p1 = new Vector3(i + 0.5f, j - 0.5f, 0);
                vertList.Add(p1);
                uvList.Add(p1 / size);
                Vector3 p2 = new Vector3(i + 0.5f, j + 1, 0);
                vertList.Add(p2);
                uvList.Add(p2 / size);
                Vector3 p3 = new Vector3(i + 1, j + 0.5f, 0);
                vertList.Add(p3);
                uvList.Add(p3 / size);

                normList.Add(new Vector3((float) i / size, (float) i / size, 1).normalized);
                normList.Add(new Vector3((float) i / size, (float) i / size, 1).normalized);
                normList.Add(new Vector3((float) i / size, (float) i / size, 1).normalized);

                colorList.Add(Color.blue);
                colorList.Add(Color.blue);
                colorList.Add(Color.blue);

                if (i < size - 1 && j < size - 1)
                {
                    triList.Add(vertIndex);
                    triList.Add(vertIndex - 1);
                    triList.Add(vertIndex - 2);
                }
            }
        }

        _verts = vertList.ToArray();
        _tris = triList.ToArray();
        _norms = normList.ToArray();
        _uvs = uvList.ToArray();
        _colors = colorList.ToArray();
    }

    private void MakeNormals()
    {
    }

    private void MakeUVs()
    {
    }

    private void PassDateToMesh()
    {
        _myMesh.vertices = _verts;
        _myMesh.triangles = _tris;
        _myMesh.normals = _norms;
        _myMesh.colors = _colors;
        _myMesh.uv = _uvs;
    }

    private void PopulateComponents()
    {
        _meshFilter.mesh = _myMesh;
    }

    private void GenerateMaterial()
    {
        _mat = new Material(Shader.Find("Standard"));
        _mat.mainTexture = Texture;
        _meshRenderer.material = _mat;
    }
}