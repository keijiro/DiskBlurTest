#include "UnityCG.cginc"
#include "DiskKernel.cginc"

sampler2D _MainTex;
float4 _MainTex_TexelSize;

float2 _SampleInterval;

half4 frag_blur(v2f_img i) : SV_Target
{
    half3 acc = 0;

    for (int s = 0; s < kSampleCount; s++)
    {
        float2 duv = kDiskKernel[s] * _SampleInterval;
        acc += tex2D(_MainTex, i.uv + duv).rgb;
    }

    return half4(acc / kSampleCount, 0);
}
