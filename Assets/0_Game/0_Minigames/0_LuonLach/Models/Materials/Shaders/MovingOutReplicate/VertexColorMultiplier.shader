// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Abi/Unlit Vertex Color"
{
	Properties
	{
		_Color("_Color", Color) = (1,1,1,1)
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_WorldNormalColor("WorldNormalColor", Color) = (0.07,0.07,0.07,1)
		_VertexNormalColor("VertexNormalColor", Color) = (0,0,0,0)
		[Toggle]_DisableCulling("DisableCulling", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float4 vertexColor : COLOR;
			half3 worldNormal;
			float3 worldPos;
		};

		uniform half4 _Color;
		uniform half4 _WorldNormalColor;
		uniform half4 _VertexNormalColor;
		uniform int EnableFade;
		uniform half _DisableCulling;
		uniform half EnemyToCamera;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			half3 ase_worldNormal = i.worldNormal;
			half3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			o.Albedo = ( ( _Color * i.vertexColor ) + ( half4( saturate( ( ( mul( UNITY_MATRIX_V, half4( ase_worldNormal , 0.0 ) ).xyz * 0.5 ) + 0.5 ) ) , 0.0 ) * _WorldNormalColor ) + ( half4( saturate( ase_vertexNormal ) , 0.0 ) * _VertexNormalColor ) ).rgb;
			o.Alpha = 1;
			float3 ase_worldPos = i.worldPos;
			clip( ( (float)EnableFade == 1.0 ? (( _DisableCulling )?( 1.0 ):( step( 0.0 , ( length( ( _WorldSpaceCameraPos - ase_worldPos ) ) - EnemyToCamera ) ) )) : 1.0 ) - _Cutoff );
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
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
				half4 color : COLOR0;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.vertexColor = IN.color;
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
1920;269;1920;1019;898.1605;-449.8181;1;True;False
Node;AmplifyShaderEditor.WorldSpaceCameraPos;42;-1251.439,950.8881;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;41;-1184.439,1172.888;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewMatrixNode;6;-1388.238,-6.279521;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.WorldNormalVector;21;-1443.154,147.2236;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;81;-943.561,1001.558;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1212.794,36.50638;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1223.611,164.8812;Float;False;Constant;_Float0;Float 0;-1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;84;-762.5605,1002.557;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-846.2412,1163.231;Inherit;False;Global;EnemyToCamera;EnemyToCamera;7;0;Create;True;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1045.542,72.95228;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;76;-567.4164,1019.327;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;12;-1111.66,522.7387;Inherit;True;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-877.6324,144.8291;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;14;-787.34,301.2575;Inherit;False;Property;_WorldNormalColor;WorldNormalColor;2;0;Create;True;0;0;0;False;0;False;0.07,0.07,0.07,1;0.1019608,0.1019608,0.1019608,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;24;-800.6481,679.3486;Inherit;False;Property;_VertexNormalColor;VertexNormalColor;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.09411765,0.09411765,0.09411765,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;16;-741.8401,98.45747;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;1;-740.579,-124.2477;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-745.3794,-390.8477;Inherit;False;Property;_Color;_Color;0;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;22;-737.8267,526.2952;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StepOpNode;99;-158.74,912.6229;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-484.585,559.3614;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-479.8539,181.0237;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-488.2795,-201.8477;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;85;88.84308,675.6287;Inherit;False;Global;EnableFade;EnableFade;7;0;Create;True;0;0;0;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;51;68.40179,929.4213;Inherit;False;Property;_DisableCulling;DisableCulling;4;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT;1;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;93;343.8431,772.6287;Inherit;False;0;4;0;INT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-146.8545,364.7622;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;5;596.6014,523.0444;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Abi/Unlit Vertex Color;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;81;0;42;0
WireConnection;81;1;41;0
WireConnection;8;0;6;0
WireConnection;8;1;21;0
WireConnection;84;0;81;0
WireConnection;9;0;8;0
WireConnection;9;1;7;0
WireConnection;76;0;84;0
WireConnection;76;1;94;0
WireConnection;10;0;9;0
WireConnection;10;1;7;0
WireConnection;16;0;10;0
WireConnection;22;0;12;0
WireConnection;99;1;76;0
WireConnection;23;0;22;0
WireConnection;23;1;24;0
WireConnection;19;0;16;0
WireConnection;19;1;14;0
WireConnection;2;0;3;0
WireConnection;2;1;1;0
WireConnection;51;0;99;0
WireConnection;93;0;85;0
WireConnection;93;2;51;0
WireConnection;20;0;2;0
WireConnection;20;1;19;0
WireConnection;20;2;23;0
WireConnection;5;0;20;0
WireConnection;5;10;93;0
ASEEND*/
//CHKSM=8778D4B0721489C02A7645873DFD278549828BEE