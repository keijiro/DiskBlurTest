Shader "Hidden/DiskBlur"
{
    Properties
    {
        _MainTex("", 2D) = "" {}
    }
    SubShader
    {
        ZTest Always Cull Off ZWrite Off
        Pass
        {
            CGPROGRAM
            #include "Resample.cginc"
            #pragma vertex vert_img
            #pragma fragment frag_downsample
            #pragma target 3.0
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #include "Resample.cginc"
            #pragma vertex vert_img
            #pragma fragment frag_upsample
            #pragma target 3.0
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #define SAMPLE_COUNT_LOW
            #include "DiskBlur.cginc"
            #pragma vertex vert_img
            #pragma fragment frag_blur
            #pragma target 3.0
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #define SAMPLE_COUNT_MEDIUM
            #include "DiskBlur.cginc"
            #pragma vertex vert_img
            #pragma fragment frag_blur
            #pragma target 3.0
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #define SAMPLE_COUNT_HIGH
            #include "DiskBlur.cginc"
            #pragma vertex vert_img
            #pragma fragment frag_blur
            #pragma target 3.0
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #define SAMPLE_COUNT_VERYHIGH
            #include "DiskBlur.cginc"
            #pragma vertex vert_img
            #pragma fragment frag_blur
            #pragma target 3.0
            ENDCG
        }
    }
}
