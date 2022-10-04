// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Abi/MovingOutMultiplier"
{
	Properties
	{
		_MainTex("_MainTex", 2D) = "white" {}
		_Color("_Color", Color) = (1,1,1,1)
		_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		_FlickerInterval("FlickerInterval", Float) = 5
		[Toggle]_IsFlicker("IsFlicker", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Color;
		uniform float _IsFlicker;
		uniform float4 _EmissionColor;
		uniform float _FlickerInterval;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 MainColor8 = ( tex2D( _MainTex, uv_MainTex ) * _Color );
			o.Albedo = MainColor8.rgb;
			float4 varEColor140 = _EmissionColor;
			float temp_output_161_0 = ( 1.0 - ( 0.1 / _FlickerInterval ) );
			float clampResult156 = clamp( saturate( sin( ( ( _Time.y / _FlickerInterval ) * UNITY_PI ) ) ) , temp_output_161_0 , 1.0 );
			float4 EmissionColor136 = (( _IsFlicker )?( ( varEColor140 * (0.0 + (clampResult156 - temp_output_161_0) * (1.0 - 0.0) / (1.0 - temp_output_161_0)) ) ):( varEColor140 ));
			o.Emission = EmissionColor136.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18903
1920;227;1920;1019;4905.31;740.3951;2.217478;True;False
Node;AmplifyShaderEditor.CommentaryNode;54;-3133.93,-199.0144;Inherit;False;2302.2;848.367;Comment;17;136;141;152;140;157;139;156;161;153;160;147;144;146;158;159;142;162;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;142;-3080.114,219.625;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;159;-3063.164,401.2524;Inherit;False;Property;_FlickerInterval;FlickerInterval;4;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;158;-2887.164,310.2524;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;146;-2950.334,508.7162;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-2714.334,370.7163;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;147;-2587.334,372.7163;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;160;-2612.164,509.2523;Inherit;False;2;0;FLOAT;0.1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;153;-2464.164,372.2525;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;161;-2483.164,511.2523;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;156;-2302.164,360.2525;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.9;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;139;-3110.567,-123.7781;Inherit;False;Property;_EmissionColor;EmissionColor;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;7;-1906.86,-1007.442;Inherit;False;1067.3;516.8;Comment;4;8;4;3;1;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCRemapNode;157;-2062.164,346.2524;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0.9;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;140;-2870.75,-128.7028;Inherit;False;varEColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;-1748.377,229.8242;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;141;-1735.477,-49.90214;Inherit;False;140;varEColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;3;-1797.86,-715.6422;Inherit;False;Property;_Color;_Color;1;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1856.861,-957.4421;Inherit;True;Property;_MainTex;_MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;85cc98396062cc54c95dab18baf23b63;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;162;-1419.914,105.5989;Inherit;False;Property;_IsFlicker;IsFlicker;5;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-1418.861,-866.4421;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-1190.332,-845.5898;Inherit;False;MainColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;-1045.286,80.32422;Inherit;False;EmissionColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;9;-289.9716,-123.8478;Inherit;True;8;MainColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;135;-281.7532,166.4842;Inherit;False;136;EmissionColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;166.3,4.299986;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Abi/MovingOutMultiplier;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;158;0;142;0
WireConnection;158;1;159;0
WireConnection;144;0;158;0
WireConnection;144;1;146;0
WireConnection;147;0;144;0
WireConnection;160;1;159;0
WireConnection;153;0;147;0
WireConnection;161;0;160;0
WireConnection;156;0;153;0
WireConnection;156;1;161;0
WireConnection;157;0;156;0
WireConnection;157;1;161;0
WireConnection;140;0;139;0
WireConnection;152;0;140;0
WireConnection;152;1;157;0
WireConnection;162;0;141;0
WireConnection;162;1;152;0
WireConnection;4;0;1;0
WireConnection;4;1;3;0
WireConnection;8;0;4;0
WireConnection;136;0;162;0
WireConnection;0;0;9;0
WireConnection;0;2;135;0
ASEEND*/
//CHKSM=4E483E2E1021CE4979DB7BC5173C76F79A91C53B