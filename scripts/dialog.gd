extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialog_singal)
	Dialogic.start("timeline")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# signal events
func _on_dialog_singal(argument: Dictionary):
	push_warning("SIGNAL: " + str(argument))
	if "action" in argument and argument["action"] == "animation":
		var anim = argument["name"]
		if anim == "demo01":
			var node = get_node("CanvasLayer/AnimationPlayerRoot")
			node.play("new_animation")
