// Shader name as shown in Unity.
Shader "Tutorial/Texture Sampling"
{
    // Properties exposed to the Unity inspector.
    Properties
    {
        _Texture ("Texture", 2D) = "white" {} 
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
                float2 texCoord : TEXCOORD0;
            };

            v_Output vert(float4 position : POSITION, float4 color : COLOR, float2 texCoord : TEXCOORD0)
            {
                v_Output OUT;

                // Transform object coordinates to clip coordinates.
                OUT.position = mul(UNITY_MATRIX_MVP, position);

                // Use passed vertex color and texture coordinates.
                OUT.color    = color;
                OUT.texCoord = texCoord;
                return OUT;
            }
            
            // Define fragment shader output format.
            struct f_Output
            {
                float4 color : COLOR;
            };

            f_Output frag(v_Output v, sampler2D _Texture)
            {
                // Texture lookup.
                f_Output OUT;
                OUT.color = tex2D(_Texture, v.texCoord);
                return OUT;
            }
            
            ENDCG
        }
    }
}
