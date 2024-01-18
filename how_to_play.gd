extends Control





func _on_back_button_pressed():
	#get_tree().change_scene_to_file("res://main.tscn")
	self.visible = false
	get_parent_control().get_node("main_ui").visible = true
