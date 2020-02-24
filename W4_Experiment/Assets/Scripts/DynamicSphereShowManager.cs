using UnityEngine;
using System.Collections;
using UnityEngine.SceneManagement;

public class DynamicSphereShowManager : MonoBehaviour
{
    [SerializeField] private GameObject DynamicSphereMeshPrefab;
    [SerializeField] private Material[] Materials;

    void Start()
    {
        float interval_row = 2.5f;
        float interval_col = 2.5f;
        int rowCount = 4;
        int colCount = 6;
        for (int i = 0; i < colCount; i++)
        {
            for (int j = 0; j < rowCount; j++)
            {
                Vector3 pos = new Vector3((i - (colCount + 1) / 2) * interval_col + interval_col / 2f, (j - (rowCount + 1) / 2) * interval_row + interval_row / 2);
                GameObject go = Instantiate(DynamicSphereMeshPrefab, pos, Quaternion.Euler(Random.insideUnitSphere * 360f), transform);
                DynamicSphereMesh dsm = go.GetComponent<DynamicSphereMesh>();
                dsm.VariantFeatures();
                dsm.SetMaterial(Materials[Random.Range(0, Materials.Length)]);
            }
        }
    }

    void Update()
    {
        if (Input.GetKeyUp(KeyCode.F10))
        {
            SceneManager.LoadScene("DynamicSphereDemoScene");
        }
    }
}