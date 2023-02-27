Shader "Custom/Water"
{
     Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "white" {}
        _DisplacementMap("DisplacementMap",2D)="black"{}
        _DisplacementStrength("Displacement Strength", Range(0.0,1.0))=0.5
        _WaveV("V", Range(0.1,10.0))=1.0
        _WaveM("M", Range(0.1,10.0))=1.0
        _WaveZ("Z", Range(0.0,1.0))=0.1
    }
    SubShader
    {
        
    Pass{
            CGPROGRAM

                      
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #include "UnityCG.cginc"

            struct Input
            {
                float2 uv_MainTex;
                float2 uv_DisplacementMap;
            };

            struct appdata{
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

             struct v2f
            {
                float2 uv :TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _DisplacementMap;
            float4 _MainTex_ST;
            float4 _DisplacementMap_ST;
            float _DisplacementStrength;
            float _WaveV;
            float _WaveM;
            float _WaveZ;

        v2f vert(appdata v)
        {
            v2f o;
            o.uv = TRANSFORM_TEX(v.uv, _MainTex);                
            UNITY_TRANSFER_FOG(o,o.vertex);
            float displacement = tex2Dlod(_DisplacementMap,float4(o.uv,0,0)).r;
            
            //Time 
            float time = _Time.y;
            //Wave Calculation: Sin(x*v + m) * z
            float waveDisplacement = sin((v.vertex.x * _WaveV) + (time * _WaveM)) * _WaveZ;
            v.vertex.xyz += v.normal * waveDisplacement;

            float4 temp = float4(v.vertex.x,v.vertex.y,v.vertex.z,1.0);                
            temp.xyz += waveDisplacement * v.normal * _DisplacementStrength;
            o.vertex = UnityObjectToClipPos(temp);
            return o;

        }

        fixed4 frag(v2f i):SV_Target
        {                
                fixed4 col=tex2D(_MainTex,i.uv);
                UNITY_APPLY_FOG(i.fogCoord,col)
                return col;
        }
        ENDCG
    }
    }
    FallBack "Diffuse"
    
}