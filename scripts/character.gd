# scripts/character.gd
extends Sprite2D

@export var expressions : Dictionary
@export var shake_animation_time : float = 1.0
@export var move_in_animation_time : float = 1.0
@export var move_outscreen_x : int = 20

var initial_position : Vector2
var is_moving : bool = false

func _ready():
	initial_position = position

func set_expression(expression_name : String):
	if expressions.has(expression_name):
		texture = expressions[expression_name]
	else:
		push_error("Expression not found: " + expression_name)

func shake_animation():
	if is_moving:
		return
	is_moving = true
	var tween = create_tween()
	var offset = 10
	tween.tween_property(self, "position", position + Vector2(offset, 0), shake_animation_time / 4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", position - Vector2(offset, 0), shake_animation_time / 4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", position + Vector2(offset, 0), shake_animation_time / 4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", initial_position, shake_animation_time / 4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(Callable(self,"_on_shake_animation_finished"))

func _on_shake_animation_finished():
	is_moving = false

func move_in_from_left():
	if is_moving:
		return
	is_moving = true
	var start_position = Vector2(move_outscreen_x, initial_position.y)
	position = start_position
	var tween = create_tween()
	tween.tween_property(self, "position", initial_position, move_in_animation_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(Callable(self,"_on_move_in_animation_finished"))

func move_in_from_right():
	if is_moving:
		return
	is_moving = true
	var start_position = Vector2(get_viewport_rect().size.x + move_outscreen_x, initial_position.y)
	position = start_position
	var tween = create_tween()
	tween.tween_property(self, "position", initial_position, move_in_animation_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(Callable(self,"_on_move_in_animation_finished"))

func _on_move_in_animation_finished():
	is_moving = false
