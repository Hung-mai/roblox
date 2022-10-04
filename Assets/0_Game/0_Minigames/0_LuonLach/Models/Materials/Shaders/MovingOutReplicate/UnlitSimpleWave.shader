// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Abi/UnlitSimpleWave"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)
		_WaveMask("WaveMask", 2D) = "white" {}
		_WaveFrequency("WaveFrequency", Float) = 2
		_WaveDensity("WaveDensity", Float) = 1
		_WaveStrength("WaveStrength", Vector) = (0.5,0,0.5,0)
		_OpacityClip("OpacityClip", Range( 0 , 1)) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _WaveFrequency;
		uniform float _WaveDensity;
		uniform float3 _WaveStrength;
		uniform sampler2D _WaveMask;
		uniform float4 _WaveMask_ST;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Tint;
		uniform float _OpacityClip;


		float2 unity_gradientNoise_dir( float2 p )
		{
			p = p % 289;
			float x = (34 * p.x + 1) * p.x % 289 + p.y;
			x = (34 * x + 1) * x % 289;
			x = frac(x / 41) * 2 - 1;
			return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
		}


		float unity_gradientNoise( float2 p )
		{
			float2 ip = floor(p);
			float2 fp = frac(p);
			float d00 = dot(unity_gradientNoise_dir(ip), fp);
			float d01 = dot(unity_gradientNoise_dir(ip + float2(0, 1)), fp - float2(0, 1));
			float d10 = dot(unity_gradientNoise_dir(ip + float2(1, 0)), fp - float2(1, 0));
			float d11 = dot(unity_gradientNoise_dir(ip + float2(1, 1)), fp - float2(1, 1));
			fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
			return lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x);
		}


		float Unity_GradientNoise_float54_g5( float2 UV, float Scale )
		{
			return unity_gradientNoise(UV * Scale) + 0.5;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (( _Time.y * _WaveFrequency )).xx;
			float2 uv_TexCoord10 = v.texcoord.xy + temp_cast_0;
			float2 UV54_g5 = uv_TexCoord10;
			float Scale54_g5 = _WaveDensity;
			float localUnity_GradientNoise_float54_g5 = Unity_GradientNoise_float54_g5( UV54_g5 , Scale54_g5 );
			float2 uv_WaveMask = v.texcoord * _WaveMask_ST.xy + _WaveMask_ST.zw;
			float3 lerpResult22 = lerp( float3( 0,0,0 ) , ( ( localUnity_GradientNoise_float54_g5 - 0.5 ) * _WaveStrength ) , tex2Dlod( _WaveMask, float4( uv_WaveMask, 0, 0.0) ).rgb);
			v.vertex.xyz += lerpResult22;
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			o.Emission = ( tex2DNode1 * _Tint ).rgb;
			o.Alpha = 1;
			clip( tex2DNode1.a - _OpacityClip );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18600
2416;0;1423;1019;1605.179;1114.333;1.946525;True;False
Node;AmplifyShaderEditor.CommentaryNode;14;-1902.818,-32.56837;Inherit;False;1709.26;778.6232;Noise;11;12;7;5;26;10;23;19;18;20;22;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1833.618,311.7263;Inherit;False;Property;_WaveFrequency;WaveFrequency;3;0;Create;True;0;0;False;0;False;2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;5;-1818.218,200.4266;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1621.201,202.2742;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1395.755,260.7577;Inherit;False;Property;_WaveDensity;WaveDensity;4;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1408.009,109.1318;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;26;-1184.663,141.3643;Inherit;True;GradientNoise;-1;;5;73bcad20642e36b47bcbf1cdbeca1c3f;0;2;2;FLOAT2;0,0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;12;-926.7538,32.51245;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;4;-1092.454,-769.7979;Inherit;False;752.9745;544.184;Color;4;1;3;2;27;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;19;-907.9237,306.1737;Inherit;False;Property;_WaveStrength;WaveStrength;5;0;Create;True;0;0;False;0;False;0.5,0,0.5;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;2;-995.0557,-413.6974;Inherit;False;Property;_Tint;Tint;1;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;20;-813.9568,500.4071;Inherit;True;Property;_WaveMask;WaveMask;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1016.064,-683.6489;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-694.6864,182.6966;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;22;-436.4294,335.8336;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-580.6764,-528.4393;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-777.4525,-316.306;Inherit;False;Property;_OpacityClip;OpacityClip;6;0;Create;True;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Abi/UnlitSimpleWave;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;Opaque;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;True;27;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;5;0
WireConnection;8;1;7;0
WireConnection;10;1;8;0
WireConnection;26;2;10;0
WireConnection;26;3;23;0
WireConnection;12;0;26;0
WireConnection;18;0;12;0
WireConnection;18;1;19;0
WireConnection;22;1;18;0
WireConnection;22;2;20;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;0;2;3;0
WireConnection;0;10;1;4
WireConnection;0;11;22;0
ASEEND*/
//CHKSM=764D353EEDA331D644EFD72626C139D78602A9C4