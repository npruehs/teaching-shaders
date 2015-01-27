// Shader name as shown in Unity.
Shader "Tutorial/Green"
{
    SubShader
    {
        Pass
        {
			// Use Cg shader language.
            CGPROGRAM

			// Define shader entry points.
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

			// Define vertex shader output format.
            struct v_Output
            {
                float4 position : POSITION;
                float4 color    : COLOR;
            };

            v_Output vert(float4 position : POSITION)
            {
                v_Output OUT;

				// Transform object coordinates to clip coordinates.
                OUT.position = mul(UNITY_MATRIX_MVP, position);

				// Set vertex color to RGBA green.
                OUT.color    = float4(0, 1, 0, 1); 

                return OUT;
            }
            
			// Define fragment shader output format.
            struct f_Output
            {
                float4 color : COLOR;
            };

            f_Output frag(v_Output v)
            {
				// Pass-through.
                f_Output OUT;
                OUT.color = v.color;
                return OUT;
            }
            
            ENDCG
        }
    }
}
