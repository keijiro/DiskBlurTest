#include "UnityCG.cginc"

sampler2D _MainTex;
float4 _MainTex_TexelSize;

float _DownsampleRatio;

// Downsampler with a simple tent filter
half4 frag_downsample(v2f_img i) : SV_Target
{
    float4 duv = _MainTex_TexelSize.xyxy * float4(1, 1, -1, 0);
    duv *= _DownsampleRatio;

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
}
