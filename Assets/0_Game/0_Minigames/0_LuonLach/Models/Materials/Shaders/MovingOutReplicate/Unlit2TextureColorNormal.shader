// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Abi/Unlit 2 Textures Color Normal"
{
	Properties
	{
		_Color("_Color", Color) = (1,1,1,1)
		_MainTex("_MainTex", 2D) = "white" {}
		_MatCap("MatCap", 2D) = "white" {}
		_SecondaryTexture("SecondaryTexture", 2D) = "white" {}
		_Mask("Mask", 2D) = "black" {}
		_ColorR("ColorR", Color) = (0,0,0,0)
		_FillR("FillR", Range( 0 , 1)) = 0
		_ColorG("ColorG", Color) = (0,0,0,0)
		_FillG("FillG", Range( 0 , 1)) = 0
		_ColorB("ColorB", Color) = (0,0,0,0)
		_FillB("FillB", Range( 0 , 1)) = 0
		_ColorA("ColorA", Color) = (0,0,0,0)
		_FillA("FillA", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldNormal;
			float2 uv_texcoord;
		};

		uniform sampler2D _MatCap;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Color;
		uniform sampler2D _SecondaryTexture;
		uniform float4 _SecondaryTexture_ST;
		uniform float4 _ColorR;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform float _FillR;
		uniform float4 _ColorG;
		uniform float _FillG;
		uniform float4 _ColorB;
		uniform float _FillB;
		uniform float4 _ColorA;
		uniform float _FillA;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 break59 = mul( UNITY_MATRIX_V, float4( ase_normWorldNormal , 0.0 ) ).xyz;
			float4 appendResult61 = (float4(break59.x , break59.y , 0.0 , 0.0));
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 uv_SecondaryTexture = i.uv_texcoord * _SecondaryTexture_ST.xy + _SecondaryTexture_ST.zw;
			float4 tex2DNode26 = tex2D( _SecondaryTexture, uv_SecondaryTexture );
			float2 uv_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			float4 tex2DNode28 = tex2D( _Mask, uv_Mask );
			float4 lerpResult27 = lerp( ( tex2D( _MainTex, uv_MainTex ) * _Color ) , ( tex2DNode26 * _ColorR ) , ( tex2DNode28.r * _FillR ));
			float4 lerpResult79 = lerp( lerpResult27 , ( tex2DNode26 * _ColorG ) , ( tex2DNode28.g * _FillG ));
			float4 lerpResult80 = lerp( lerpResult79 , ( tex2DNode26 * _ColorB ) , ( tex2DNode28.b * _FillB ));
			float4 lerpResult81 = lerp( lerpResult80 , ( tex2DNode26 * _ColorA ) , ( tex2DNode28.a * _FillA ));
			o.Emission = ( tex2D( _MatCap, ( ( appendResult61 * 0.5 ) + 0.5 ).xy ) * unity_ColorSpaceDouble * lerpResult81 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18909
1920;269;1920;1019;2495.534;1677.731;2.045969;True;False
Node;AmplifyShaderEditor.ViewMatrixNode;56;-1317.287,-1787.472;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.WorldNormalVector;57;-1420.401,-1653.669;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-1187.167,-1728.549;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;3;-1397.727,-1109.951;Inherit;False;Property;_Color;_Color;0;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;25;-1485.494,-1339.932;Inherit;True;Property;_MainTex;_MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;28;-1596.408,241.5392;Inherit;True;Property;_Mask;Mask;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;26;-1735.471,-824.9761;Inherit;True;Property;_SecondaryTexture;SecondaryTexture;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;30;-1650.395,-608.6615;Inherit;False;Property;_ColorR;ColorR;5;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;82;-1670.128,549.0729;Inherit;False;Property;_FillR;FillR;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;59;-1039.861,-1684.358;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-1212.866,333.9542;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1140.886,-1141.373;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-1348.957,-698.0441;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;69;-1638.655,-418.3126;Inherit;False;Property;_ColorG;ColorG;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;83;-1630.928,708.7728;Inherit;False;Property;_FillG;FillG;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;70;-1650.84,-195.0317;Inherit;False;Property;_ColorB;ColorB;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-1212.281,472.6724;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-911.9746,-1521.644;Inherit;False;Constant;_Float1;Float 0;2;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;61;-901.1416,-1684.04;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-1316.137,-450.4193;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;27;-922.8415,-589.8184;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-1631.128,833.1729;Inherit;False;Property;_FillB;FillB;10;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;71;-1669.771,-5.015217;Inherit;False;Property;_ColorA;ColorA;11;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;79;-713.3574,-426.5325;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-1343.934,-278.438;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-1689.928,1028.573;Inherit;False;Property;_FillA;FillA;12;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-1210.98,615.6724;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-740.9257,-1640.489;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;80;-531.1342,-281.7015;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-1334.798,-146.5251;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-1212.28,739.1721;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-562.7986,-1540.561;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;81;-316.568,-112.3819;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorSpaceDouble;67;-476.0733,-1243.153;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;64;-323.8268,-1538.225;Inherit;True;Property;_MatCap;MatCap;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;66.00731,-931.0681;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;5;350.5794,-914.5358;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Abi/Unlit 2 Textures Color Normal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;58;0;56;0
WireConnection;58;1;57;0
WireConnection;59;0;58;0
WireConnection;55;0;28;1
WireConnection;55;1;82;0
WireConnection;29;0;25;0
WireConnection;29;1;3;0
WireConnection;2;0;26;0
WireConnection;2;1;30;0
WireConnection;76;0;28;2
WireConnection;76;1;83;0
WireConnection;61;0;59;0
WireConnection;61;1;59;1
WireConnection;68;0;26;0
WireConnection;68;1;69;0
WireConnection;27;0;29;0
WireConnection;27;1;2;0
WireConnection;27;2;55;0
WireConnection;79;0;27;0
WireConnection;79;1;68;0
WireConnection;79;2;76;0
WireConnection;72;0;26;0
WireConnection;72;1;70;0
WireConnection;77;0;28;3
WireConnection;77;1;84;0
WireConnection;62;0;61;0
WireConnection;62;1;60;0
WireConnection;80;0;79;0
WireConnection;80;1;72;0
WireConnection;80;2;77;0
WireConnection;73;0;26;0
WireConnection;73;1;71;0
WireConnection;78;0;28;4
WireConnection;78;1;85;0
WireConnection;63;0;62;0
WireConnection;63;1;60;0
WireConnection;81;0;80;0
WireConnection;81;1;73;0
WireConnection;81;2;78;0
WireConnection;64;1;63;0
WireConnection;66;0;64;0
WireConnection;66;1;67;0
WireConnection;66;2;81;0
WireConnection;5;2;66;0
ASEEND*/
//CHKSM=331729E954D8609062B7C7747FC276D068F3F06F