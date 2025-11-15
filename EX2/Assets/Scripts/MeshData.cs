using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class MeshData
{
    public List<Vector3> vertices; // The vertices of the mesh 
    public List<int> triangles; // Indices of vertices that make up the mesh faces
    public Vector3[] normals; // The normals of the mesh, one per vertex

    // Class initializer
    public MeshData()
    {
        vertices = new List<Vector3>();
        triangles = new List<int>();
    }

    // Returns a Unity Mesh of this MeshData that can be rendered
    public Mesh ToUnityMesh()
    {
        Mesh mesh = new Mesh
        {
            vertices = vertices.ToArray(),
            triangles = triangles.ToArray(),
            normals = normals
        };

        return mesh;
    }

    // Calculates surface normals for each vertex, according to face orientation
    public void CalculateNormals()
    {
        // normalsForVertices stores for each vertex the 3 normals it should take into account.
        List<List<Vector3>> normalsForVertices = new List<List<Vector3>>(vertices.Count);
        for (int i = 0; i < vertices.Count; i++)
        {
            normalsForVertices.Add(new List<Vector3>());
        }

        // for each triangle
        for (int i = 0; i < triangles.Count; i += 3)
        {
            Vector3 p1 = vertices[triangles[i]];
            Vector3 p2 = vertices[triangles[i + 1]];
            Vector3 p3 = vertices[triangles[i + 2]];

            Vector3 normalTriangle = Vector3.Cross(p1 - p3, p2 - p3).normalized;

            normalsForVertices[triangles[i]].Add(normalTriangle);
            normalsForVertices[triangles[i + 1]].Add(normalTriangle);
            normalsForVertices[triangles[i + 2]].Add(normalTriangle);
        }

        normals = new Vector3[vertices.Count];
        for (int i = 0; i < normalsForVertices.Count; i++)
        {
            Vector3 totalVector = Vector3.zero; 
            foreach (Vector3 vec in normalsForVertices[i])
            {
                totalVector += vec;
            }
            normals[i] = totalVector.normalized;
        }
    }

    // Edits mesh such that each face has a unique set of 3 vertices
    public void MakeFlatShaded()
    {
        // Your implementation
    }
}