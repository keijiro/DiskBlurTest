Shader "Hidden/DiskBlur"
{
    Properties
    {
        _MainTex("", 2D) = "" {}
    }
    SubShader
    {
        Pass
        {
            ZTest Always Cull Off ZWrite Off
            CGPROGRAM
            #include "Downsample.cginc"
            #pragma vertex vert_img
            #pragma fragment frag_downsample
            #pragma target 3.0
            ENDCG
        }
        Pass
        {
            ZTest Always Cull Off ZWrite Off
            CGPROGRAM
            #include "DiskBlur.cginc"
            #pragma vertex vert_img
            #pragma fragment frag_blur
            #pragma target 3.0
            ENDCG
        }
    }
}
