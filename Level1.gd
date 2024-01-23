extends Node2D

var saved : bool = false
var end_screen : bool = false
var fires = []

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	$nervousAnimatedSprite2D.play()
	for i in $FireControl.get_children():
		i.play()

func new_game():
	$GameOver.visible = false
	get_tree().paused = false
	GameVariables.time_elapsed = 0
	GameVariables.remaining_mines = GameVariables.mines
	un_saved()
	for i in $FireControl.get_children():
		i.modulate.a = 1
		i.scale = Vector2(1.765, 2.039)
	end_screen = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not end_screen:
		GameVariables.time_elapsed += delta
		$HUD/TimeLabel.text = str(int(GameVariables.time_elapsed))
		$HUD/RemainingMinesLabel.text = str(GameVariables.remaining_mines)
	
	if saved and end_screen:
		#for i in fires:
		for i in $FireControl.get_children():
			while i.scale.x > 0:
				i.scale -= Vector2(0.005,0.005)
				i.modulate.a -= .01
				await get_tree().create_timer(.1).timeout
	elif not saved and end_screen:
		for i in $FireControl.get_children():
			while i.scale.x < 3:
				i.scale += Vector2(0.5,0.5)
				await get_tree().create_timer(.1).timeout

func un_saved():
	saved = false
	$nervousAnimatedSprite2D.visible = true
	$happyAnimatedSprite2D.visible = false
	$happyAnimatedSprite2D.pause()

func game_result(result):
	#get_tree().paused = true
	end_screen = true
	$GameOver.show()
	if result == 1:
		$GameOver.get_node("Label").text = "YOU WIN!"
		$nervousAnimatedSprite2D.visible = false
		saved = true
	else:
		$GameOver.get_node("Label").text = "BOOM!.."


func _on_tile_map_lost_game():
	game_result(0)


func _on_game_over_try_again():
	new_game()


func _on_tile_map_won_game():
	game_result(1)

