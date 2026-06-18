extends Node2D

@export var debug_gravity: Label
@export var debug_gravity_direction: Label
@export var debug_accelerometer: Label
@export var degub_accelerometerLength: Label
@export var fpscounter: Label

func _physics_process(_delta):
	var InputGravity: Vector3 = Input.get_gravity() #directional vector of gravity
	var InputGyroscope: Vector3 =Input.get_gyroscope() #angular velocity
	var InputAcceleration: Vector3 = Input.get_accelerometer() #spacial velocity
	var InputMagnetometer: Vector3 = Input.get_magnetometer()
	debug_gravity.text = "Gyroscope value : " + "X: " + str(roundf(InputGravity.x)) + " Y: " + str(roundf(InputGravity.y)) + " Z: " + str(roundf(InputGravity.z))
	
	#Gravity direction
	var OutputGravity: Vector2 = Vector2(InputGravity.x,-InputGravity.y)
	debug_gravity_direction.text = "Gravity Direction : " + "X: " + str(roundf(OutputGravity.x)) + " Y: " + str(roundf(OutputGravity.y))
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, OutputGravity.normalized())
	
	#Gravity force relative to a rest pose when X&Y = 0
	var OutputGravityLength: Vector2 = OutputGravity*100 #Convert m/s to px/s
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, OutputGravityLength.length())
	
	#Acceleration
	#Negate gravity to get relative acceleration of the phone
	var OutputAcceleration: Vector3 = InputGravity - InputAcceleration
	debug_accelerometer.text = "Accelerometer : " + "X: " +str(roundf(OutputAcceleration.x)) + " Y: " + str(roundf(OutputAcceleration.y)) + " Z: " + str(roundf(OutputAcceleration.z))
	degub_accelerometerLength.text = "Accel Length|Squared : " + str(roundf(OutputAcceleration.length())) + " | " + str(roundf(OutputAcceleration.length_squared()))

func _process(_delta):
	fpscounter.text = "FPS: %d" % Engine.get_frames_per_second()

func _on_reset_button_pressed():
	get_tree().reload_current_scene()

func _on_gravity_button_pressed() -> void:
	set_physics_process(!is_physics_processing())
	
	#Set default values
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, Vector2(0,1))
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, 980.0)
	
