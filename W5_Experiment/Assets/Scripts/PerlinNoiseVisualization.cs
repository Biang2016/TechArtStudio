using UnityEngine;

[ExecuteInEditMode]
public class PerlinNoiseVisualization : MonoBehaviour
{
    public GameObject Marker;
    public int startingVal;
    public int endVal;

    public float heightScale;
    public float widthScale;

    void Start()
    {
        for (int i = 0; i < transform.childCount; i++)
        {
            DestroyImmediate(transform.GetChild(i).gameObject);
        }

        // OneDimension();
        TwoDimension();
    }

    private void OneDimension()
    {
        for (float i = startingVal; i <= endVal; i += 0.01f)
        {
            GameObject tempMarker = Instantiate(Marker);
            float xPos = i * widthScale * 5;
            float yPos = Perlin.Noise(i) * heightScale * 5;
            Vector3 markerPos = new Vector3(xPos, yPos);
            tempMarker.transform.position = markerPos;
            tempMarker.transform.SetParent(transform);
        }
    }

    private void TwoDimension()
    {
        for (float i = startingVal; i <= endVal; i += 0.2f)
        {
            for (float j = startingVal; j <= endVal; j += 0.2f)
            {
                GameObject tempMarker = Instantiate(Marker);
                float xPos = i * widthScale;
                float zPos = j * widthScale;
                float yPos = Perlin.Noise(i, j) * heightScale;

                float xMask = i + 545.25f;
                float zMask = j + 545.25f;
                float yMask = Perlin.Noise(xMask / 5, zMask / 5);

                float xOct = i + 25.87f;
                float zOct = j + 25.87f;

                float yOct = Perlin.Noise(xOct / 3, zOct / 3);

                Vector3 markerPos = new Vector3(xPos, yPos * yMask + yOct * 5, zPos);
                tempMarker.transform.position = markerPos;
                tempMarker.transform.SetParent(transform);
            }
        }
    }
}