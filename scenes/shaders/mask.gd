extends Sprite2D

var _last_global_pos: Vector2
var mask_scale = Vector2(1,1)
# export(Vector2) var mask_scale = Vector2(1, 1) setget set_mask_scale

func _ready():
	update_children_uniforms()
	_last_global_pos = global_position

func _process(_delta):
	if global_position != _last_global_pos:
		_last_global_pos = global_position
		update_children_uniforms()

func set_mask_scale(value):
	mask_scale = value
	update_children_uniforms()

func update_children_uniforms():
	var tex = texture
	var mask_pos = global_position
	for child in get_children():
		if child is CanvasItem and child.material is ShaderMaterial:
			child.material.set_shader_parameter("mask_texture", tex)
			child.material.set_shader_parameter("mask_position", mask_pos)
			child.material.set_shader_parameter("mask_scale", mask_scale)
