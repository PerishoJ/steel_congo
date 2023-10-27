extends CharacterBody3D

signal command_to_location
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var click_distance = 30
var _selected_grapes = {}

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@export var spawnMesh : MeshInstance3D

var _is_drag_select = false

func _unhandled_input(event: InputEvent) -> void:
  _handle_mouse_movement(event)
  if (event is InputEventMouseButton):
    var ray_result = _raycast_from_mouse()
    if event.button_index == MouseButton.MOUSE_BUTTON_LEFT :
      if event.double_click :
        _is_drag_select = false
        _handle_grape_select(ray_result)
      elif not _is_drag_select and event.is_pressed() and ray_result.has("collider"):
        $"CanvasLayer/Player Name".text = "start drag"
        _is_drag_select = true
      elif _is_drag_select and event.is_pressed() and ray_result.has("collider"):
        pass
      elif _is_drag_select and not event.is_pressed() and ray_result.has("collider"):
        $"CanvasLayer/Player Name".text = "end drag"
        _is_drag_select = false
    elif event.button_index == MouseButton.MOUSE_BUTTON_RIGHT :
      _handle_grape_command(ray_result)


  
  
func _raycast_from_mouse():
  var mouse_pos = get_viewport().get_mouse_position()
  var ray_start = camera.project_ray_origin(mouse_pos)
  var ray_end = ray_start + camera.project_ray_normal(mouse_pos) * click_distance
  # cast ray
  # var collision_mask = 0b10000000_00000000_00000000_00001111
  var ray_params:PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_start,ray_end)
  return get_world_3d().direct_space_state.intersect_ray(ray_params)


func _handle_grape_select(result: Dictionary):
  if result.has('collider') and result.collider is RobotController:
    $"CanvasLayer/Player Name".text = result.collider.character_name
    #Connect some signals.
    #Display the Name of the Grape
  pass
  

func _handle_grape_command(result : Dictionary):
  #TODO make this check better - floors, triggers are separate
  var is_floor = result.has('collider') and not result.collider is RobotController
  if is_floor:
    $"CanvasLayer/Player Name".text = "probably the floor"
    command_to_location.emit(result)
  else:
    $"CanvasLayer/Player Name".text = "...something??"


func _handle_mouse_movement(event: InputEvent):
  if event is InputEventMouseButton:
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  elif event.is_action_pressed("ui_cancel"):
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
  if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
    if event is InputEventMouseMotion:
      neck.rotate_y(-event.relative.x * 0.01)
      camera.rotate_x(-event.relative.y * 0.01)
      camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))


func _physics_process(delta: float) -> void:
  _handle_walk_jump(delta)
  move_and_slide()


func _handle_walk_jump(delta: float):
  # Add the gravity.
  if not is_on_floor():
    velocity.y -= gravity * delta

  # Handle Jump.
  if Input.is_action_just_pressed("ui_accept") and is_on_floor():
    velocity.y = JUMP_VELOCITY

  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
  var input_dir := Input.get_vector("left", "right", "up", "down")
  var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
  if direction:
    velocity.x = direction.x * SPEED
    velocity.z = direction.z * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)
    velocity.z = move_toward(velocity.z, 0, SPEED)
