extends CharacterBody3D

class_name RobotController
"""
Signal must be connect to on_player_command to work.
Moves toward 'commanded_target' until it is close enough to stop.
"""

var commanded_target: Vector3 #Get this from the Player's Double clicking around...or other
@onready var character_mesh: MeshInstance3D = $Mesh # the visual representation of the character

@export var character_name = "John Doe"
@export var debug : bool = false;
var close_enough_to_target_threshold = .2 # squared distance in meters to target to achieve 
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ROTATION_RATE = PI / 6

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
    if debug:
        $_debug_label_name.text = character_name
    

func _physics_process(delta):
    # Add the gravity.
    if not is_on_floor():
        velocity.y -= gravity * delta

    # Handle Jump.
    #if Input.is_action_just_pressed("ui_accept") and is_on_floor():
    #	velocity.y = JUMP_VELOCITY
    _face_target( commanded_target )
    _move_toward_target( commanded_target )
    move_and_slide()


func _process(_delta):
    pass
#	if velocity.length() > 0:
#		$AnimationPlayer.play("hop")
#	elif $AnimationPlayer.is_playing():
#		$AnimationPlayer.stop()


func _move_toward_target(target_location:Vector3):
    var should_be_closer = target_location.distance_squared_to(self.position)>close_enough_to_target_threshold
    var has_target = target_location!=null 
    if(has_target and should_be_closer and is_on_floor() ):
        
        var direction = character_mesh.rotation.y
        if direction: # in what situation is direction null? When rotation.y == 0 edgecase maybe?
            velocity.x = sin(direction) * SPEED
            velocity.z = cos(direction) * SPEED
        else:
            velocity.x = move_toward(velocity.x, 0, SPEED)
            velocity.z = move_toward(velocity.z, 0, SPEED)
            pass
    else:
        velocity.x = move_toward( velocity.x , 0.0 , 2)
        velocity.z = move_toward( velocity.z , 0.0 , 2)


func _face_target(target: Vector3):
    if(target!=null ):
        var dir_vec:Vector3 = target - position
        var rotation_t = atan2(dir_vec.x, dir_vec.z)
        var does_need_rotation = rotation_t > PI/100
        if(does_need_rotation):
            rotation_t = lerp( character_mesh.rotation.y , rotation_t , 0.2)
        character_mesh.rotate(Vector3.UP, rotation_t - character_mesh.rotation.y)


func _on_player_command_to_location(ray_result: Dictionary):
    if ray_result.has("position"):
        commanded_target = ray_result.position
