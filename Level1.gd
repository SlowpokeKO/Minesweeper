extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()

func new_game():
	$GameOver.visible = false
	get_tree().paused = false
	GameVariables.time_elapsed = 0
	GameVariables.remaining_mines = GameVariables.mines

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	GameVariables.time_elapsed += delta
	$HUD/TimeLabel.text = str(int(GameVariables.time_elapsed))
	$HUD/RemainingMinesLabel.text = str(GameVariables.remaining_mines)

func game_result(result):
	get_tree().paused = true
	$GameOver.show()
	if result == 1:
		$GameOver.get_node("Label").text = "YOU WIN!"
	else:
		$GameOver.get_node("Label").text = "BOOM!.."

func _on_tile_map_lost_game():
	game_result(0)


func _on_game_over_try_again():
	new_game()


func _on_tile_map_won_game():
	game_result(1)
