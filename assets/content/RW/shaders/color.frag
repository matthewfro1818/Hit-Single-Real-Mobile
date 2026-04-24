#pragma header;

uniform float saturation;
uniform float hue;
uniform float brightness;
uniform float contrast;

uniform vec3 excludedColor;

vec3 rgb2hsv(vec3 c)
{
vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

float d = q.x - min(q.w, q.y);
float e = 1.0e-10;
return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main()
{
vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

vec4 swagColor = vec4(rgb2hsv(color.rgb), color[3]);

// [0] is the hue???
swagColor[0] = swagColor[0] + hue;
swagColor[1] = swagColor[1] + saturation;
swagColor[2] = swagColor[2] * (1.0 + brightness);

if(swagColor[1] < 0.0)
{
    swagColor[1] = 0.0;
}
else if(swagColor[1] > 1.0)
{
    swagColor[1] = 1.0;
}


vec3 color1 = hsv2rgb(swagColor.xyz);

// //contrast
// color1.rgb = ((color1.rgb - 0.5) * max(contrast, 0.0)) + 0.5;


if (color.rgb == excludedColor) {
    gl_FragColor = color;
}
else {
    color = vec4(color1, swagColor[3]);

    gl_FragColor = color;
}



}