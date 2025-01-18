# scripts/scene_controller.gd
extends Node

@export var scenes : Array[PackedScene]
@export var scene_duration : Array[float]

var current_scene_index = 0
var current_scene_instance
var timer

func _ready():
	if scenes.size() == 0:
		push_error("No scenes added to scene controller")
		return
	if scene_duration.size() != scenes.size():
		push_error("Scene duration array size not match with scenes array size")
		return
	load_scene()
	#load_dialog_timeline()

func load_dialog_timeline():
	var dialog_timeline = load("res://assets/characters/timeline.dtl")
	var dialog_timeline_instance = dialog_timeline.instantiate()
	add_child(dialog_timeline_instance)

func load_scene():
	if current_scene_instance:
		current_scene_instance.queue_free()
	
	current_scene_instance = scenes[current_scene_index].instantiate()
	add_child(current_scene_instance)
	
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = scene_duration[current_scene_index]
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	current_scene_index += 1
	if current_scene_index >= scenes.size():
		print("All scenes finished")
		return
	load_scene()
