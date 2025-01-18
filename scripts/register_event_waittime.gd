@tool
extends Node

func _ready() -> void:
	pass
	# do not work

	if Engine.is_editor_hint():
		return
		
	# Wait for Dialogic to be ready
	# await get_tree().create_timer(0.1).timeout
	
	# Register our custom event
	# Dialogic.Events.register_event("wait_time", 
		#load("res://scripts/dialogic_event_waittime.gd")
	#)
