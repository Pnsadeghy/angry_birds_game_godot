extends RigidBody2D

class_name Bird

var health = 10
var power = 20
var is_timer_started = false
var is_thrown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	freeze = true

func throw_bird(velocity):
	print("thrown")
	freeze = false
	apply_central_impulse(velocity)
	is_thrown = true

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if !is_thrown:
		return
	if !is_timer_started:
		is_timer_started = true
		$Timer.start()
	if is_instance_valid(body) and body is RigidBody2D:
		
		var damage = linear_velocity.length() * 0.01
		health -= damage
		
		if health <= 0:
			queue_free()


func _on_visible_on_screen_enabler_2d_screen_exited():
	if is_thrown:
		queue_free()
