extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
  if OS.is_debug_build():
    $UI_vbox/IsServerBtn.visible = true
  
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


#The Debug Toggle button can make this node a server
func _on_is_server_btn_toggled(button_pressed : bool):
  NetworkingImpl.set_server(button_pressed)



# Start the game
func _on_start_btn_pressed():
  get_tree().change_scene_to_file("res://levels/Level_1.tscn")
  pass # Replace with function body.
