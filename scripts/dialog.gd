extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.Styles.load_style("style01")
	Dialogic.start("timeline")
	if Dialogic.has_subsystem("Waittime"):
		var Waittime = Dialogic.get_subsystem("Waittime")
		#Waittime.init_timeline()
		Waittime.init_timer(get_node("DialogicNode/WaitTimer"))
		# IF NEEDS TO START AT SOME POINT
		# Waittime.skip(60.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _input(event) -> void: # todo: what is its type?
	if not Dialogic.has_subsystem("Waittime"):
		print("No Waittime Subsystem.")
		return
	var Waittime = Dialogic.get_subsystem("Waittime")
	if event is InputEventKey:
		if event.keycode == KEY_SPACE:
			if event.pressed:
				print("SKIP MODE ON")
				Waittime.set_skip_mode(true)
			elif event.is_action_released("ui_accept"):
				print("SKIP MODE OFF")
				Waittime.set_skip_mode(false)
