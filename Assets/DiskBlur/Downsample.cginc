#include "UnityCG.cginc"

sampler2D _MainTex;
float4 _MainTex_TexelSize;

// Downsampler with a simple tent filter
half4 frag_downsample(v2f_img i) : SV_Target
{
#if 0

    float4 duv = _MainTex_TexelSize.xyxy * float4(1, 1, -1, 0);

    half3 acc;

    acc  = tex2D(_MainTex, i.uv - duv.xy).rgb;
    acc += tex2D(_MainTex, i.uv - duv.zy).rgb;
    acc += tex2D(_MainTex, i.uv + duv.zy).rgb;
    acc += tex2D(_MainTex, i.uv + duv.xy).rgb;

    return half4(acc / 4, 0);

#else

    float4 duv = _MainTex_TexelSize.xyxy * float4(1, 1, -1, 0) * 2;

    half3 acc;

    acc  = tex2D(_MainTex, i.uv - duv.xy).rgb;
    acc += tex2D(_MainTex, i.uv - duv.wy).rgb * 2;
    acc += tex2D(_MainTex, i.uv - duv.zy).rgb;

    acc += tex2D(_MainTex, i.uv - duv.xw).rgb * 2;
    acc += tex2D(_MainTex, i.uv         ).rgb * 4;
    acc += tex2D(_MainTex, i.uv + duv.xw).rgb * 2;

    acc += tex2D(_MainTex, i.uv + duv.zy).rgb;
    acc += tex2D(_MainTex, i.uv + duv.wy).rgb * 2;
    acc += tex2D(_MainTex, i.uv + duv.xy).rgb;

    return half4(acc / 16, 0);

#endif
}
