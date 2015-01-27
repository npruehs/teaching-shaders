// Shader name as shown in Unity.
Shader "Tutorial/Double Vision"
{
    // Properties exposed to the Unity inspector.
    Properties
    {
        _Texture ("Texture", 2D) = "white" {} 
        _LeftSeparation ("Left Separation", Vector) = (-0.1, 0, 0, 0) 
        _RightSeparation ("Right Separation", Vector) = (0.1, 0, 0, 0) 
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
                float4 position         : POSITION;
                float4 color            : COLOR;
                float2 leftTexCoord     : TEXCOORD0;
                float2 rightTexCoord    : TEXCOORD1;
            };

            v_Output vert(float4 position : POSITION, float4 color : COLOR, float2 texCoord : TEXCOORD0, uniform float2 _LeftSeparation, uniform float2 _RightSeparation)
            {
                v_Output OUT;

                // Transform object coordinates to clip coordinates.
                OUT.position = mul(UNITY_MATRIX_MVP, position);

                // Use passed vertex color.
                OUT.color    = color;

                // Modify texture coordinates.
                OUT.leftTexCoord = texCoord + _LeftSeparation;
                OUT.rightTexCoord = texCoord + _RightSeparation;
                return OUT;
            }
            
            // Define fragment shader output format.
            struct f_Output
            {
                float4 color : COLOR;
            };

            f_Output frag(v_Output v, sampler2D _Texture)
            {
                f_Output OUT;

                // Texture lookup.
                float4 leftColor  = tex2D(_Texture, v.leftTexCoord);
                float4 rightColor = tex2D(_Texture, v.rightTexCoord);

                // Linearly interpolate texture values.
                OUT.color = lerp(leftColor, rightColor, 0.5);

                return OUT;
            }
            
            ENDCG
        }
    }
}
