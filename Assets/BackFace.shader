Shader "Unlit/BackFace"
{
	Properties
	{
		_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_MainTex ("Texture", 2D) = "white" {}
		_Scale("Scale", Range(0.5,500.0)) = 3.0
		_Speed("Speed", Range(-50,50.0)) = 1.0
		_BandStrength("BandStrength", Range(0,1)) = 0.5
	}
	SubShader
	{
		Tags{ "RenderType" = "Transparent" "Queue" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		LOD 100
		Cull Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			#define M_PI 3.1415926535897932384626433832795

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			float4 _Color;
			half _Scale;
			half _Speed;
			half _BandStrength;

			sampler2D _MainTex;
			float4 _MainTex_ST;

			uniform float _TimeOffsets[10];
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				half2 uv = (i.uv - 0.5) * _Scale;
				half r = sqrt(uv.x*uv.x + uv.y*uv.y);

				float z = 0.0;

				for (int i = 0; i < 10; i++) { //length of our array
					float t = _Time[1] - _TimeOffsets[i];
					float tFunction = max(0.0, t) * _Speed;
					float signFunction = max(0.0, r * sign(t)) - tFunction;
					if (signFunction > t) { signFunction = 0.0; };
					if (r < tFunction) { signFunction = 0.0; };

					z = min (1.0, z + _BandStrength*sin(signFunction));
				}

				float3 color = _Color.rgb + max(0.0, z);

				// sample the texture
				fixed4 col = float4(color, _Color.a);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
