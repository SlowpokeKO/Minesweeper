extends Control

#variables for cat face
var happy : bool = false
var rotate_range = deg_to_rad(60)
var rotate_speed = 5
var rotate_start
var position_start
var speed = 5.0

#level variables
@onready var levels = $Levels.get_children()
@onready var selected_level = levels[0]

func _ready():
	rotate_start = $Sprite2D.rotation
	position_start = $Sprite2D.position
	
	$LeftButton.disabled = true

func _process(delta):
	if happy == true:
		$Sprite2D.rotation += rotate_speed * delta
		var rotate_diff = $Sprite2D.rotation - rotate_start 
		if abs(rotate_diff) > rotate_range:
			$Sprite2D.rotation = rotate_start + rotate_range * sign(rotate_diff)
			rotate_speed *= -1
		if rotate_speed > 0:
			$Sprite2D.position.x += speed
		else:
			$Sprite2D.position.x -= speed
		#check for direction from start
		if ($Sprite2D.position.x < position_start.x and rotate_speed > 0) or ($Sprite2D.position.x > position_start.x and rotate_speed < 0):
			$Sprite2D.position.y += speed /3
		else:
			$Sprite2D.position.y -= speed /3



func _on_play_button_mouse_entered():
	happy = true


func _on_play_button_mouse_exited():
	happy = false
	$Sprite2D.rotation = rotate_start
	$Sprite2D.position = position_start


func _on_play_button_pressed():
	print(selected_level.name)
	# ?do something if fails?
	get_tree().change_scene_to_file("res://" +selected_level.name+ ".tscn")


func _on_right_button_pressed():
	if levels.find(selected_level) < len(levels):
		change_level(1)

func _on_left_button_pressed():
	if levels.find(selected_level) > 0:
		change_level(-1)

func change_level(direction):
	selected_level.visible = false
	selected_level = levels[levels.find(selected_level) + direction]
	selected_level.visible = true
	if levels.find(selected_level) + 1 == len(levels):
		$RightButton.disabled = true
	else:
		$RightButton.disabled = false
	
	if levels.find(selected_level) == 0:
		$LeftButton.disabled = true
	else:
		$LeftButton.disabled = false





func _on_back_button_pressed():
	self.visible = false
	get_parent_control().get_node("main_ui").visible = true
