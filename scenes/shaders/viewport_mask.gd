# ViewportMask.gd
extends Node2D
# export(Vector2) var mask_size = Vector2(512, 512) setget set_mask_size
var mask_size = Vector2(1280, 768)

var mask_texture: ViewportTexture

func _ready():
	$MaskViewport.size = mask_size
	$MaskViewport/MaskQuad.size = mask_size # .rect_size = mask_size
	_ready2()

func set_mask_size(value):
	mask_size = value
	if is_inside_tree():
		$MaskViewport.size = mask_size
		$MaskViewport/MaskQuad.rect_size = mask_size

func _ready2():
	mask_texture = $MaskViewport.get_texture()
	connect_child_materials()

func connect_child_materials():
	for child in get_children():
		#if child != $MaskViewport && child is CanvasItem:
			#var mat = ShaderMaterial.new()
			#mat.shader = preload("masked_object.gdshader")
			#mat.set_shader_param("mask_texture", mask_texture)
			#child.material = mat
		if child != $MaskViewport && child.material is ShaderMaterial:
			child.material.set_shader_param("mask_texture", mask_texture)

func _process(_delta):
	var mat_params = {
		"mask_position": global_position,
		"mask_scale": mask_size * scale
	}

	for child in get_children():
		if child != $MaskViewport && child.material is ShaderMaterial:
			for param in mat_params:
				child.material.set_shader_param(param, mat_params[param])
