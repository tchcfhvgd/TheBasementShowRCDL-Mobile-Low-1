#pragma header

uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

void mainImage()
{
    vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
    vec2 p = fragCoord.xy/iResolution.xy;
    
	vec4 col = texture(iChannel0, p);

	col.rgb = texture(iChannel0, p).brg;

    fragColor = col;
}

// https://www.shadertoy.com/view/dssXRl