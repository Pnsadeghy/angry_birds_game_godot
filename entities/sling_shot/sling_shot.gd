extends Node2D

signal on_pulling(position: Vector2)
signal on_thrown(velocity: Vector2)

enum SlingShotState {
	Idle,
	Pulling,
	BirdThrown,
	Reset	
}

@export var max_line_distance := 180
@export var velocity_normalize := 20

@onready var left_line = $LeftLine
@onready var right_line = $RightLine
@onready var center_point = $CenterOfSlingShot

var current_state

func _ready():
	current_state = SlingShotState.Idle
	reset_lines()

func _process(delta):
	if !GameManager.on_play_state():
		return
	
	match current_state:
		SlingShotState.Idle:
			pass
		SlingShotState.Pulling:
			pulling_state_update(delta)
			pass
		SlingShotState.BirdThrown:
			pass
		SlingShotState.Reset:
			pass

func pulling_state_update(delta):
	var mouse_position = get_global_mouse_position()
		
	if mouse_position.distance_to(center_point.position) > max_line_distance:
		# (mouse_position - center_point.position) => give direction from center to moust
		# * 100 => give direction with max distance
		# + center => give direction start from center ( set origin - default is 0,0 ) 
		mouse_position = (mouse_position - center_point.position).normalized() * max_line_distance + center_point.position
	
	if Input.is_action_pressed("left_mouse"):
		
		left_line.set_point_position(1, left_line.to_local(mouse_position))
		right_line.set_point_position(1, right_line.to_local(mouse_position))
		
		
		var centerPos = center_point.position
		var velocity = center_point.position - mouse_position
		var distance = mouse_position.distance_to(centerPos)
		var actVelocity = (velocity/velocity_normalize) * distance
		$ShotArc.clear_points()
		for i in 500:
			$ShotArc.add_point(centerPos)
			actVelocity.y += 150 * delta
			centerPos += actVelocity * delta
	
		on_pulling.emit(mouse_position)
	else:
		$ShotArc.clear_points()
		thrown_the_bird(mouse_position)
		
func thrown_the_bird(location):
	var velocity = center_point.position - location
	var distance = location.distance_to(center_point.position)
	on_thrown.emit((velocity/velocity_normalize) * distance * 3)
	
	current_state = SlingShotState.BirdThrown
	reset_lines()
	
func idle_state_enter():
	current_state = SlingShotState.Idle

func _on_touch_area_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("left_mouse") and current_state == SlingShotState.Idle:
		current_state = SlingShotState.Pulling
		
func get_center_point():
	return center_point.global_position
	
func reset_lines():
	left_line.set_point_position(1, left_line.to_local(center_point.position))
	right_line.set_point_position(1, right_line.to_local(center_point.position))
