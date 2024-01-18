extends CanvasLayer
signal tryAgain

# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel.modulate.a = 0.25


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_try_again_button_pressed():
	tryAgain.emit()
