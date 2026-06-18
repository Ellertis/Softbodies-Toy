extends Node2D

@export var debug_gyroscope: Label
@export var fpscounter: Label
@export var debug_gravity_direction: Label
@export var debug_accelerometer: Label

func _physics_process(_delta):
	var InputGravity: Vector3 = Input.get_gravity()
	Input.get_gyroscope()
	var InputAcceleration: Vector3 = Input.get_accelerometer()
	Input.get_magnetometer()
	Input.get_gravity()
	debug_gyroscope.text = "Gyroscope value : " + "X: " + str(roundf(InputGravity.x)) + " Y: " + str(roundf(InputGravity.y)) + " Z: " + str(roundf(InputGravity.z))
	debug_accelerometer.text = "Accelerometer : " + "X: " +str(roundf(InputAcceleration.x)) + " Y: " + str(roundf(InputAcceleration.y)) + " Z: " + str(roundf(InputAcceleration.z))
	
	var OutputGravity: Vector2 = Vector2(InputGravity.x,-InputGravity.y)
	var debug_gravity_direction_text: String = "Gravity Direction : " + "X: " + str(OutputGravity.x) + " Y: " + str(OutputGravity.y)
	debug_gravity_direction.text = debug_gravity_direction_text
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, OutputGravity.normalized())
	
	var OutputGravityLength: Vector2 = OutputGravity*100 #Convert m/s to px/s
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, OutputGravityLength.length())


func _process(_delta):
	fpscounter.text = "FPS: %d" % Engine.get_frames_per_second()

func _on_reset_button_pressed():
	get_tree().reload_current_scene()

func _on_gravity_button_pressed() -> void:
	set_physics_process(!is_physics_processing())
	
	#Set default values
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, Vector2(0,1))
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, 980.0)
	
