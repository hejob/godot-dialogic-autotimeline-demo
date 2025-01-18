# scripts/dialog_box.gd
extends Control

@export var dialog_frame : TextureRect
@export var message_label : Label
@export var text_speed : float = 0.05
@export var message_wait_time : float = 1.0

var current_message : String
var current_char_index : int = 0
var is_typing : bool = false
var timer : Timer

func show_message(message : String):
	if is_typing:
		return
	is_typing = true
	current_message = message
	current_char_index = 0
	message_label.text = ""
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = text_speed
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	if current_char_index < current_message.length():
		message_label.text += current_message[current_char_index]
		current_char_index += 1
		timer.start()
	else:
		timer.queue_free()
		await get_tree().create_timer(message_wait_time).timeout
		is_typing = false
