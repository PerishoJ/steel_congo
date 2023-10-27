extends Node3D
@export var grapeJuice: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_player_command_to_location(ray_result: Dictionary):
  if ray_result.has("position"):
    position = ray_result.position
    #_get_juiced_noob(ray_results)

func _get_juiced_noob(ray_result: Dictionary):
    var juiced = grapeJuice.instantiate()
    juiced.position = ray_result.position
    get_tree().current_scene.add_child(juiced)
