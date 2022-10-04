// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Abi/MovingOutMultiplierAlpha"
{
	Properties
	{
		_MainTex("_MainTex", 2D) = "white" {}
		_Color("_Color", Color) = (1,1,1,1)
		_EmissionColor1("EmissionColor", Color) = (0,0,0,0)
		_FlickerInterval1("FlickerInterval", Float) = 5
		[Toggle]_IsFlicker1("IsFlicker", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Color;
		uniform float _IsFlicker1;
		uniform float4 _EmissionColor1;
		uniform float _FlickerInterval1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			float4 varColor15 = ( tex2DNode1 + _Color );
			o.Albedo = varColor15.rgb;
			float4 varEColor32 = _EmissionColor1;
			float temp_output_29_0 = ( 1.0 - ( 0.1 / _FlickerInterval1 ) );
			float clampResult30 = clamp( saturate( sin( ( ( _Time.y / _FlickerInterval1 ) * UNITY_PI ) ) ) , temp_output_29_0 , 1.0 );
			float4 EmissionColor37 = (( _IsFlicker1 )?( ( varEColor32 * (0.0 + (clampResult30 - temp_output_29_0) * (1.0 - 0.0) / (1.0 - temp_output_29_0)) ) ):( varEColor32 ));
			o.Emission = EmissionColor37.rgb;
			float varOpacity17 = ( ( tex2DNode1.a * 2.0 * _Color.a ) + _Color.a );
			o.Alpha = varOpacity17;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
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
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18903
1920;227;1920;1019;1781.578;445.0739;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;20;-2298.482,-118.0845;Inherit;False;2302.2;848.367;Comment;17;37;35;34;33;32;31;30;29;28;27;26;25;24;23;22;21;39;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2227.716,482.1823;Inherit;False;Property;_FlickerInterval1;FlickerInterval;4;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;21;-2244.666,300.5549;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;24;-2114.886,589.6461;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;23;-2051.716,391.1823;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1878.886,451.6462;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;27;-1776.716,590.1822;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;26;-1751.886,453.6462;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;29;-1647.716,592.1822;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;28;-1628.716,453.1824;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;31;-2275.119,-42.84821;Inherit;False;Property;_EmissionColor1;EmissionColor;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;30;-1466.716,441.1824;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.9;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;19;-1665.52,-992.3802;Inherit;False;950.7635;510;Comment;7;15;13;1;3;10;11;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-2035.302,-47.77292;Inherit;False;varEColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;33;-1226.716,427.1823;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0.9;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1615.52,-942.3802;Inherit;True;Property;_MainTex;_MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-1608.62,-694.3802;Inherit;False;Property;_Color;_Color;1;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;35;-926.0289,41.02774;Inherit;False;32;varEColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1267.62,-731.5803;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-912.9288,310.7541;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-1139.02,-623.6803;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1166.02,-911.0803;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;39;-589.5775,176.9261;Inherit;False;Property;_IsFlicker1;IsFlicker;5;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-939.7621,-920.6345;Inherit;False;varColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-209.8379,161.2541;Inherit;False;EmissionColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-938.7563,-632.3491;Inherit;False;varOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;169.1581,-33.85431;Inherit;False;15;varColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;143.55,70.02673;Inherit;False;37;EmissionColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;180.1638,237.4312;Inherit;False;17;varOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;377,-24;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Abi/MovingOutMultiplierAlpha;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;25;0;23;0
WireConnection;25;1;24;0
WireConnection;27;1;22;0
WireConnection;26;0;25;0
WireConnection;29;0;27;0
WireConnection;28;0;26;0
WireConnection;30;0;28;0
WireConnection;30;1;29;0
WireConnection;32;0;31;0
WireConnection;33;0;30;0
WireConnection;33;1;29;0
WireConnection;10;0;1;4
WireConnection;10;2;3;4
WireConnection;34;0;32;0
WireConnection;34;1;33;0
WireConnection;11;0;10;0
WireConnection;11;1;3;4
WireConnection;13;0;1;0
WireConnection;13;1;3;0
WireConnection;39;0;35;0
WireConnection;39;1;34;0
WireConnection;15;0;13;0
WireConnection;37;0;39;0
WireConnection;17;0;11;0
WireConnection;0;0;16;0
WireConnection;0;2;38;0
WireConnection;0;9;18;0
ASEEND*/
//CHKSM=5208D5C740AAFFFCF88BF6C6175044874E66B5C5