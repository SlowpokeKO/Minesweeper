extends TileMap
signal wonGame
signal lostGame

#grid sizes
const ROWS : int = 14
const COLS: int = 15
const CELL_SIZE: int = 50

#tilesets
var tile_id: int = 0
var tiles2_id: int = 2

#tilemap layers
var mine_layer: int = 0
var numbers_layer: int = 1
var grass_layer: int = 2
var flag_layer: int = 3
var hover_layer: int = 4

#atlas coords in tileset
var mine_atlas := Vector2i(4, 0)
var number_atlas : Array = generate_number_atlas()
var hover_atlas := Vector2i(6, 0)
var dark_hover_atlas := Vector2i(0, 0)
var flag_atlas := Vector2i(5, 0)

#array to store mine coords
var mine_coords := []

var tiles_left : int

var end_screen = false

func generate_number_atlas():
	var a := []
	for i in range(8):
		a.append(Vector2i(i, 1))
	return a

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	

func new_game():
	clear()
	mine_coords.clear()
	generate_mines()
	generate_numbers()
	generate_grass()
	tiles_left = ROWS * COLS - GameVariables.mines
	set_layer_modulate(numbers_layer, Color(1, 1, 1, 1))
	set_layer_modulate(grass_layer, Color(1, 1, 1, 1))
	end_screen = false
	once = 1
	

func generate_mines():
	for i in range(GameVariables.mines):
		var mine_pos = Vector2i(randi_range(0, COLS -1), randi_range(0, ROWS -1))
		while mine_coords.has(mine_pos):
			mine_pos = Vector2i(randi_range(0, COLS -1), randi_range(0, ROWS -1))
		mine_coords.append(mine_pos)
		#add mine to tilemap
		set_cell(mine_layer, mine_pos, tile_id, mine_atlas)

func generate_numbers():
	for i in get_empty_cells():
		var mine_count : int = 0
		for j in get_all_surrounding_cells(i):
			#check if there is a mine in the cell
			if is_mine(j):
				mine_count += 1
			#once counted add numbered cell to the tilemap
			if mine_count > 0:
				set_cell(numbers_layer, i, tile_id, number_atlas[mine_count -1])

func generate_grass():
	for y in range(ROWS):
		for x in range(COLS):
			var toggle = (x + y) % 2
			set_cell(grass_layer, Vector2i(x, y), tile_id, Vector2i(3 - toggle, 0))

func get_empty_cells():
	var empty_cells := []
	#iterate over grid
	for y in range(ROWS):
		for x in range(COLS):
			#check if cell is empty
			if not is_mine(Vector2i(x, y)):
				empty_cells.append(Vector2i(x, y))
	return empty_cells



func get_all_surrounding_cells(middle_cell):
	var surrounding_cells := []
	var target_cell
	for y in range(3):
		for x in range(3):
			target_cell = middle_cell + Vector2i(x-1, y -1)
			#skip cell if it is the one in the middle
			if target_cell != middle_cell:
				#check that the cell is on the grid
				if (target_cell.x >= 0 and target_cell.x <= COLS -1 and target_cell.y >= 0 and target_cell.y <= ROWS-1):
					surrounding_cells.append(target_cell)
	return surrounding_cells

func _input(event):
	if event is InputEventMouseButton:
		#check if mouse is on gameboard
		if event.position.y < ROWS * CELL_SIZE:
			var map_pos := local_to_map(event.position)
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				#check that there is no flag
				if not is_flag(map_pos):
					#check if it is a mine
					if is_mine(map_pos):
						lostGame.emit()
						end_screen = true
					
					process_left_click(map_pos)
			
			#right click places and removes flags
			elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				process_right_click(map_pos)

func process_left_click(pos):
	var revealed_cells := []
	#add position to list of cells to reveal
	var cells_to_reveal := [pos]
	while not cells_to_reveal.is_empty():
		if is_grass(cells_to_reveal[0]):
			#clear the cell and mark it cleared
			erase_cell(grass_layer, cells_to_reveal[0])
			revealed_cells.append(cells_to_reveal[0])
			#if the cell has a flag, remove it
			if is_flag(cells_to_reveal[0]):
				erase_cell(flag_layer, cells_to_reveal[0])
			if not is_number(cells_to_reveal[0]):
				cells_to_reveal = reveal_surrounding_cells(cells_to_reveal, revealed_cells)
			#remove processed cell from array
			cells_to_reveal.erase(cells_to_reveal[0])
			tiles_left -= 1
			if tiles_left <= 0:
				wonGame.emit()
				
				#put on show after winning
				end_screen = true
				while get_layer_modulate(numbers_layer).a > 0:
					set_layer_modulate(numbers_layer, Color(1, 1, 1, get_layer_modulate(numbers_layer).a - 0.05))
					set_layer_modulate(grass_layer, Color(1, 1, 1, get_layer_modulate(grass_layer).a - 0.05))
					await get_tree().create_timer(.1).timeout
				#then
				if get_layer_modulate(numbers_layer).a <= 0:
					var mines : Array[Vector2i] = get_used_cells(mine_layer)
					print(mines)
					#mines.y.sort_custom(func(b, a): return a[0] > b[0])
					#y_sort_enabled = true
					
					mines.sort_custom(sort_height)
					print(mines)
					for i in mines:
						
						#mines[i]
						
						var falling_mine = preload("res://falling_mine.tscn").instantiate()
						falling_mine.position = i * 50 + Vector2i(25, 25)
						add_child(falling_mine)
						erase_cell(mine_layer, i)
						await get_tree().create_timer(.5).timeout
		else:
			break

func sort_height(a, b):
	if a.y < b.y:
		return true
	return false

#func sort_height(a, b):
#	if a[0] < b[0]:
#		return true
#	return false


func process_right_click(pos):
	#check if it is a grass cell
	if is_grass(pos):
		if is_flag(pos):
			erase_cell(flag_layer, pos)
			GameVariables.remaining_mines += 1
		else:
			set_cell(flag_layer, pos, tile_id, flag_atlas)
			GameVariables.remaining_mines -= 1

func reveal_surrounding_cells(cells_to_reveal, revealed_cells):
	for i in get_all_surrounding_cells(cells_to_reveal[0]):
		#check that the cell is not already revealed
		if is_grass(i):
			if not revealed_cells.has(i):
				if not cells_to_reveal.has(i):
					cells_to_reveal.append(i)
	return cells_to_reveal

var once = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not end_screen:
		highlight_cell()
	else:
		if once:
			clear_layer(hover_layer)
			once -= 1

func highlight_cell():
	var mouse_pos := local_to_map(get_local_mouse_position())
	#clear hover tiles
	clear_layer(hover_layer)
	#hover over grass cells
	if is_grass(mouse_pos):
		set_cell(hover_layer, mouse_pos, tile_id, hover_atlas)
	else:
		#if cell is cleared only hover over numbered cells
		if is_number(mouse_pos):
			set_cell(hover_layer, mouse_pos, tiles2_id, dark_hover_atlas)
	if end_screen:
		clear_layer(hover_layer)

func is_grass(pos):
	#looks in grass layer and return if something is there or not
	return get_cell_source_id(grass_layer, pos) != -1

func is_number(pos):
	return get_cell_source_id(numbers_layer, pos) != -1

func is_mine(pos):
	return get_cell_source_id(mine_layer, pos) != -1

func is_flag(pos):
	return get_cell_source_id(flag_layer, pos) != -1


func _on_game_over_try_again():
	new_game()
