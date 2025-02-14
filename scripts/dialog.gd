extends Node2D

### for animation controls
var animation_layer
var animation_nodes: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.Styles.load_style("style01")
	Dialogic.signal_event.connect(_on_dialogic_sinal)
	if Dialogic.has_subsystem("Waittime"):
		var Waittime = Dialogic.get_subsystem("Waittime")
		#Waittime.init_timeline()
		Waittime.init_timer(get_node("DialogicNode/WaitTimer"))
		# IF NEEDS TO START AT SOME POINT
		# Waittime.skip(60.0)

	animation_layer = find_animation_layer()

	Dialogic.start("timeline")
	

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

func show_animation_layer(scene_name: String, name: String, animation_node_name: String, animation_name: String) -> void:
	print("show animation layer: " + scene_name + " " + name + " " + animation_node_name + " " + animation_name)
	var node = animation_layer # find_animation_layer()
	if not node:
		return

	#var insert_scene = load('res://scenes/animation01.tscn')
	var insert_scene = load('res://scenes/' + scene_name + '.tscn')
	#var v_con := SubViewportContainer.new()
	#var viewport := SubViewport.new()
	var b_scene = insert_scene.instantiate()
	node.add_child(b_scene)
	#get_node("CanvasLayer").add_child(b_scene)

	#node.add_child(v_con)
	#v_con.hide()
	#v_con.stretch = true
	##v_con.set_size((node as CanvasLayer).size
	#v_con.set_anchors_preset(Control.PRESET_FULL_RECT)
#
	#v_con.add_child(viewport)
	#viewport.transparent_bg = true
	#viewport.disable_3d = true
	#viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	#viewport.canvas_item_default_texture_filter = ProjectSettings.get_setting("rendering/textures/canvas_textures/default_texture_filter")
#
	#viewport.add_child(b_scene)
	#b_scene.viewport = viewport
	#b_scene.viewport_container = v_con

	#node.set_meta('current_viewport', v_con)
	#v_con.set_meta('node', b_scene)
	
	# find animation player node
	#var animation_player = b_scene.find_child("AnimationPlayer")
	var animation_player = b_scene.find_child(animation_node_name)
	if animation_player:
		#animation_player.play("new_animation")
		animation_player.play(animation_name)
	
	animation_nodes[name] = {
		"scene": b_scene,
		"animation": animation_name,
	}
	

func find_animation_layer() -> DialogicLayoutLayer:
	var layout_node = Dialogic.Styles.get_layout_node()
	#var node = layout_node.find_child("AnimationDialogicLayoutLayer")
	for layer in layout_node.get_layers():
		if layer.name == "AnimationLayer":
			return layer
	#print(str(layout_node.get_layer(2)))
	#var node = layout_node.get_child(2).find_child("Canvas")
	#node.find_child("Animation01s").set_visible(false)
	#var node = Dialogic.Styles.get_first_node_in_layout("animation_layer")
	return null

func stop_animation_layer(name: String) -> void:
	print("stop animation layer: " + name)
	var node = animation_layer  #find_animation_layer()
	if not node:
		return
	
	if not name in animation_nodes:
		print("Not found animation layer")
		return

	var info = animation_nodes[name]
	var animation_node = info["scene"]
	var animation_name = info["animation"]
	
	#for item in node.get_children():
		#if item.name == "Animation01":
			#var animation_node = item
			#var animation_player = animation_node.find_child("AnimationPlayer")
			#if animation_player:
				#animation_player.stop()
			#node.remove_child(item)
	var animation_player = animation_node.find_child("AnimationPlayer")
	if animation_player:
		animation_player.stop()
	node.remove_child(animation_node)
	
	animation_nodes.erase(name)
	

### TODO: use signal or custom event to show/stop
### TODO: a scene may have or not an animation, supports both
func _on_dialogic_sinal(arg: Dictionary) -> void:
	var action = arg["action"]
	var name = arg["name"]
	if action == "start":
		var scene_name = arg["scene"]
		var animation_node = null
		var animation_name = null
		if "animation_node" in arg:
			animation_node = arg["animation_node"]
		if "animation" in arg:
			animation_name = arg["animation"]
		show_animation_layer(scene_name, name, animation_node, animation_name)
		#show_animation_layer("animation01", "anim01", "AnimationPlayer", "new_animation")
	elif action == "stop":
		stop_animation_layer(name)
