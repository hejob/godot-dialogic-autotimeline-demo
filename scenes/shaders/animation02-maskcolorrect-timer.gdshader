shader_type canvas_item;

uniform float speed = 1.0;
uniform float smoothness = 0.1;

void fragment() {
    vec2 center = UV - 0.5;
    float angle = atan(center.y, center.x) + TIME * speed;
    float radius = length(center);
    
    // Create circular gradient with animation
    float gradient = sin(radius * 10.0 - angle * 2.0) * 0.5 + 0.5;
    COLOR.a = smoothstep(0.5 - smoothness, 0.5 + smoothness, gradient);
}
