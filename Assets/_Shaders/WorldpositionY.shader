Shader "Custom/WorldpositionY"
{
   Properties {
       _Color1 ("Color when WorldPos y > 0", Color) = (1,1,1,1)
       _Color2 ("Color when WorldPos y <= 0", Color) = (0,0,0,1)
    }
 
    SubShader {
        Tags {"Queue"="Transparent" "RenderType"="Opaque"}
        LOD 100
 
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityStandardCore.cginc"
 
            float4 _Color1;
            float4 _Color2;
 
            // Vertex input
            struct appdata {
                float4 vertex : POSITION;
                float3 worldPos : TEXCOORD0;
            };
 
            // Vertex output
            struct v2f {
                float3 worldPos : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
 
            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }
 
            fixed4 frag (v2f i) : SV_Target {
                float y = i.worldPos.y;
                if(y>0)
                {
                    return _Color1;
                }
                else
                {
                    return _Color2;
                }
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}