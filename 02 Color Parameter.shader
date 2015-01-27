// Shader name as shown in Unity.
Shader "Tutorial/Color Parameter"
{
    // Properties exposed to the Unity inspector.
    Properties
    {
        _Color ("Main Color", Color) = (1, 1, 1, 0.5)
    }

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

            v_Output vert(float4 position : POSITION, const uniform float4 _Color)
            {
                v_Output OUT;

                // Transform object coordinates to clip coordinates.
                OUT.position = mul(UNITY_MATRIX_MVP, position);

                // Use passed vertex color.
                OUT.color    = _Color;
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
