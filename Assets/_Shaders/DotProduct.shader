Shader "Custom/DotProduct"
{
   Properties {
       
    }
 
    SubShader {
        Tags {"Queue"="Transparent" "RenderType"="Opaque"}
        LOD 100
 
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityStandardCore.cginc"
 
            // Vertex input
            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
 
            // Vertex output
            struct v2f {
                float3 worldNormal : TEXCOORD0;
                float3 viewDir : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };
 
            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldNormal = normalize(UnityObjectToWorldNormal(v.vertex));
                o.viewDir = normalize(UnityWorldSpaceViewDir(v.vertex.xyz));
                return o;
            }
 
            fixed4 frag (v2f i) : SV_Target {
               float3 albedo = i.worldNormal * i.viewDir;
                return fixed4(albedo, 1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}