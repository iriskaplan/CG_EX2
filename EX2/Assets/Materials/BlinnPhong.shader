Shader "CG/BlinnPhong"
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
                    float3 worldNormal : TEXCOORD0;
                    float3 worldPos : TEXCOORD1;
                };

                // Calculates diffuse lighting of secondary point lights (part 3)
                fixed4 pointLights(v2f input)
                {
                    return fixed4(0, 0, 0, 0);
                }


                v2f vert (appdata input)
                {
                    v2f output;
                    output.worldPos = mul(unity_ObjectToWorld, input.vertex).xyz;
                    output.worldNormal = normalize(mul((float3x3)unity_WorldToObject, input.normal));
                    output.pos = UnityObjectToClipPos(input.vertex);
                    return output;
                }


                fixed4 frag (v2f input) : SV_Target
                {
                    float4 colorA = _AmbientColor * _LightColor0;

                    float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                    float NdotL = max(dot(input.worldNormal, lightDir), 0.0);
                    float4 colorD = NdotL * _DiffuseColor * _LightColor0;
                
                    float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - input.worldPos);
                    float3 refDir = normalize(2 * NdotL * input.worldNormal - lightDir);
                    float4 colorS = pow(max(dot(refDir, viewDir), 0.0), _Shininess) * _SpecularColor * _LightColor0;
                
                    float4 color = colorA + colorD + colorS;
                    return color;
                }

            ENDCG
        }
    }
}
