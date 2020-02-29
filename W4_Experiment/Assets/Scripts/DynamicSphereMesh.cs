using UnityEngine;
using System.Collections;
using UnityEngine.UIElements;

public class DynamicSphereMesh : MonoBehaviour
{
    [SerializeField] private Mesh SphereMesh;
    [SerializeField] private Material Material;
    private MeshRenderer MeshRenderer;
    private MeshFilter MeshFilter;

    private Mesh mesh;

    private Vector3[] _verts;
    private int[] _tris;
    private Vector3[] _norms;
    private Color[] _colors;

    private void Awake()
    {
        MeshRenderer = gameObject.AddComponent<MeshRenderer>();
        MeshFilter = gameObject.AddComponent<MeshFilter>();

        mesh = GetMeshInfo();
        ApplyMesh();

        MeshFilter.mesh = mesh;
        MeshRenderer.material = Material;
    }

    public void SetMaterial(Material mat)
    {
        Material = mat;
        MeshRenderer.material = Material;
    }

    private Mesh GetMeshInfo()
    {
        mesh = new Mesh();

        _verts = SphereMesh.vertices;
        _tris = SphereMesh.triangles;
        _norms = SphereMesh.normals;
        _colors = SphereMesh.colors;

        Vector3 res1 = _verts[_tris[0]];
        Vector3 res2 = _verts[_tris[1]];
        Vector3 res3 = _verts[_tris[2]];
        Vector3 center = (res1 + res2 + res3) / 3;
        Vector3 offset1 = res1 - center;
        vertexOffsetToFaceCenter = offset1.magnitude;

        mesh.name = "DynamicSphere";
        return mesh;
    }

    public void VariantFeatures()
    {
        EdgeBorder = Random.Range(-0.1f, 0.3f);
        int[] rpfs = new[] {0, 2, 3, 4, 6};
        RotatePerFrame = rpfs[Random.Range(0, rpfs.Length)];
        ExpandOffset = Random.Range(-1f, 1f);
        ShrinkRatio = Random.Range(-2f, 2f);
    }

    private void Update()
    {
        if (!animationPlaying)
        {
            RefreshBorder();
        }

        if (Input.GetKeyUp(KeyCode.R))
        {
            Animation();
        }

        ApplyMesh();
    }

    private void ApplyMesh()
    {
        mesh.vertices = _verts;
        mesh.triangles = _tris;
        mesh.normals = _norms;
        mesh.colors = _colors;
    }

    private bool animationPlaying = false;

    private void Animation()
    {
        if (!animationPlaying)
        {
            animationPlaying = true;
            StartCoroutine(Co_Animation());
        }
    }

    [Space] [SerializeField] private bool IsShowEdgeBorder = true;
    [SerializeField] private float EdgeBorder = 0.1f;

    [SerializeField] private int AnimationFrameDuration = 20;

    [Space] [SerializeField] private bool RotateTrianglesAnimation = true;
    [SerializeField] private int RotatePerFrame = 6;

    [Space] [SerializeField] private bool ExpandAnimation = true;
    [SerializeField] private float ExpandOffset = 1f;

    [Space] [SerializeField] private bool FaceShrinkAnimation = true;
    [SerializeField] private float ShrinkRatio = 0.1f;

    private float vertexOffsetToFaceCenter;

    private void RefreshBorder()
    {
        for (int i = 0; i < mesh.triangles.Length; i += 3)
        {
            Vector3 res1 = _verts[_tris[i]];
            Vector3 res2 = _verts[_tris[i + 1]];
            Vector3 res3 = _verts[_tris[i + 2]];
            Vector3 center = (res1 + res2 + res3) / 3;
            Vector3 offset1 = res1 - center;
            Vector3 offset2 = res2 - center;
            Vector3 offset3 = res3 - center;

            EdgeBorder = Mathf.Clamp(EdgeBorder, -vertexOffsetToFaceCenter * 0.99f, vertexOffsetToFaceCenter * 0.99f);

            _verts[_tris[i]] = center + offset1.normalized * (vertexOffsetToFaceCenter - (IsShowEdgeBorder ? EdgeBorder : 0));
            _verts[_tris[i + 1]] = center + offset2.normalized * (vertexOffsetToFaceCenter - (IsShowEdgeBorder ? EdgeBorder : 0));
            _verts[_tris[i + 2]] = center + offset3.normalized * (vertexOffsetToFaceCenter - (IsShowEdgeBorder ? EdgeBorder : 0));
        }
    }

    IEnumerator Co_Animation()
    {
        for (int j = 0; j < AnimationFrameDuration; j++)
        {
            for (int i = 0; i < mesh.triangles.Length; i += 3)
            {
                Vector3 res1 = _verts[_tris[i]];
                Vector3 res2 = _verts[_tris[i + 1]];
                Vector3 res3 = _verts[_tris[i + 2]];
                Vector3 center = (res1 + res2 + res3) / 3;
                Vector3 offset1 = res1 - center;
                Vector3 offset2 = res2 - center;
                Vector3 offset3 = res3 - center;
                Vector3 normal = _norms[_tris[i]];

                // Rotate
                if (RotateTrianglesAnimation)
                {
                    Vector3 offset1_afterRot = Quaternion.AngleAxis(RotatePerFrame, normal) * offset1;
                    Vector3 offset2_afterRot = Quaternion.AngleAxis(RotatePerFrame, normal) * offset2;
                    Vector3 offset3_afterRot = Quaternion.AngleAxis(RotatePerFrame, normal) * offset3;

                    res1 = offset1_afterRot + center;
                    res2 = offset2_afterRot + center;
                    res3 = offset3_afterRot + center;
                }

                center = (res1 + res2 + res3) / 3;
                offset1 = res1 - center;
                offset2 = res2 - center;
                offset3 = res3 - center;

                // Move out
                if (ExpandAnimation)
                {
                    int sign = j < AnimationFrameDuration / 2 ? 1 : -1;
                    Vector3 moveOut = normal * ExpandOffset * vertexOffsetToFaceCenter / AnimationFrameDuration * sign;
                    res1 += moveOut;
                    res2 += moveOut;
                    res3 += moveOut;
                }

                center = (res1 + res2 + res3) / 3;
                offset1 = res1 - center;
                offset2 = res2 - center;
                offset3 = res3 - center;

                // Face Shrink
                if (FaceShrinkAnimation)
                {
                    int sign = j < AnimationFrameDuration / 2 ? -1 : 1;
                    float minRatio = ShrinkRatio;
                    float maxRatio = (vertexOffsetToFaceCenter - (IsShowEdgeBorder ? EdgeBorder : 0)) / vertexOffsetToFaceCenter;
                    float length = 0;
                    if (sign > 0)
                    {
                        length = Mathf.Lerp(minRatio, maxRatio, (j - AnimationFrameDuration / 2f) / (AnimationFrameDuration / 2f)) * vertexOffsetToFaceCenter;
                    }
                    else
                    {
                        length = Mathf.Lerp(maxRatio, minRatio, j / (AnimationFrameDuration / 2f)) * vertexOffsetToFaceCenter;
                    }

                    res1 = center + offset1.normalized * length;
                    res2 = center + offset2.normalized * length;
                    res3 = center + offset3.normalized * length;
                }

                center = (res1 + res2 + res3) / 3;
                offset1 = res1 - center;
                offset2 = res2 - center;
                offset3 = res3 - center;

                _verts[_tris[i]] = res1;
                _verts[_tris[i + 1]] = res2;
                _verts[_tris[i + 2]] = res3;
            }

            yield return null;
        }

        animationPlaying = false;
    }
}