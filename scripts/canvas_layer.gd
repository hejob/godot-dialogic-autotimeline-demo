extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	push_warning("canvas ready")
	#var node = get_node("AnimationPlayerRoot")
	#node.play("new_animation")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_animation_player_root_animation_finished(anim_name: StringName) -> void:
	push_warning(anim_name + " finished")
	if (anim_name == "new_animation"):
		var node = get_node("AnimationPlayerRoot")
		node.stop()


func _on_animation_player_root_animation_started(anim_name: StringName) -> void:
	push_warning(anim_name + " started")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	push_warning(anim_name + " sub finished")


func _on_animation_player_root_animation_changed(old_name: StringName, new_name: StringName) -> void:
	push_warning("animation changed " + old_name + " to " + new_name)


func _on_animation_player_root_current_animation_changed(name: String) -> void:
	push_warning("current anim changed " + name)
