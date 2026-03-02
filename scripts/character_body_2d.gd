extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var cast: RayCast2D = $RayCast2D
@onready var timer: Timer = $Timer
@onready var line_2d: Line2D = $Line2D

const SPEED = 100.0
const DASH_VEL = 300
const THROW_VEL = 8
const JUMP_VELOCITY = -400.0

var dashing = false
var direction = "up"
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
			add_child(held_block) 
			held_block.position = Vector2(0, -16) 

func drop_block():
	if held_block:
		held_block.get_node("CollisionShape2D").disabled = false
		remove_child(held_block)
		get_parent().add_child(held_block) 
		held_block.global_position = global_position + cast.target_position  
		held_block = null
		
func _physics_process(delta: float) -> void:
	var direction_y := Input.get_axis("ui_up", "ui_down")
	var direction_x := Input.get_axis("ui_left", "ui_right")
	
	if dashing:
		self.set_collision_layer_value(1, false)
		self.set_collision_layer_value(2, false)
		self.set_collision_layer_value(5, false)
		self.set_collision_mask_value(1, true)
		self.set_collision_mask_value(2, false)
		if direction_x != 0:
			velocity.x = direction_x * DASH_VEL
			if direction_x == 1:
				sprite.play("runright")
				cast.position = Vector2(0, 5)
				cast.target_position = Vector2(20,0)
				cast.scale = Vector2(1, 3)
				direction = "right"
				
			elif direction_x == -1:
				sprite.play("runleft")
				cast.position = Vector2(0, 5)
				cast.target_position = Vector2(-20,0)
				cast.scale = Vector2(1, 3)
				direction = "left"
			
		elif direction_y != 0:
			velocity.y = direction_y * DASH_VEL 
			if direction_y == 1:
				sprite.play("runup")
				cast.position = Vector2(0, 5)
				cast.target_position = Vector2(0, 20)
				cast.scale = Vector2(3, 1)
				direction = "up"
			elif direction_y == -1:
					sprite.play("rundown")
					cast.position = Vector2(0, 0)
					cast.target_position = Vector2(0, -20)
					cast.scale = Vector2(3, 1)
					direction = "down"
				
	if Input.is_action_just_pressed("dash") and dashing == false:
		dashing = true
		timer.start()
	
	if direction_x != 0.0 and direction_y != 0.0 and dashing == false:
		velocity.x = (direction_x * SPEED) / sqrt(2)
		velocity.y = (direction_y * SPEED) / sqrt(2)
		
	elif direction_x != 0.0 and dashing == false or direction_y != 0.0 and dashing == false:
		if direction_x != 0:
			velocity.x = direction_x * SPEED
			if direction_x == 1:
				sprite.play("runright")
				cast.position = Vector2(0, 5)
				cast.target_position = Vector2(20,0)
				cast.scale = Vector2(1, 3)
				direction = "right"
				
			elif direction_x == -1:
				sprite.play("runleft")
				cast.position = Vector2(0, 5)
				cast.target_position = Vector2(-20,0)
				cast.scale = Vector2(1, 3)
				direction = "left"
				
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if direction_y != 0:
			velocity.y = direction_y * SPEED
			if direction_y == 1:
				sprite.play("runup")
				cast.position = Vector2(0, 5)
				cast.target_position = Vector2(0, 20)
				cast.scale = Vector2(3, 1)
				direction = "up"
			elif direction_y == -1:
				sprite.play("rundown")
				cast.position = Vector2(0, 0)
				cast.target_position = Vector2(0, -20)
				cast.scale = Vector2(3, 1)
				direction = "down"
				
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		sprite.play(direction)
	if Input.is_action_just_pressed("ui_accept"):
		if !held_block:
			try_pickup();
		else:
			drop_block()
	if held_block:
		held_block.position = Vector2(0, -16)  	
	move_and_slide()


func _on_timer_timeout() -> void:
	dashing = false
	self.set_collision_layer_value(1, true)
	self.set_collision_layer_value(2, true)
	self.set_collision_mask_value(1, true)
	self.set_collision_mask_value(2, true)
	self.set_collision_mask_value(5, true)
