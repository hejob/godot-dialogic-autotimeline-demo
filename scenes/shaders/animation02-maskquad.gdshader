// mask.gdshader
shader_type canvas_item;
uniform float softness = 0.1;

void fragment() {
    vec2 uv = UV;
    float alpha = smoothstep(0.0, softness, uv.x) * 
                 smoothstep(0.0, softness, uv.y) * 
                 smoothstep(1.0, 1.0-softness, uv.x) * 
                 smoothstep(1.0, 1.0-softness, uv.y);
    COLOR = vec4(1.0, 1.0, 1.0, alpha);
}