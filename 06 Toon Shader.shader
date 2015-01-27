// Shader name as shown in Unity.
Shader "Tutorial/Toon Shader"
{
    // Properties exposed to the Unity inspector.
    Properties
    {
        _Kd ("Kd", Color) = (1, 1, 1, 1)
        _Ks ("Ks", Color) = (1, 1, 1, 1)
        _Shininess ("_Shininess", Float) = 5.0
    }
    
    SubShader
    {
        Pass
        {
            Tags
            {
                "LightMode" = "ForwardBase"
            }

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
                float  diffuse          : TEXCOORD0;
                float  specular         : TEXCOORD1;
                float  edge             : TEXCOORD2;
            };

            v_Output vert(float4 position : POSITION,
                float3 normal : NORMAL,
                const uniform float _Shininess,
                const uniform float4 _LightColor0)
            {
                v_Output OUT;

                // Transform object coordinates to clip coordinates.
                OUT.position = mul(UNITY_MATRIX_MVP, position);

                // Compute the diffuse term.
                float3 N = normalize(normal);
                float3 L = normalize(_WorldSpaceLightPos0.xyz - position.xyz);
                OUT.diffuse = max(dot(N, L), 0);
  
                // Compute the specular term.
                float facing = dot(N, L) > 0 ? 1 : 0;
                float3 V = normalize(WorldSpaceViewDir(position));
                float3 H = normalize(L + V);
                OUT.specular = facing * pow(max(dot(N, H), 0), _Shininess);

                // Perform edge detection
                OUT.edge = max(dot(N, V), 0);

                return OUT;
            }
            
            // Define fragment shader output format.
            struct f_Output
            {
                float4 color : COLOR;
            };

            f_Output frag(v_Output v,
                const uniform float4 _Kd,
                const uniform float4 _Ks)
            {
                f_Output OUT;

                // Apply step functions.
                float diffuse = v.diffuse <= 0.5 ? 0.5 : 0;
                float specular = v.specular <= 0.5 ? 0.5 : 0;
                float edge = v.edge <= 0.5 ? 0.5 : 0;
                
                // Compute the final color
                OUT.color = edge * (_Kd * diffuse + _Ks * specular);

                return OUT;
            }
            
            ENDCG
        }
    }
}
