extends Control
signal spawn_cats

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
