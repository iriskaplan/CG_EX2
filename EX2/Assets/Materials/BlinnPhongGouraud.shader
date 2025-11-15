Shader "CG/BlinnPhongGouraud"
{
    Properties
    {
        _DiffuseColor ("Diffuse Color", Color) = (0.14, 0.43, 0.84, 1)
        _SpecularColor ("Specular Color", Color) = (0.7, 0.7, 0.7, 1)
        _AmbientColor ("Ambient Color", Color) = (0.05, 0.13, 0.25, 1)
        _Shininess ("Shininess", Range(0.1, 50)) = 10
    }
    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase" } 

            CGPROGRAM

                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"
                #include "Lighting.cginc"

                // Declare used properties
                uniform fixed4 _DiffuseColor;
                uniform fixed4 _SpecularColor;
                uniform fixed4 _AmbientColor;
                uniform float _Shininess;

                struct appdata
                { 
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                };

                struct v2f
                {
                    float4 pos : SV_POSITION;
                    fixed4 color : COLOR0;
                };


                v2f vert (appdata input)
                {
                    v2f output;
                    // final_color = colord + colors + colora =
                    // max(l · n, 0) ∗ cd ∗ ld + max(r · v, 0)^𝝈 ∗ cs ∗ ls + ca * la
                    float4 colorA = _AmbientColor * _LightColor0;


                    // float3 worldNormal = mul(unity_ObjectToWorld, input.vertex);
                    float3 worldNormal = normalize(mul((float3x3)unity_WorldToObject, input.normal));
                    float normalDotLight = dot(worldNormal, _WorldSpaceLightPos0);
                    float4 colorD = max(normalDotLight, 0.0) * _DiffuseColor * _LightColor0;

                    float3 r = 2 * normalDotLight * worldNormal - _WorldSpaceLightPos0;
                    float4 colorS = pow(max(dot(r, _WorldSpaceCameraPos), 0.0), _Shininess) * _SpecularColor * _LightColor0;
                    // float4 colorS = 0.0;
                    float4 finalColor = colorA + colorD + colorS;
                    output.color = finalColor;
                    
                    output.pos = UnityObjectToClipPos(input.vertex);
                    return output;
                }


                fixed4 frag (v2f input) : SV_Target
                {
                    return input.color;
                }

            ENDCG
        }
    }
}
