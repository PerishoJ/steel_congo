extends Node
class_name GameController

@export var level : Node3D;
@onready var spawner : Node3D = $Spawner
var bot_scene : PackedScene = preload("res://bot/bot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
  if(level==null):
    level = $Level
  #NetworkingImpl.set_game_controller(self)
  #NetworkingImpl.start()
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  if not players_to_spawn.is_empty():
    for id in players_to_spawn:
      _make_player(id)
  
  
var players_to_spawn = []

func add_player( id ) :
  if (spawner !=null):
    _make_player(id)
  else:
    players_to_spawn.append(id)
  
func _make_player(_id) -> bool:
  if spawner != null:
    var new_player = bot_scene.instantiate()
    spawner.add_child(new_player)
    return true
  else:
     return false
    

func remove_player( _id):
  pass
