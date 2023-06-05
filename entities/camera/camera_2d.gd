extends Camera2D

var follower
var default_x
var max_x

@export var max_pos_x := 670

func _ready():
	default_x = position.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(follower) and position.x < follower.position.x and position.x < max_pos_x:
		position.x = follower.position.x
		
func reset_position():
	position.x = default_x
