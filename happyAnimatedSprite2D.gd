extends AnimatedSprite2D

var saved = false
var dance_speed = 50
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if saved == true:
		self.position.x -= dance_speed * delta
		if self.position.x > 475 or self.position.x < 325:
			dance_speed *= -1
			self.scale.x *= -1


func _on_tile_map_won_game():
	self.play()
	saved = true
	self.visible = true
