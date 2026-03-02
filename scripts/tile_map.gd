extends TileMap



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
signal moved_to_cell(cell)

func update_cell():
	var cell = self.local_to_map(global_position)
	moved_to_cell.emit(cell)


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
