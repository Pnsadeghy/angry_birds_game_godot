extends Node2D

signal on_change_score(score: int)

enum GameState {
	Start,
	Play,
	Win,
	Lose
}

var currentGameState = GameState.Play
var score := 0

func _process(delta):
	match currentGameState:
		GameState.Start:
			pass
		GameState.Play:
			pass
		GameState.Win:
			pass
		GameState.Lose:
			pass

func on_play_state():
	return currentGameState == GameState.Play

func play_enter():
	currentGameState = GameState.Play
	
func enter_win():
	GameManager.currentGameState = GameState.Win
	print("win")

func check_lose():
	if currentGameState == GameState.Play:
		GameManager.currentGameState = GameState.Lose
		print("lose")
		return true
	else:
		return false
		
func add_score(point):
	score += point
	on_change_score.emit(score)
