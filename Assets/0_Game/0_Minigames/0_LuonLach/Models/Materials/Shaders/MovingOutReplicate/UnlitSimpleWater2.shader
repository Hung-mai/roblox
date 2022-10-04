// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Abi/UnlitSimpleWater2"
{
	Properties
	{
		_NoiseTexture("NoiseTexture", 2D) = "white" {}
		_DeepColor("DeepColor", Color) = (0,0,0,0)
		_FoamColor("FoamColor", Color) = (0.3160377,0.6601052,1,0)
		_ShoreFoamColor("ShoreFoamColor", Color) = (0,0,0,0)
		_ShoreColor("ShoreColor", Color) = (0.2551619,0.8867924,0.5952706,0)
		_Distance("Distance", Float) = 0
		_ShoreFoamOffset("ShoreFoamOffset", Float) = 0
		_DistanceShore("DistanceShore", Float) = 0
		_ShoreFoamSpeed("ShoreFoamSpeed", Float) = 0.2
		_FoamTiling1("FoamTiling1", Vector) = (1,1,0,0)
		_FoamTiling2("FoamTiling2", Vector) = (1,1,0,0)
		_FoamAmount("FoamAmount", Range( 0 , 1)) = 0.1
		_Opacity("Opacity", Range( 0 , 1)) = 0
		_FoamSpeed("FoamSpeed", Float) = 1
		_Texture0("Texture 0", 2D) = "white" {}
		_ShoreFoamScale("ShoreFoamScale", Float) = 0
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

		uniform sampler2D _NoiseTexture;
		SamplerState sampler_NoiseTexture;
		uniform float _ShoreFoamScale;
		uniform float _ShoreFoamSpeed;
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
		uniform sampler2D _Texture0;
		uniform float2 _FoamTiling1;
		uniform float _FoamSpeed;
		uniform float2 _FoamTiling2;
		uniform float _Opacity;


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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 temp_cast_0 = (_ShoreFoamScale).xx;
			float2 uv_TexCoord250 = i.uv_texcoord * temp_cast_0;
			float mulTime251 = _Time.y * _ShoreFoamSpeed;
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
			float myDepth361 = ( ase_worldPos.y - mul( unity_CameraToWorld, appendResult49_g7 ).y );
			float temp_output_256_0 = step( 1.0 , ( ( tex2D( _NoiseTexture, ( uv_TexCoord250 + mulTime251 ) ).r + saturate( ( myDepth361 / _Distance ) ) ) * ( myDepth361 / _ShoreFoamOffset ) ) );
			float4 appendResult353 = (float4(( _FoamSpeed * _Time.y ) , 0.0 , 0.0 , 0.0));
			float2 uv_TexCoord344 = i.uv_texcoord * _FoamTiling1 + appendResult353.xy;
			float4 appendResult352 = (float4(0.0 , ( _Time.y * _FoamSpeed ) , 0.0 , 0.0));
			float2 uv_TexCoord345 = i.uv_texcoord * _FoamTiling2 + appendResult352.xy;
			float4 lerpResult267 = lerp( _DeepColor , _FoamColor , step( (-3.25 + (( 1.0 - _FoamAmount ) - 0.0) * (1.25 - -3.25) / (1.0 - 0.0)) , ( tex2D( _Texture0, uv_TexCoord344 ).r - tex2D( _Texture0, uv_TexCoord345 ).r ) ));
			o.Emission = ( ( ( 1.0 - temp_output_256_0 ) * _ShoreFoamColor ) + ( temp_output_256_0 * ( ( 1.0 - saturate( (0.5 + (( myDepth361 / _DistanceShore ) - 0.5) * (1.5 - 0.5) / (1.0 - 0.5)) ) ) * _ShoreColor ) ) + ( lerpResult267 * temp_output_256_0 ) ).rgb;
			o.Alpha = _Opacity;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18702
1920;182;1920;1019;4225.867;727.7884;2.210783;True;False
Node;AmplifyShaderEditor.FunctionNode;229;-3399.501,383.5843;Inherit;True;Reconstruct World Position From Depth;-1;;7;e7094bcbcc80eb140b2a3dbe6a861de8;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;230;-3008.993,495.3733;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WorldPosInputsNode;188;-3040.892,282.0744;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;190;-2794.201,417.0839;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;272;-3830.646,-1095.867;Inherit;False;2546.31;883.803;Surface;21;348;323;337;325;336;356;345;276;344;352;353;340;343;347;266;271;339;341;267;241;270;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;260;-2299.523,-76.37863;Inherit;False;938.4678;494.0369;Noise;6;251;252;258;250;331;363;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;339;-3641.008,-452.6156;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;361;-2602.798,541.1429;Inherit;False;myDepth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;195;-2359.601,493.2843;Inherit;False;1003.119;558.0005;Depth Ortho;5;182;194;288;181;362;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;341;-3649.907,-572.9158;Inherit;False;Property;_FoamSpeed;FoamSpeed;13;0;Create;True;0;0;False;0;False;1;0.005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;252;-2249.523,168.545;Inherit;False;Property;_ShoreFoamSpeed;ShoreFoamSpeed;8;0;Create;True;0;0;False;0;False;0.2;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;363;-2278.729,15.38739;Inherit;False;Property;_ShoreFoamScale;ShoreFoamScale;15;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;340;-3388.808,-396.7157;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;251;-2033.751,143.2847;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;343;-3390.108,-561.816;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;362;-2239.098,561.4429;Inherit;False;361;myDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;250;-2085.646,-26.37863;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;181;-1828.065,733.1671;Inherit;False;Property;_Distance;Distance;5;0;Create;True;0;0;False;0;False;0;1.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;352;-3202.57,-369.0559;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;182;-1659.264,673.367;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;353;-3205.57,-715.056;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;258;-1843.633,52.09358;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;271;-3616.175,-736.6182;Inherit;False;Property;_FoamTiling2;FoamTiling2;10;0;Create;True;0;0;False;0;False;1,1;0.2,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;288;-1594.478,855.0789;Inherit;False;Property;_DistanceShore;DistanceShore;7;0;Create;True;0;0;False;0;False;0;2.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;266;-3613.028,-894.6238;Inherit;False;Property;_FoamTiling1;FoamTiling1;9;0;Create;True;0;0;False;0;False;1,1;0.04,0.04;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;276;-3078.908,-1035.743;Inherit;False;Property;_FoamAmount;FoamAmount;11;0;Create;True;0;0;False;0;False;0.1;0.2604779;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;344;-3041.11,-828.1161;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;356;-3056.485,-702.8328;Inherit;True;Property;_Texture0;Texture 0;14;0;Create;True;0;0;False;0;False;None;af30add334abc164e9a3e2c59c340c62;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleDivideOpNode;286;-1328.874,769.3741;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;194;-1533.697,546.9692;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;329;-1453.62,670.8159;Inherit;False;Property;_ShoreFoamOffset;ShoreFoamOffset;6;0;Create;True;0;0;False;0;False;0;0.62;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;331;-1678.474,106.6165;Inherit;True;Property;_NoiseTexture;NoiseTexture;0;0;Create;True;0;0;False;0;False;-1;None;b2030a7bbac81e24aa2a6b3afd56a51b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;345;-3056.607,-489.1161;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;337;-2815.053,-514.4941;Inherit;True;Property;_WaveyNoise2;WaveyNoise2;14;0;Create;True;0;0;False;0;False;-1;None;620911ce7f1495d4692f97645cf61923;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;336;-2788.953,-777.0944;Inherit;True;Property;_WaveyNoise;WaveyNoise;13;0;Create;True;0;0;False;0;False;-1;None;af30add334abc164e9a3e2c59c340c62;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;304;-1277.64,969.8889;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;325;-2767.562,-1035.204;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;330;-1228.819,584.0158;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;254;-1298.075,266.3688;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;287;-1150.094,772.4866;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;328;-1114.198,540.0953;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;323;-2592.561,-1045.204;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-3.25;False;4;FLOAT;1.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;348;-2413.335,-654.5126;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;302;-973.7,863.5403;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;300;-980.4943,1085.104;Inherit;False;Property;_ShoreColor;ShoreColor;4;0;Create;True;0;0;False;0;False;0.2551619,0.8867924,0.5952706,0;0,0.1788098,0.2641509,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;270;-1893.983,-865.5445;Inherit;False;Property;_FoamColor;FoamColor;2;0;Create;True;0;0;False;0;False;0.3160377,0.6601052,1,0;0.3160377,0.6601052,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;241;-1895.897,-1045.867;Inherit;False;Property;_DeepColor;DeepColor;1;0;Create;True;0;0;False;0;False;0,0,0,0;0.2363831,0.3311954,0.6037736,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;347;-2187.479,-900.3406;Inherit;True;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;256;-1021.192,261.5621;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;242;-739.5574,435.6561;Inherit;False;Property;_ShoreFoamColor;ShoreFoamColor;3;0;Create;True;0;0;False;0;False;0,0,0,0;0.4196079,0.9063407,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;301;-751.9106,949.2249;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;267;-1475.384,-910.6237;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;295;-660.9559,281.6605;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;307;-465.4272,419.4916;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;317;-384.9917,83.85774;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;309;-306.9639,517.11;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;313;-87.26876,428.3456;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;228;-127.1748,655.9099;Inherit;False;Property;_Opacity;Opacity;12;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;238;227.5099,216.7841;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Abi/UnlitSimpleWater2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;-1;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;230;0;229;0
WireConnection;190;0;188;2
WireConnection;190;1;230;1
WireConnection;361;0;190;0
WireConnection;340;0;339;0
WireConnection;340;1;341;0
WireConnection;251;0;252;0
WireConnection;343;0;341;0
WireConnection;343;1;339;0
WireConnection;250;0;363;0
WireConnection;352;1;340;0
WireConnection;182;0;362;0
WireConnection;182;1;181;0
WireConnection;353;0;343;0
WireConnection;258;0;250;0
WireConnection;258;1;251;0
WireConnection;344;0;266;0
WireConnection;344;1;353;0
WireConnection;286;0;362;0
WireConnection;286;1;288;0
WireConnection;194;0;182;0
WireConnection;331;1;258;0
WireConnection;345;0;271;0
WireConnection;345;1;352;0
WireConnection;337;0;356;0
WireConnection;337;1;345;0
WireConnection;336;0;356;0
WireConnection;336;1;344;0
WireConnection;304;0;286;0
WireConnection;325;0;276;0
WireConnection;330;0;362;0
WireConnection;330;1;329;0
WireConnection;254;0;331;1
WireConnection;254;1;194;0
WireConnection;287;0;304;0
WireConnection;328;0;254;0
WireConnection;328;1;330;0
WireConnection;323;0;325;0
WireConnection;348;0;336;1
WireConnection;348;1;337;1
WireConnection;302;0;287;0
WireConnection;347;0;323;0
WireConnection;347;1;348;0
WireConnection;256;1;328;0
WireConnection;301;0;302;0
WireConnection;301;1;300;0
WireConnection;267;0;241;0
WireConnection;267;1;270;0
WireConnection;267;2;347;0
WireConnection;295;0;256;0
WireConnection;307;0;295;0
WireConnection;307;1;242;0
WireConnection;317;0;267;0
WireConnection;317;1;256;0
WireConnection;309;0;256;0
WireConnection;309;1;301;0
WireConnection;313;0;307;0
WireConnection;313;1;309;0
WireConnection;313;2;317;0
WireConnection;238;2;313;0
WireConnection;238;9;228;0
ASEEND*/
//CHKSM=BA0CC8418EDCAEEF36CD451B9414E3B84E29B636