// masked_object.gdshader
shader_type canvas_item;
uniform sampler2D mask_texture;
uniform vec2 mask_position;
uniform vec2 mask_scale;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    vec2 mask_uv = (FRAGCOORD.xy - mask_position) / mask_scale;
    float mask_alpha = texture(mask_texture, mask_uv).a;
    
    COLOR = tex;
    COLOR.a *= mask_alpha;
}