// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Phungla/Lava"
{
	Properties
	{
		_Texture0("Texture 0", 2D) = "white" {}
		_ColorStart("ColorStart", Color) = (0.1529412,0.4352942,1,1)
		_ColorEnd("ColorEnd", Color) = (1,0,0.7529413,1)
		_FlowStrength("FlowStrength", Float) = 0.3
		_TimeScale("TimeScale", Float) = 0.3
		_SpeedTex2("SpeedTex2", Vector) = (0,0.4,0,0)
		_Mask("Mask", 2D) = "white" {}
		_lava_tx("lava_tx", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
			#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
			#else//ASE Sampling Macros
			#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
			#endif//ASE Sampling Macros
			


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			UNITY_DECLARE_TEX2D_NOSAMPLER(_lava_tx);
			uniform float4 _lava_tx_ST;
			SamplerState sampler_lava_tx;
			uniform float4 _ColorStart;
			uniform float4 _ColorEnd;
			UNITY_DECLARE_TEX2D_NOSAMPLER(_Texture0);
			uniform float _TimeScale;
			uniform float2 _SpeedTex2;
			SamplerState sampler_Texture0;
			uniform float _FlowStrength;
			UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask);
			uniform float4 _Mask_ST;
			SamplerState sampler_Mask;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv_lava_tx = i.ase_texcoord1.xy * _lava_tx_ST.xy + _lava_tx_ST.zw;
				float2 texCoord2 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 uv26 = texCoord2;
				float4 lerpResult34 = lerp( _ColorStart , _ColorEnd , float4( ( uv26 * float2( 1,0 ) ), 0.0 , 0.0 ));
				float mulTime3 = _Time.y * _TimeScale;
				float Time4 = mulTime3;
				float2 panner7 = ( Time4 * _SpeedTex2 + uv26);
				float2 panner17 = ( Time4 * float2( 0,-0.5 ) + ( uv26 + ( ( ( (SAMPLE_TEXTURE2D( _Texture0, sampler_Texture0, panner7 )).rg + -0.5 ) * 2.0 ) * _FlowStrength ) ));
				float2 uv_Mask = i.ase_texcoord1.xy * _Mask_ST.xy + _Mask_ST.zw;
				float4 lerpResult41 = lerp( SAMPLE_TEXTURE2D( _lava_tx, sampler_lava_tx, uv_lava_tx ) , ( ( lerpResult34 * i.ase_color * 3.0 ) * SAMPLE_TEXTURE2D( _Texture0, sampler_Texture0, panner17 ) ) , SAMPLE_TEXTURE2D( _Mask, sampler_Mask, uv_Mask ));
				
				
				finalColor = lerpResult41;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18400
1920;0;1920;1018;4070.549;1171.984;2.680175;True;False
Node;AmplifyShaderEditor.RangedFloatNode;1;-3254.559,278.9065;Float;False;Property;_TimeScale;TimeScale;4;0;Create;True;0;0;False;0;False;0.3;0.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-3150.811,55.4781;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;3;-3060.09,281.1977;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-2863.106,52.4538;Float;False;uv;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;4;-2858.535,276.9579;Float;False;Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;6;-2829.296,130.1567;Inherit;False;Property;_SpeedTex2;SpeedTex2;5;0;Create;True;0;0;False;0;False;0,0.4;0.3,-0.11;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;24;-2502.383,-214.1496;Inherit;True;Property;_Texture0;Texture 0;0;0;Create;True;0;0;False;0;False;beea0694d337e23449c7d21e4dfef1cb;beea0694d337e23449c7d21e4dfef1cb;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PannerNode;7;-2500.375,50.57339;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.4;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;28;-1487.453,-795.664;Inherit;False;1163.639;587.7999;Color;8;36;34;33;32;31;30;37;35;;0,0.396721,0.4811321,1;0;0
Node;AmplifyShaderEditor.SamplerNode;8;-2228.033,23.41309;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;False;-1;None;beea0694d337e23449c7d21e4dfef1cb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;30;-1439.453,-347.664;Inherit;False;26;uv;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;9;-1874.33,28.06529;Inherit;True;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;31;-1203.662,-559.8725;Float;False;Property;_ColorEnd;ColorEnd;2;0;Create;True;0;0;False;0;False;1,0,0.7529413,1;1,0.3358602,0.1367925,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;33;-1215.453,-747.664;Float;False;Property;_ColorStart;ColorStart;1;0;Create;True;0;0;False;0;False;0.1529412,0.4352942,1,1;1,0.445347,0.1529412,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1175.036,-360.2893;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;10;-1562.953,29.53747;Inherit;True;ConstantBiasScale;-1;;2;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT2;0,0;False;1;FLOAT;-0.5;False;2;FLOAT;2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1505.664,287.0563;Float;True;Property;_FlowStrength;FlowStrength;3;0;Create;True;0;0;False;0;False;0.3;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;34;-869.6333,-709.4436;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-1241.698,149.6244;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-1165.564,39.74768;Inherit;False;26;uv;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-780.6867,-297.1626;Float;False;Constant;_Emission;Emission;1;0;Create;True;0;0;False;0;False;3;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;37;-812.7751,-474.2304;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-959.6979,120.6244;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;15;-1021.698,338.6244;Inherit;False;4;Time;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-559.4531,-523.664;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;43;-168.0973,-406.5521;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;17;-739.0233,143.3606;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;19;-403.0876,15.11681;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;44;-140.9849,-148.2699;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;40;35.84396,-322.2197;Inherit;True;Property;_lava_tx;lava_tx;7;0;Create;True;0;0;False;0;False;-1;792d9ca0c9ae1654d9c7a0c41e042f02;792d9ca0c9ae1654d9c7a0c41e042f02;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;108.8606,-37.88416;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;39;26.52222,258.0411;Inherit;True;Property;_Mask;Mask;6;0;Create;True;0;0;False;0;False;-1;None;9e69cc0355e849c4fbe5243fc89df0cc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;41;450.4688,-55.06243;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;42;829.7585,-52.76669;Float;False;True;-1;2;ASEMaterialInspector;100;1;Phungla/Lava;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;True;0
WireConnection;3;0;1;0
WireConnection;26;0;2;0
WireConnection;4;0;3;0
WireConnection;7;0;26;0
WireConnection;7;2;6;0
WireConnection;7;1;4;0
WireConnection;8;0;24;0
WireConnection;8;1;7;0
WireConnection;9;0;8;0
WireConnection;32;0;30;0
WireConnection;10;3;9;0
WireConnection;34;0;33;0
WireConnection;34;1;31;0
WireConnection;34;2;32;0
WireConnection;13;0;10;0
WireConnection;13;1;11;0
WireConnection;16;0;27;0
WireConnection;16;1;13;0
WireConnection;36;0;34;0
WireConnection;36;1;37;0
WireConnection;36;2;35;0
WireConnection;43;0;36;0
WireConnection;17;0;16;0
WireConnection;17;1;15;0
WireConnection;19;0;24;0
WireConnection;19;1;17;0
WireConnection;44;0;43;0
WireConnection;29;0;44;0
WireConnection;29;1;19;0
WireConnection;41;0;40;0
WireConnection;41;1;29;0
WireConnection;41;2;39;0
WireConnection;42;0;41;0
ASEEND*/
//CHKSM=8C83F8815D9DF367CCDBB46040B0F932FE3013DA