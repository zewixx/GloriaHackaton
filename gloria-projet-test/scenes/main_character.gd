extends CharacterBody2D

@onready var hurtbox: Area2D = $hurtbox
#const GRAVITY : float = 600.0
#@export_group("Player Movment")
#@export var horizontal_speed : float = 90.0
#@export var ladder_pseed : float = -20.0
#@export var jump_speed : float = -160.0
var is_crouching = false
#var dead = false :
#	set(value) :
#		dead = value
#		if value == true:
			#trigger_death()
			#func die():
#			$AnimatedSprite2D.play("die")
#			await $AnimatedSprite2D.animation_finished
#			get_tree().change_scene_to_file("res://scenes/game_over.tscn")



const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const SUPERJUMP_VELOCITY = -800.0

@onready var animated_sprite = $AnimatedSprite2D


	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():	
		velocity += get_gravity() * delta
	if Input.is_action_just_released("ui_down"):
		is_crouching = false	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		#Sprite("jump")
	
	if Input.is_action_just_pressed("ui_down") and is_on_floor():
		velocity.y = SUPERJUMP_VELOCITY
		is_crouching = true
		$AnimatedSprite2D.play("crouch")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.stop()
		
		#SPEED = 500.0
		#func _ready()
		#	velocity = Vector2(-200; -200),normalized() * speed
		#func _physics_process(delta):
		#	var collision = SUPERJUMP_VELOCITY(velocity * delta)
		#	if collision:
		#		velocity = velocity.bounce(collision.get_normal)




	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if not is_crouching:
			animated_sprite.play("walk")
		animated_sprite.flip_h = direction > 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if not is_crouching:
			animated_sprite.play("idle")

	move_and_slide()

var dead = false


func _ready() -> void:
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)

func die() -> void:
	set_physics_process(false)
	$AnimatedSprite2D.play("die")
	await $AnimatedSprite2D.animation_finished
	get_tree().reload_current_scene.call_deferred()
	#get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("killzone"):
		die()
		print("kk")
