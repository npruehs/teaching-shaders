// Shader name as shown in Unity.
Shader "Tutorial/Lighting"
{
    // Properties exposed to the Unity inspector.
    Properties
    {
        _Ke ("Ke", Color) = (1, 1, 1, 1)
        _Ka ("Ka", Color) = (1, 1, 1, 1)
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
            };

            v_Output vert(float4 position : POSITION,
                float3 normal : NORMAL,
                const uniform float4 _Ke,
                const uniform float4 _Ka,
                const uniform float4 _Kd,
                const uniform float4 _Ks,
                const uniform float _Shininess,
                const uniform float4 _LightColor0)
            {
                v_Output OUT;

                // Transform object coordinates to clip coordinates.
                OUT.position = mul(UNITY_MATRIX_MVP, position);

                // Compute the emissive term.
                float4 emissive = _Ke;
                
                // Compute the ambient term.
                float4 ambient = _Ka * UNITY_LIGHTMODEL_AMBIENT;

                // Compute the diffuse term.
                float3 N = normalize(normal);
                float3 L = normalize(_WorldSpaceLightPos0.xyz - position.xyz);
                float3 diffuse = _Kd * _LightColor0 * max(dot(N, L), 0);
  
                // Compute the specular term.
                float facing = dot(N, L) > 0 ? 1 : 0;
                float3 V = normalize(WorldSpaceViewDir(position));
                float3 H = normalize(L + V);
                float3 specular = _Ks * _LightColor0 * facing * pow(max(dot(N, H), 0), _Shininess);

                // Compute final color.
                OUT.color.xyz = emissive + ambient + diffuse + specular;
                OUT.color.w = 1;

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
