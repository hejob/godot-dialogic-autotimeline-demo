shader_type canvas_item;

render_mode unshaded;
uniform float alpha = 1.0;
uniform float xx = 0.5;

void fragment() {
    vec2 uv = UV; 

    // Create a simple gradient mask
    float mask_value = smoothstep(0, 1.0 - xx, 1.0 - uv.y);

	COLOR = texture(TEXTURE, UV); // Read from texture
	COLOR.a = mask_value * alpha;
    // COLOR = vec4(mask_value, mask_value, mask_value, mask_value); 
}
