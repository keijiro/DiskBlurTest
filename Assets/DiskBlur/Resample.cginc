#include "UnityCG.cginc"

sampler2D _MainTex;
float4 _MainTex_TexelSize;

// Max between three components
half max3(half3 xyz) { return max(xyz.x, max(xyz.y, xyz.z)); }

// 4:1 downsampler
half4 frag_downsample(v2f_img i) : SV_Target
{
    float3 duv = _MainTex_TexelSize.xyx * float3(0.5, 0.5, -0.5);

    half3 c0 = tex2D(_MainTex, i.uv - duv.xy).rgb;
    half3 c1 = tex2D(_MainTex, i.uv - duv.zy).rgb;
    half3 c2 = tex2D(_MainTex, i.uv + duv.zy).rgb;
    half3 c3 = tex2D(_MainTex, i.uv + duv.xy).rgb;

    // Use the center sample for alpha.
    half alpha = tex2D(_MainTex, i.uv).a;

    // Apply luma weights to reduce flickering.
    // Inspired by goo.gl/j1fhLe goo.gl/mfuZ4h
    half w0 = 1 / (max3(c0) + 1);
    half w1 = 1 / (max3(c1) + 1);
    half w2 = 1 / (max3(c2) + 1);
    half w3 = 1 / (max3(c3) + 1);

    // Get the weighted average.
    half3 avg = c0 * w0 + c1 * w1 + c2 * w2 + c3 * w3;
    avg /= w0 + w1 + w2 + w3;

    return half4(avg, alpha);
}

// 1:4 upsampler
half4 frag_upsample(v2f_img i) : SV_Target
{
    float4 duv = _MainTex_TexelSize.xyxy * float4(1, 1, -1, 0);

    half3 acc;

    // 3x3 tent filter
    acc  = tex2D(_MainTex, i.uv - duv.xy).rgb;
    acc += tex2D(_MainTex, i.uv - duv.wy).rgb * 2;
    acc += tex2D(_MainTex, i.uv - duv.zy).rgb;

    acc += tex2D(_MainTex, i.uv - duv.xw).rgb * 2;
    acc += tex2D(_MainTex, i.uv         ).rgb * 4;
    acc += tex2D(_MainTex, i.uv + duv.xw).rgb * 2;

    acc += tex2D(_MainTex, i.uv + duv.zy).rgb;
    acc += tex2D(_MainTex, i.uv + duv.wy).rgb * 2;
    acc += tex2D(_MainTex, i.uv + duv.xy).rgb;

    // Use the center sample for alpha.
    half alpha = tex2D(_MainTex, i.uv).a;

    return half4(acc / 16, alpha);
}
