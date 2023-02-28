Shader "Custom/ViewDir"
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
                float3 worldPos : TEXCOORD0;
            };
 
            // Vertex output
            struct v2f {
                float3 viewDir : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
 
            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.viewDir = normalize(UnityWorldSpaceViewDir(v.worldPos));
                return o;
            }
 
            fixed4 frag (v2f i) : SV_Target {
                return fixed4(i.viewDir, 1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}