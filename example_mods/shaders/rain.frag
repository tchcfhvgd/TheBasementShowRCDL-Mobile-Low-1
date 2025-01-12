// The FNF Weekend 1 Rain shader! Ported by Orsonster most of it was unchanged from source, just adjusted to work with Psych engine!

#pragma header
uniform float iTime;
uniform float iIntensity;
uniform float iTimescale;

#define iChannel0 bitmap 
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

float rand(vec2 a) {
    return fract(sin(dot(mod(a, vec2(1000.0)).xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float ease(float t) {
    return t * t * (3.0 - 2.0 * t);
}

float rainDist(vec2 p, float scale, float intensity, float uTime) {
    p *= 0.1;
    p.x += p.y * 0.1;
    p.y -= uTime * 200.0 / scale;
    p.y *= 0.08;
    float ix = floor(p.x);
    p.y += mod(ix, 2.0) * 0.5 + (rand(vec2(ix)) - 0.5) * 0.3;
    float iy = floor(p.y);
    vec2 index = vec2(ix, iy);
    p -= index;
    p.x += (rand(index.yx) * 2.0 - 1.0) * 0.35;
    vec2 a = abs(p - 0.5);
    float res = max(a.x * 0.8, a.y * 0.5) - 0.1;
    bool empty = rand(index) < mix(1.0, 0.1, intensity);
    return empty ? 1.0 : res;
}

void main() {
vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
    vec2 uv = fragCoord / iResolution.xy;
    vec2 wpos = uv * iResolution.xy;
    float intensity = iIntensity;
    float uTime = iTime * iTimescale;

    vec3 add = vec3(0);
    float rainSum = 0.0;

    const int numLayers = 4;
    float scales[4];
    scales[0] = 1.0;
    scales[1] = 1.8;
    scales[2] = 2.6;
    scales[3] = 4.8;

    vec2 warpOffset = vec2(0.0);
    vec2 screenCenter = iResolution.xy * 0.5;
    float distanceFromCenter = length(fragCoord - screenCenter) / length(screenCenter);

    for (int i = 0; i < numLayers; i++) {
        float scale = scales[i] / 4.0;
        float r = rainDist(wpos * scale + 500.0 * float(i), scale, intensity, uTime);
        if (r < 0.0) {
            float v = (1.0 - exp(r * 5.0)) / scale * 2.0;
            wpos.x += v * 5.0;
            wpos.y -= v * 1.0;
            add += vec3(0.1, 0.15, 0.2) * v;
            rainSum += (1.0 - rainSum) * 0.75;
            warpOffset.x += v * 0.2 * (fragCoord.x - screenCenter.x) / screenCenter.x;
            
            warpOffset.y += v * 0.2 * (fragCoord.y) / screenCenter.y;  // Accumulate the warp offset in the Y direction
        }
    }

    vec3 rainColor = vec3(0.4, 0.5, 0.8);
    uv.x -= warpOffset.x * 0.05; // Apply the horizontal warp effect
    uv.y -= warpOffset.y * 0.05; // Apply the vertical warp effect

    vec4 color = texture(iChannel0, uv);
    color.rgb += (add * 3.0);
    color.rgb = mix(color.rgb, rainColor, 0.2 * rainSum);

    fragColor = color;
}