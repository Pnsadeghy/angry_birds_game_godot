extends Node2D

var current_bird
var center_position := Vector2.ZERO

@onready var slingShot = $SlingShot
@onready var birdSpawner = $Birds
@onready var camera = $Camera2D

var has_birds = true
var pigs_count := 0

func _ready():
	center_position = slingShot.get_center_point()
	birdSpawner.spawn_bird()
	camera.follower = slingShot.center_point
	
	var pig_list = get_tree().get_nodes_in_group("pigs")
	for pig in pig_list:
		pig.tree_exited.connect(_on_pig_die)
		pigs_count += 1

func _on_sling_shot_on_pulling(position):
	current_bird.position = position

func _on_sling_shot_on_thrown(velocity):
	current_bird.throw_bird(velocity)
	camera.follower = current_bird

func _on_birds_on_spawn_bird(bird, remains):
	current_bird = bird
	current_bird.tree_exited.connect(_on_bird_die)
	has_birds = remains > 0
	
	var tween = get_tree().create_tween()
	tween.tween_property(current_bird, "global_position", center_position, 0.2)
	slingShot.idle_state_enter()

func _on_bird_die():
	camera.reset_position()

	if !has_birds:
		$BirdCheck.start()
		return
	
	birdSpawner.spawn_bird()
	
func _on_pig_die():
	pigs_count -= 1
	if pigs_count == 0:
		GameManager.enter_win()

func _on_bird_check_timeout():
	if GameManager.check_lose():
			pass
