shader_type canvas_item;

uniform sampler2D mask_texture;
uniform vec2 mask_position;
uniform vec2 mask_scale;

void vertex() {
	// Called for every vertex the material is visible on.
}


void fragment() {
    vec2 frag_coord = FRAGCOORD.xy;
    vec2 uv = (frag_coord - mask_position) / mask_scale;
    vec4 mask = texture(mask_texture, uv);
    COLOR = texture(TEXTURE, UV);
    COLOR.a *= mask.a;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
