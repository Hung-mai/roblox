// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Abi/UnlitSimpleWater"
{
	Properties
	{
		_DeepColor("DeepColor", Color) = (0,0,0,0)
		_FoamColor("FoamColor", Color) = (0.3160377,0.6601052,1,0)
		_ShoreFoamColor("ShoreFoamColor", Color) = (0,0,0,0)
		_ShoreColor("ShoreColor", Color) = (0.2551619,0.8867924,0.5952706,0)
		_Distance("Distance", Float) = 0
		_ShoreFoamOffset("ShoreFoamOffset", Float) = 0
		_DistanceShore("DistanceShore", Float) = 0
		_ShoreFoamSpeed("ShoreFoamSpeed", Float) = 0.2
		_FoamSpeed("FoamSpeed", Float) = 0.2
		_ShoreFoamScale("ShoreFoamScale", Float) = 1
		_FoamTiling1("FoamTiling1", Vector) = (1,1,0,0)
		_FoamTiling2("FoamTiling2", Vector) = (1,1,0,0)
		_FoamAmount("FoamAmount", Range( 0 , 1)) = 0.1
		_Opacity("Opacity", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent-1" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float4 screenPos;
		};

		uniform float _ShoreFoamSpeed;
		uniform float _ShoreFoamScale;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Distance;
		uniform float _ShoreFoamOffset;
		uniform float4 _ShoreFoamColor;
		uniform float _DistanceShore;
		uniform float4 _ShoreColor;
		uniform float4 _DeepColor;
		uniform float4 _FoamColor;
		uniform float _FoamAmount;
		uniform float2 _FoamTiling1;
		uniform float _FoamSpeed;
		uniform float2 _FoamTiling2;
		uniform float _Opacity;


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


		float Unity_GradientNoise_float54_g10( float2 UV, float Scale )
		{
			return unity_gradientNoise(UV * Scale) + 0.5;
		}


		float2 UnStereo( float2 UV )
		{
			#if UNITY_SINGLE_PASS_STEREO
			float4 scaleOffset = unity_StereoScaleOffset[ unity_StereoEyeIndex ];
			UV.xy = (UV.xy - scaleOffset.zw) / scaleOffset.xy;
			#endif
			return UV;
		}


		float3 InvertDepthDir72_g7( float3 In )
		{
			float3 result = In;
			#if !defined(ASE_SRP_VERSION) || ASE_SRP_VERSION <= 70301
			result *= float3(1,1,-1);
			#endif
			return result;
		}


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime251 = _Time.y * _ShoreFoamSpeed;
			float2 UV54_g10 = ( i.uv_texcoord + mulTime251 );
			float Scale54_g10 = _ShoreFoamScale;
			float localUnity_GradientNoise_float54_g10 = Unity_GradientNoise_float54_g10( UV54_g10 , Scale54_g10 );
			float3 ase_worldPos = i.worldPos;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 UV22_g8 = ase_screenPosNorm.xy;
			float2 localUnStereo22_g8 = UnStereo( UV22_g8 );
			float2 break64_g7 = localUnStereo22_g8;
			float clampDepth69_g7 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy );
			#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g7 = ( 1.0 - clampDepth69_g7 );
			#else
				float staticSwitch38_g7 = clampDepth69_g7;
			#endif
			float3 appendResult39_g7 = (float3(break64_g7.x , break64_g7.y , staticSwitch38_g7));
			float4 appendResult42_g7 = (float4((appendResult39_g7*2.0 + -1.0) , 1.0));
			float4 temp_output_43_0_g7 = mul( unity_CameraInvProjection, appendResult42_g7 );
			float3 In72_g7 = ( (temp_output_43_0_g7).xyz / (temp_output_43_0_g7).w );
			float3 localInvertDepthDir72_g7 = InvertDepthDir72_g7( In72_g7 );
			float4 appendResult49_g7 = (float4(localInvertDepthDir72_g7 , 1.0));
			float temp_output_190_0 = ( ase_worldPos.y - mul( unity_CameraToWorld, appendResult49_g7 ).y );
			float temp_output_256_0 = step( 1.0 , ( ( localUnity_GradientNoise_float54_g10 + saturate( ( temp_output_190_0 / _Distance ) ) ) * ( temp_output_190_0 / _ShoreFoamOffset ) ) );
			float temp_output_58_0_g15 = (-3.25 + (( 1.0 - _FoamAmount ) - 0.0) * (1.25 - -3.25) / (1.0 - 0.0));
			float temp_output_59_0_g15 = 1.0;
			float2 temp_output_121_0_g15 = float2( 0,0 );
			float2 appendResult46_g15 = (float2(_FoamTiling1.x , _FoamTiling1.y));
			float mulTime42_g15 = _Time.y * _FoamSpeed;
			float2 appendResult45_g15 = (float2(mulTime42_g15 , 0.0));
			float2 uv_TexCoord49_g15 = i.uv_texcoord * appendResult46_g15 + appendResult45_g15;
			float simplePerlin2D43_g15 = snoise( ( temp_output_121_0_g15 + uv_TexCoord49_g15 ) );
			float2 appendResult114_g15 = (float2(_FoamTiling2.x , _FoamTiling2.y));
			float2 uv_TexCoord47_g15 = i.uv_texcoord * appendResult114_g15 + (appendResult45_g15).yx;
			float simplePerlin2D50_g15 = snoise( ( temp_output_121_0_g15 + uv_TexCoord47_g15 ) );
			float temp_output_36_0_g15 = ( simplePerlin2D43_g15 - ( simplePerlin2D50_g15 * 0.25 ) );
			float smoothstepResult53_g15 = smoothstep( min( temp_output_58_0_g15 , temp_output_59_0_g15 ) , max( temp_output_58_0_g15 , temp_output_59_0_g15 ) , temp_output_36_0_g15);
			float4 lerpResult267 = lerp( _DeepColor , _FoamColor , step( 0.5 , smoothstepResult53_g15 ));
			o.Emission = ( ( ( 1.0 - temp_output_256_0 ) * _ShoreFoamColor ) + ( temp_output_256_0 * ( ( 1.0 - saturate( (0.5 + (( temp_output_190_0 / _DistanceShore ) - 0.5) * (1.5 - 0.5) / (1.0 - 0.5)) ) ) * _ShoreColor ) ) + ( lerpResult267 * temp_output_256_0 ) ).rgb;
			o.Alpha = _Opacity;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18702
2415;182;1424;1019;2341.42;-181.8632;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;195;-2359.601,493.2843;Inherit;False;1003.119;558.0005;Depth Ortho;8;182;194;288;190;181;230;188;229;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;229;-2345.601,726.0842;Inherit;False;Reconstruct World Position From Depth;-1;;7;e7094bcbcc80eb140b2a3dbe6a861de8;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;260;-2299.523,-76.37863;Inherit;False;938.4678;494.0369;Noise;6;257;251;252;258;250;249;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;188;-2223.992,548.8743;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;230;-2001.093,715.8733;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;252;-2249.523,168.545;Inherit;False;Property;_ShoreFoamSpeed;ShoreFoamSpeed;7;0;Create;True;0;0;False;0;False;0.2;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;190;-1827.401,606.2838;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;250;-2085.646,-26.37863;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;181;-1828.065,733.1671;Inherit;False;Property;_Distance;Distance;4;0;Create;True;0;0;False;0;False;0;1.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;272;-2681.774,-952.0563;Inherit;False;1353.961;742.7651;Surface;10;276;323;267;270;241;264;266;273;271;325;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;251;-2033.751,143.2847;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;257;-1900.087,290.5468;Inherit;False;Property;_ShoreFoamScale;ShoreFoamScale;9;0;Create;True;0;0;False;0;False;1;70;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;288;-1594.478,855.0789;Inherit;False;Property;_DistanceShore;DistanceShore;6;0;Create;True;0;0;False;0;False;0;2.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;182;-1659.264,673.367;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;276;-2589.463,-528.6569;Inherit;False;Property;_FoamAmount;FoamAmount;12;0;Create;True;0;0;False;0;False;0.1;0.4722426;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;258;-1781.633,93.09358;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;325;-2391.322,-373.6299;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;286;-1328.874,769.3741;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;249;-1625.055,163.6583;Inherit;True;GradientNoise;-1;;10;73bcad20642e36b47bcbf1cdbeca1c3f;0;2;2;FLOAT2;0,0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;329;-1453.62,670.8159;Inherit;False;Property;_ShoreFoamOffset;ShoreFoamOffset;5;0;Create;True;0;0;False;0;False;0;0.62;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;194;-1523.697,551.9692;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;330;-1228.819,584.0158;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;271;-2199.774,-618.585;Inherit;False;Property;_FoamTiling2;FoamTiling2;11;0;Create;True;0;0;False;0;False;1,1;10,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TFHCRemapNode;304;-1277.64,969.8889;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;266;-2191.627,-804.59;Inherit;False;Property;_FoamTiling1;FoamTiling1;10;0;Create;True;0;0;False;0;False;1,1;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;273;-2228.463,-469.6569;Inherit;False;Property;_FoamSpeed;FoamSpeed;8;0;Create;True;0;0;False;0;False;0.2;0.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;323;-2216.322,-383.6299;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-3.25;False;4;FLOAT;1.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;254;-1298.075,266.3688;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;287;-1150.094,772.4866;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;264;-1970.993,-537.553;Inherit;True;WaveyNoise;-1;;15;9dc2d18825a682f48bbca186d0eb3c42;2,115,1,106,1;9;121;FLOAT2;0,0;False;60;FLOAT;1;False;61;FLOAT;1;False;62;FLOAT;1;False;112;FLOAT;1;False;113;FLOAT;1;False;109;FLOAT;0.3;False;58;FLOAT;0.1;False;59;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;328;-1114.198,540.0953;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;300;-980.4943,1085.104;Inherit;False;Property;_ShoreColor;ShoreColor;3;0;Create;True;0;0;False;0;False;0.2551619,0.8867924,0.5952706,0;0,0.1788098,0.2641509,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;241;-1939.374,-902.0563;Inherit;False;Property;_DeepColor;DeepColor;0;0;Create;True;0;0;False;0;False;0,0,0,0;0.2363831,0.3311954,0.6037736,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;274;-1508.763,-512.9569;Inherit;True;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;270;-1937.46,-721.7343;Inherit;False;Property;_FoamColor;FoamColor;1;0;Create;True;0;0;False;0;False;0.3160377,0.6601052,1,0;0.3160377,0.6601052,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;302;-973.7,863.5403;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;256;-1021.192,261.5621;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;295;-660.9559,281.6605;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;267;-1518.861,-766.8135;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;242;-739.5574,435.6561;Inherit;False;Property;_ShoreFoamColor;ShoreFoamColor;2;0;Create;True;0;0;False;0;False;0,0,0,0;0.4196079,0.9063407,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;301;-751.9106,949.2249;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;317;-384.9917,83.85774;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;307;-465.4272,419.4916;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;309;-306.9639,517.11;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;313;-87.26876,428.3456;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;228;148.8252,651.9099;Inherit;False;Property;_Opacity;Opacity;13;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;238;227.5099,216.7841;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Abi/UnlitSimpleWater;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;-1;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;230;0;229;0
WireConnection;190;0;188;2
WireConnection;190;1;230;1
WireConnection;251;0;252;0
WireConnection;182;0;190;0
WireConnection;182;1;181;0
WireConnection;258;0;250;0
WireConnection;258;1;251;0
WireConnection;325;0;276;0
WireConnection;286;0;190;0
WireConnection;286;1;288;0
WireConnection;249;2;258;0
WireConnection;249;3;257;0
WireConnection;194;0;182;0
WireConnection;330;0;190;0
WireConnection;330;1;329;0
WireConnection;304;0;286;0
WireConnection;323;0;325;0
WireConnection;254;0;249;0
WireConnection;254;1;194;0
WireConnection;287;0;304;0
WireConnection;264;60;273;0
WireConnection;264;61;266;1
WireConnection;264;62;266;2
WireConnection;264;112;271;1
WireConnection;264;113;271;2
WireConnection;264;58;323;0
WireConnection;328;0;254;0
WireConnection;328;1;330;0
WireConnection;274;1;264;0
WireConnection;302;0;287;0
WireConnection;256;1;328;0
WireConnection;295;0;256;0
WireConnection;267;0;241;0
WireConnection;267;1;270;0
WireConnection;267;2;274;0
WireConnection;301;0;302;0
WireConnection;301;1;300;0
WireConnection;317;0;267;0
WireConnection;317;1;256;0
WireConnection;307;0;295;0
WireConnection;307;1;242;0
WireConnection;309;0;256;0
WireConnection;309;1;301;0
WireConnection;313;0;307;0
WireConnection;313;1;309;0
WireConnection;313;2;317;0
WireConnection;238;2;313;0
WireConnection;238;9;228;0
ASEEND*/
//CHKSM=A7187FA3F8653B282782C57333DEF8B314895EC7