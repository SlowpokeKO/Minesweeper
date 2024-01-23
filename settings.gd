extends Control
signal spawn_cats
var dif_mine_amount = [8, 20, 35, 55]


func _ready():
	$DifficultyDropDown.add_item("Easy")
	$DifficultyDropDown.add_item("Moderate")
	$DifficultyDropDown.add_item("Hard")
	$DifficultyDropDown.add_item("Impossible")

func _on_apply_button_pressed():
	self.visible = false
	get_parent_control().get_node("main_ui").visible = true
	if not $CatFaceNumTextEdit.text == "":
		GameVariables.cat_faces = int($CatFaceNumTextEdit.text)
		spawn_cats.emit()
		$CatFaceNumTextEdit.text = ""


func _on_back_button_pressed():
	self.visible = false
	get_parent_control().get_node("main_ui").visible = true


func _on_difficulty_drop_down_item_selected(index):
	GameVariables.mines = dif_mine_amount[index]
