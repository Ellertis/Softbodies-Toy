extends Node2D

@export_group("Debug","debug_")
@export var debug_gravity: Label
@export var debug_gravity_direction: Label
@export var debug_accelerometer: Label
@export var debug_accelerometerLength: Label
@export var debug_fpscounter: Label

@export_group("Acceleration","accel_")
@export var accel_threshold: float = 10
@export var accel_min: float = 0
@export var accel_max: float = 50
var accel_threshold_sq: float
var accel_min_sq: float
var accel_max_sq: float

func _ready():
	accel_threshold_sq = accel_threshold * accel_threshold
	accel_min_sq = accel_min * accel_min
	accel_max_sq = accel_max * accel_max

func _physics_process(_delta):
	var InputGravity: Vector3 = Input.get_gravity() #directional vector of gravity
	var InputGyroscope: Vector3 = Input.get_gyroscope() #angular velocity
	var InputAcceleration: Vector3 = Input.get_accelerometer() #spacial velocity
	var InputMagnetometer: Vector3 = Input.get_magnetometer()
	debug_gravity.text = "Gyroscope value : " + "X: " + str(roundf(InputGravity.x)) + " Y: " + str(roundf(InputGravity.y)) + " Z: " + str(roundf(InputGravity.z))
	
	#Gravity direction
	var OutputGravity: Vector2 = Vector2(InputGravity.x,-InputGravity.y)
	debug_gravity_direction.text = "Gravity Direction : " + "X: " + str(roundf(OutputGravity.x)) + " Y: " + str(roundf(OutputGravity.y))
	#PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, OutputGravity.normalized())
	
	#Gravity force relative to a rest pose when X&Y = 0
	var OutputGravityLength: Vector2 = OutputGravity*100 #Convert m/s to px/s
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, OutputGravityLength.length())
	
	#Acceleration
	#Negate gravity to get relative acceleration of the phone
	var InputAccelerationPure: Vector3 = InputGravity - InputAcceleration
	var OutputAcceleration: Vector2 = Vector2(InputGravity.x - InputAcceleration.x, InputGravity.y - InputAcceleration.y)
	var OutputAcceleration_length_sq = InputAccelerationPure.length_squared()
	debug_accelerometer.text = "Accelerometer : " + "X: " +str(roundf(InputAccelerationPure.x)) + " Y: " + str(roundf(InputAccelerationPure.y)) + " Z: " + str(roundf(InputAccelerationPure.z))
	debug_accelerometerLength.text = "Accel Length|Squared : " + str(roundf(InputAccelerationPure.length())) + " | " + str(roundf(OutputAcceleration_length_sq))
	var accel_magnitude:float = max(0.0,OutputAcceleration_length_sq - accel_threshold_sq)
	var accel_dir: Vector2 = OutputAcceleration.normalized() * accel_magnitude
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, OutputGravity.normalized() + accel_dir)

func _process(_delta):
	debug_fpscounter.text = "FPS: %d" % Engine.get_frames_per_second()

func _on_reset_button_pressed():
	get_tree().reload_current_scene()

func _on_gravity_button_pressed() -> void:
	set_physics_process(!is_physics_processing())
	
	#Set default values
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, Vector2(0,1))
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, 980.0)
	
