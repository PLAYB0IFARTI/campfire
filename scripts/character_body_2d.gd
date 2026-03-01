extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var cast: RayCast2D = $RayCast2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var held_block: Node2D = null

func try_pickup():
	if held_block != null:
		return  # already holding something
	if cast.is_colliding():
		var collider = cast.get_collider()
		if collider.is_in_group("moveable"):
			held_block = collider
			held_block.get_node("CollisionShape2D").disabled = true
			held_block.get_parent().remove_child(held_block)
			add_child(held_block)  # attach to player
			held_block.position = Vector2(0, -16)  # offset in front of player

func drop_block():
	if held_block:
		held_block.get_node("CollisionShape2D").disabled = false
		remove_child(held_block)
		get_parent().add_child(held_block)  # put back in scene
		held_block.global_position = global_position + cast.target_position  # drop in front
		held_block = null
		
func _physics_process(delta: float) -> void:
	var direction_y := Input.get_axis("ui_up", "ui_down")
	var direction_x := Input.get_axis("ui_left", "ui_right")
	
	if direction_x != 0 && direction_y != 0:
		velocity.x = (direction_x * SPEED) / sqrt(2)
		velocity.y = (direction_y * SPEED) / sqrt(2)
	else:
		if direction_x != 0:
			velocity.x = direction_x * SPEED
			if direction_x == 1:
				sprite.play("right")
				cast.position = Vector2(0, 5)
				cast.target_position = Vector2(20,0)
				cast.scale = Vector2(1, 3)
				
			elif direction_x == -1:
				sprite.play("left")
				cast.position = Vector2(0, 5)
				cast.target_position = Vector2(-20,0)
				cast.scale = Vector2(1, 3)
				
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if direction_y != 0:
			velocity.y = direction_y * SPEED
			if direction_y == 1:
				sprite.play("up")
				cast.position = Vector2(0, 5)
				cast.target_position = Vector2(0, 20)
				cast.scale = Vector2(3, 1)
			elif direction_y == -1:
				sprite.play("down")
				cast.position = Vector2(0, 0)
				cast.target_position = Vector2(0, -20)
				cast.scale = Vector2(3, 1)
				
		else:
			velocity.y = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("ui_accept"):
		if !held_block:
			try_pickup();
		else:
			drop_block()
	if held_block:
		# Keep the block in front of player (smoothly or fixed)
		held_block.position = Vector2(0, -16)  # adjust offset as needed		
	move_and_slide()
