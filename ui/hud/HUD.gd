extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.on_change_score.connect(on_change_score)


func on_change_score(score):
	$MarginContainer/ScoreLabel.text = "Score: " + str(score)
