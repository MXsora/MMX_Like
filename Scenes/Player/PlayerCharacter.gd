extends CharacterBody2D

const RIGHT : int = 1
const LEFT : int = -1

var SPEED = 300.0
var speed = 300.0
const JUMP_VELOCITY = -400.0
var PlayerInput : bool = false
var SpentDash : bool = false
var FacingDirection : int = -1
var IsShooting : bool = false
var IsDashing : bool = false

const GhostResource = preload("res://Scenes/Effects/ghost_fade.tscn")
var ghostCounter : int = 0
@onready var DashTimer = $DashTimer

const BasicShotResource = preload("res://Scenes/Effects/shot.tscn")
const ShotEffectResource = preload("res://Scenes/Effects/shot_effect.tscn")
@onready var BusterPosition = $BusterPosition
@onready var ShotTimer = $ShotTimer

var ChargeCounter : int = 0
var ChargeLevel : int = 0
var MaxChargeLevel : int = 2

var Health : int = 16

var CurrentState

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var PlayerSprite = $AnimatedSprite2D
@onready var CurrentPlayerSprite = PlayerSprite.sprite_frames
@onready var DebugStateLabel = $CurrentStateDebug


func _ready():
	pass

func _input(event):
	if(PlayerInput == false):
		pass
	
	#Basic attack
	if(event.is_action_pressed("Shot")):
		#If more than 3 shots exist, ignore shot button presses
			if(get_tree().get_nodes_in_group("PlayerProjectiles").size() >= 3):
				pass
			else:
				basicShot()
	

func _physics_process(delta):
	
	handleCharging()


func basicShot():
	IsShooting = true
	ShotTimer.start(0.3)
	var BasicShotInstance = BasicShotResource.instantiate()
	var ShotEffectInstance = ShotEffectResource.instantiate()
	BasicShotInstance.getDirection(Vector2(FacingDirection, 0))
	if(FacingDirection == LEFT):
		ShotEffectInstance.flip_h = true
		BasicShotInstance.flip(true)
	get_parent().add_child(BasicShotInstance)
	add_child(ShotEffectInstance)
	BasicShotInstance.position = BusterPosition.global_position
	ShotEffectInstance.position = BusterPosition.position

func handleCharging():
	if(ChargeLevel == MaxChargeLevel):
		pass
	else:
		ChargeCounter += 1
		if(ChargeCounter > 200):
			ChargeLevel += 1
			ChargeCounter = 0
			
func takeDamage(damage):
	Health -= damage


func setDashProperties():
	IsDashing = true
	DashTimer.start(0.7)
	if(!is_on_floor()):
		SpentDash = true

func resetDashProperties():
	IsDashing = false
	SpentDash = false

func changeFacingDirection(direction):
	if(FacingDirection == direction):
		pass
	else:
		FacingDirection = direction
		flipPlayerSprite()
		flipBusterPosition()

func flipBusterPosition():
	BusterPosition.position.x = BusterPosition.position.x * -1

func flipPlayerSprite():
	PlayerSprite.flip_h = !PlayerSprite.flip_h

func ghostEffect():
	ghostCounter += 1
	if(ghostCounter > 2):
		var GhostInstance = GhostResource.instantiate()
		get_parent().add_child(GhostInstance)
		GhostInstance.set_texture(CurrentPlayerSprite.get_frame_texture(PlayerSprite.animation, PlayerSprite.frame))
		GhostInstance.flip_h = PlayerSprite.flip_h
		GhostInstance.position = global_position
		ghostCounter = 0

func _on_shot_timer_timeout():
	IsShooting = false

func handle_horizontal():
	var input_direction_x: float = (
		Input.get_action_strength("Right") - Input.get_action_strength("Left")
	)
	
	if (velocity.x > 0):
		PlayerSprite.flip_h = true
	elif (velocity.x < 0):
		PlayerSprite.flip_h = false
	
	velocity.x = speed * input_direction_x