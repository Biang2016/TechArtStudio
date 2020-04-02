// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LotusFlowering"
{
	Properties
	{
		_Frequency("Frequency", Float) = 0
		_Freq("Freq", Float) = 0
		_OffsetTime("Offset Time", Float) = 0
		_TimeOffset("TimeOffset", Float) = 0
		_Amplitude("Amplitude", Float) = 0
		_OffsetAmplitude("OffsetAmplitude", Float) = 0
		_FlapScalarZ("FlapScalarZ", Range( 0 , 10)) = 0
		_FlapScalarX("FlapScalarX", Range( 0 , 10)) = 0
		_FlapTimeOffset("FlapTimeOffset", Range( 0 , 100)) = 0
		_PetalColor("PetalColor", Color) = (0,0,0,0)
		_CoreColor("CoreColor", Color) = (1,1,1,0)
		[Toggle]_VertexColor("Vertex Color", Float) = 0
		[Toggle]_VertexColorR("Vertex Color R", Float) = 0
		[Toggle]_VertexColorG("Vertex Color G", Float) = 0
		[Toggle]_VertexColorB("Vertex Color B", Float) = 0
		[Toggle]_Manually("Manually", Float) = 0
		_Flowering("Flowering", Range( 0 , 1)) = 0
		[Toggle]_Bending("Bending", Float) = 1
		[Toggle]_WidthExpand("WidthExpand", Float) = 1
		_FlowerHeight("FlowerHeight", Range( 0.7 , 0.9)) = 0
		_PetalWidthExpandRatio("PetalWidthExpandRatio", Range( 0 , 0.62)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float4 vertexColor : COLOR;
		};

		uniform float _Frequency;
		uniform float _OffsetTime;
		uniform float _FlapTimeOffset;
		uniform float _Amplitude;
		uniform float _OffsetAmplitude;
		uniform float _FlapScalarX;
		uniform float _FlapScalarZ;
		uniform float _Bending;
		uniform float _Manually;
		uniform float _Freq;
		uniform float _TimeOffset;
		uniform float _Flowering;
		uniform float _FlowerHeight;
		uniform float _WidthExpand;
		uniform float _PetalWidthExpandRatio;
		uniform float _VertexColor;
		uniform float4 _CoreColor;
		uniform float4 _PetalColor;
		uniform float _VertexColorR;
		uniform float _VertexColorG;
		uniform float _VertexColorB;


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_12_0 = ( ( sin( ( ( _Time.y * _Frequency ) + _OffsetTime + ( _FlapTimeOffset * -1 * ase_vertex3Pos.y ) ) ) * _Amplitude ) + _OffsetAmplitude );
			float4 appendResult13 = (float4(( temp_output_12_0 * ase_vertex3Pos.y * _FlapScalarX ) , 0.0 , ( temp_output_12_0 * _FlapScalarZ * ase_vertex3Pos.y ) , 0.0));
			float3 _ObjectUp = float3(0,1,0);
			float3 normalizeResult38 = normalize( cross( ase_vertex3Pos , _ObjectUp ) );
			float dotResult61 = dot( ase_vertex3Pos , _ObjectUp );
			float3 rotatedValue34 = RotateAroundAxis( float3( 0,0,0 ), ase_vertex3Pos, mul( unity_ObjectToWorld, float4( normalizeResult38 , 0.0 ) ).xyz, min( acos( ( ( dotResult61 / length( ase_vertex3Pos ) ) / length( _ObjectUp ) ) ) , (( _Bending )?( ( ( (0.0 + ((( _Manually )?( _Flowering ):( ( ( sin( ( ( _Time.y * _Freq ) + _TimeOffset ) ) * 0.5 ) + 0.5 ) )) - 1.0) * (0.5 - 0.0) / (0.0 - 1.0)) * ( length( ase_vertex3Pos ) * 0.62 ) ) - 0.0 ) ):( 0.0 )) ) );
			float3 break142 = rotatedValue34;
			float4 appendResult139 = (float4(break142.x , ( _FlowerHeight * break142.y ) , break142.z , 0.0));
			float4 appendResult86 = (float4(( ase_vertex3Pos.z * -1.0 ) , 0.0 , ase_vertex3Pos.x , 0.0));
			float4 normalizeResult87 = normalize( appendResult86 );
			float ifLocalVar96 = 0;
			if( v.color.b <= 0.0 )
				ifLocalVar96 = (float)1;
			else
				ifLocalVar96 = (float)-1;
			v.vertex.xyz += ( appendResult13 + ( appendResult139 - float4( ase_vertex3Pos , 0.0 ) ) + (( _WidthExpand )?( ( normalizeResult87 * -1 * ( (0.0 + ((( _Manually )?( _Flowering ):( ( ( sin( ( ( _Time.y * _Freq ) + _TimeOffset ) ) * 0.5 ) + 0.5 ) )) - 1.0) * (_PetalWidthExpandRatio - 0.0) / (0.0 - 1.0)) * v.color.g ) * ifLocalVar96 ) ):( float4( 0,0,0,0 ) )) ).xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 lerpResult158 = lerp( _CoreColor , _PetalColor , (0.0 + (length( ase_vertex3Pos ) - 0.0) * (1.0 - 0.0) / ((1.59 + ((( _Manually )?( _Flowering ):( ( ( sin( ( ( _Time.y * _Freq ) + _TimeOffset ) ) * 0.5 ) + 0.5 ) )) - 1.0) * (2.57 - 1.59) / (0.0 - 1.0)) - 0.0)));
			float4 appendResult144 = (float4((( _VertexColorR )?( i.vertexColor.r ):( 0.0 )) , (( _VertexColorG )?( i.vertexColor.g ):( 0.0 )) , (( _VertexColorB )?( i.vertexColor.b ):( 0.0 )) , 0.0));
			o.Albedo = (( _VertexColor )?( appendResult144 ):( lerpResult158 )).xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
0;22;1440;857;4813.351;-744.887;1.406101;True;False
Node;AmplifyShaderEditor.CommentaryNode;168;-4354.389,1015.513;Inherit;False;990.3323;243.1541;Basic Sin Wave For Auto Flowering;8;181;179;177;176;174;175;170;172;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;172;-4288.842,1147.867;Inherit;False;Property;_Freq;Freq;1;0;Create;True;0;0;False;0;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;170;-4304.388,1065.513;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-4125.004,1173.566;Inherit;False;Property;_TimeOffset;TimeOffset;3;0;Create;True;0;0;False;0;0;0.88;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;-4107.845,1064.867;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;176;-3934.508,1064.867;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;177;-3791.684,1064.37;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;185;-3699.221,1381.307;Inherit;False;350;165;Manually Flowering;1;69;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;167;-2413.892,1199.461;Inherit;False;1192.231;515.6277;Bending;10;110;74;75;112;111;114;73;59;134;103;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-3645.626,1064.37;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;181;-3492.205,1062.925;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-3649.221,1431.307;Inherit;False;Property;_Flowering;Flowering;16;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;110;-2363.892,1515.996;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;76;-2027.991,458.8201;Inherit;False;668.4631;322.3229;Shrinking Minimun;6;66;64;62;65;63;61;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-2251.514,1337.853;Inherit;False;Constant;_BendMin;BendMin;10;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;23;-2356.463,580.3401;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;111;-2151.813,1515.996;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-2252.138,1422.115;Inherit;False;Constant;_BendMax;BendMax;10;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-2165.661,1600.088;Inherit;False;Constant;_BendingRatio;BendingRatio;12;0;Create;True;0;0;False;0;0.62;0.62;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;27;-2341.771,739.2037;Inherit;False;Constant;_ObjectUp;ObjectUp;7;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ToggleSwitchNode;182;-3258.961,1297.51;Inherit;False;Property;_Manually;Manually;15;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;73;-2054.708,1277.101;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;-5;False;4;FLOAT;35;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;63;-1977.991,615.0164;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-1972.997,1512.548;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;61;-1977.184,513.4498;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;18;-1742.788,-376.0654;Inherit;False;1015.68;420.8313;Basic Sin Wave;13;12;11;10;9;4;8;7;6;5;3;21;19;20;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-1795,1276.678;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;65;-1977.724,688.7738;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;77;-2029.25,789.5349;Inherit;False;571.746;235.2539;Rotation Axis;4;56;24;38;55;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;62;-1818.525,511.6242;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;134;-1591.97,1277.227;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;3;-1692.788,-326.0655;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1714.031,-123.6896;Inherit;False;Property;_FlapTimeOffset;FlapTimeOffset;8;0;Create;True;0;0;False;0;0;1;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;149;-2397.113,2044.833;Inherit;False;1461.546;816.29;Petal Width Expand;16;83;85;79;86;131;94;87;82;88;104;97;98;99;96;148;152;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;64;-1681.207,510.5921;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1677.242,-243.7121;Inherit;False;Property;_Frequency;Frequency;0;0;Create;True;0;0;False;0;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CrossProductOpNode;24;-1979.25,919.9983;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;14;-1691.741,89.91483;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;21;-1628.291,-43.4024;Inherit;False;Constant;_Int0;Int 0;7;0;Create;True;0;0;False;0;-1;0;0;1;INT;0
Node;AmplifyShaderEditor.ACosOpNode;66;-1509.528,509.5529;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1437.312,-117.1698;Inherit;False;3;3;0;FLOAT;0;False;1;INT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;38;-1805.184,920.2954;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1513.402,-218.0128;Inherit;False;Property;_OffsetTime;Offset Time;2;0;Create;True;0;0;False;0;0;0.88;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;103;-1445.662,1249.461;Inherit;False;Property;_Bending;Bending;17;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldMatrixNode;55;-1844.238,839.5349;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.PosVertexDataNode;83;-2239.534,2126.239;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1496.242,-326.7121;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;152;-2375.055,2463.366;Inherit;False;Property;_PetalWidthExpandRatio;PetalWidthExpandRatio;20;0;Create;True;0;0;False;0;0;0.62;0;0.62;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;79;-1869.477,2432.915;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;33;-1090.805,1009.411;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMinOpNode;68;-1134.214,671.2797;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;184;-2915.087,2255.719;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-1619.504,861.5627;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-1300.902,-326.7121;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-2056.327,2094.833;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;4;-1158.078,-327.2093;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1180.417,-245.7708;Inherit;False;Property;_Amplitude;Amplitude;4;0;Create;True;0;0;False;0;0;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;98;-1672.409,2655.643;Inherit;False;Constant;_Positive;Positive;9;0;Create;True;0;0;False;0;1;0;0;1;INT;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;34;-881.5571,861.0975;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;99;-1675.829,2730.622;Inherit;False;Constant;_Negative;Negative;9;0;Create;True;0;0;False;0;-1;0;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-1673.751,2583.384;Inherit;False;Constant;_Zero;Zero;9;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;131;-2079.938,2376.273;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0.55;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;166;-961.2657,-1464.169;Inherit;False;1099.365;658.9854;Lotus Color Tint;7;154;160;155;156;153;1;158;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;86;-1927.582,2132.814;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;148;-1567.578,2553.499;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1012.02,-327.2093;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-643.9089,706.8275;Inherit;False;Property;_FlowerHeight;FlowerHeight;19;0;Create;True;0;0;False;0;0;0.9;0.7;0.9;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;183;-2717.373,-609.4744;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-1655.296,2373.655;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;154;-721.2766,-1116.391;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-1066.137,-165.9109;Inherit;False;Property;_OffsetAmplitude;OffsetAmplitude;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;142;-582.9522,861.9808;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ConditionalIfNode;96;-1484.854,2598.804;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;INT;0;False;3;INT;0;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;94;-1768.521,2219.582;Inherit;False;Constant;_Int1;Int 1;9;0;Create;True;0;0;False;0;-1;0;0;1;INT;0
Node;AmplifyShaderEditor.NormalizeNode;87;-1770.655,2133.163;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;147;-543.2002,-722.2037;Inherit;False;903.636;505.751;Vertex Color Show;6;107;144;143;145;146;106;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCRemapNode;160;-911.2657,-1007.183;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;1.59;False;4;FLOAT;2.57;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;106;-495.6978,-552.9915;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-856.5996,-328.6539;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;163;-1486.221,102.5942;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-335.0276,712.2978;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-991.4622,129.2814;Inherit;False;Property;_FlapScalarX;FlapScalarX;7;0;Create;True;0;0;False;0;0;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;151;-992.7019,212.2572;Inherit;False;Property;_FlapScalarZ;FlapScalarZ;6;0;Create;True;0;0;False;0;0;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;165;-1488.705,222.4283;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-1315.723,2137.123;Inherit;False;4;4;0;FLOAT4;0,0,0,0;False;1;INT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LengthOpNode;155;-533.9771,-1116.321;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;104;-1137.646,2110.261;Inherit;False;Property;_WidthExpand;WidthExpand;18;0;Create;True;0;0;False;0;1;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-682.9381,39.9159;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;139;-190.9333,861.6214;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TFHCRemapNode;156;-340.5459,-1050.821;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;5;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-375.5659,-1245.843;Inherit;False;Property;_PetalColor;PetalColor;9;0;Create;True;0;0;False;0;0,0,0,0;1,0.5990566,0.7430573,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;145;-229.4028,-436.9698;Inherit;False;Property;_VertexColorG;Vertex Color G;13;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;143;-229.4028,-533.9698;Inherit;False;Property;_VertexColorR;Vertex Color R;12;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;-681.9539,202.5022;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;153;-373.7465,-1414.169;Inherit;False;Property;_CoreColor;CoreColor;10;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;162;-126.1815,1026.319;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ToggleSwitchNode;146;-227.4029,-336.9698;Inherit;False;Property;_VertexColorB;Vertex Color B;14;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;43;-40.32071,896.7637;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;122;-41.00253,1731.597;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;144;-24.40282,-528.9698;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;158;-43.90025,-983.3903;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-519.553,98.79629;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;175.0623,132.9564;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ToggleSwitchNode;107;143.9284,-668.6123;Inherit;False;Property;_VertexColor;Vertex Color;11;0;Create;True;0;0;False;0;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;490.8364,-141.27;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;LotusFlowering;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;174;0;170;0
WireConnection;174;1;172;0
WireConnection;176;0;174;0
WireConnection;176;1;175;0
WireConnection;177;0;176;0
WireConnection;179;0;177;0
WireConnection;181;0;179;0
WireConnection;111;0;110;0
WireConnection;182;0;181;0
WireConnection;182;1;69;0
WireConnection;73;0;182;0
WireConnection;73;3;74;0
WireConnection;73;4;75;0
WireConnection;63;0;23;0
WireConnection;114;0;111;0
WireConnection;114;1;112;0
WireConnection;61;0;23;0
WireConnection;61;1;27;0
WireConnection;59;0;73;0
WireConnection;59;1;114;0
WireConnection;65;0;27;0
WireConnection;62;0;61;0
WireConnection;62;1;63;0
WireConnection;134;0;59;0
WireConnection;64;0;62;0
WireConnection;64;1;65;0
WireConnection;24;0;23;0
WireConnection;24;1;27;0
WireConnection;66;0;64;0
WireConnection;19;0;20;0
WireConnection;19;1;21;0
WireConnection;19;2;14;2
WireConnection;38;0;24;0
WireConnection;103;1;134;0
WireConnection;6;0;3;0
WireConnection;6;1;5;0
WireConnection;68;0;66;0
WireConnection;68;1;103;0
WireConnection;184;0;182;0
WireConnection;56;0;55;0
WireConnection;56;1;38;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;8;2;19;0
WireConnection;85;0;83;3
WireConnection;4;0;8;0
WireConnection;34;0;56;0
WireConnection;34;1;68;0
WireConnection;34;3;33;0
WireConnection;131;0;184;0
WireConnection;131;4;152;0
WireConnection;86;0;85;0
WireConnection;86;2;83;1
WireConnection;148;0;79;3
WireConnection;10;0;4;0
WireConnection;10;1;9;0
WireConnection;183;0;182;0
WireConnection;82;0;131;0
WireConnection;82;1;79;2
WireConnection;142;0;34;0
WireConnection;96;0;148;0
WireConnection;96;1;97;0
WireConnection;96;2;99;0
WireConnection;96;3;98;0
WireConnection;96;4;98;0
WireConnection;87;0;86;0
WireConnection;160;0;183;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;163;0;14;2
WireConnection;138;0;137;0
WireConnection;138;1;142;1
WireConnection;165;0;14;2
WireConnection;88;0;87;0
WireConnection;88;1;94;0
WireConnection;88;2;82;0
WireConnection;88;3;96;0
WireConnection;155;0;154;0
WireConnection;104;1;88;0
WireConnection;15;0;12;0
WireConnection;15;1;163;0
WireConnection;15;2;17;0
WireConnection;139;0;142;0
WireConnection;139;1;138;0
WireConnection;139;2;142;2
WireConnection;156;0;155;0
WireConnection;156;2;160;0
WireConnection;145;1;106;2
WireConnection;143;1;106;1
WireConnection;150;0;12;0
WireConnection;150;1;151;0
WireConnection;150;2;165;0
WireConnection;162;0;33;0
WireConnection;146;1;106;3
WireConnection;43;0;139;0
WireConnection;43;1;162;0
WireConnection;122;0;104;0
WireConnection;144;0;143;0
WireConnection;144;1;145;0
WireConnection;144;2;146;0
WireConnection;158;0;153;0
WireConnection;158;1;1;0
WireConnection;158;2;156;0
WireConnection;13;0;15;0
WireConnection;13;2;150;0
WireConnection;44;0;13;0
WireConnection;44;1;43;0
WireConnection;44;2;122;0
WireConnection;107;0;158;0
WireConnection;107;1;144;0
WireConnection;0;0;107;0
WireConnection;0;11;44;0
ASEEND*/
//CHKSM=47365D186C2EF14473C9F83EABAFD9BEC5F65A03