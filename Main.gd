extends Control

var catface_scene = preload("res://cat_ball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_catfaces()
#	var catface = preload("res://cat_ball.tscn").instantiate()
#	catface.global_position = Vector2(100,100)
#	add_child(catface)
#	var catface = preload("res://cat_ball.tscn").instantiate()
#	catface.global_position = Vector2(650,650)
#	add_child(catface)
#	var catface3 = preload("res://cat_ball.tscn").instantiate()
#	catface3.global_position = Vector2(650,100)
#	add_child(catface3)
#	var catface4 = preload("res://cat_ball.tscn").instantiate()
#	catface4.global_position = Vector2(100,650)
#	add_child(catface4)
	
func spawn_catfaces():
	for child in $CatfaceContainer.get_children():
		child.queue_free()
	for i in GameVariables.cat_faces:
		var catface = catface_scene.instantiate()
		catface.position = Vector2i(randi_range(30, 720), randi_range(30, 720))
		$CatfaceContainer.add_child(catface)



func _on_quit_button_pressed():
	get_tree().quit()


func _on_how_to_button_pressed():
	$main_ui.visible = false
	$HowToPlay.visible = true


func _on_levels_button_pressed():
	$main_ui.visible = false
	$LevelSelect.visible = true


func _on_settings_button_pressed():
	$main_ui.visible = false
	$Settings.visible = true


func _on_settings_spawn_cats():
	spawn_catfaces()
