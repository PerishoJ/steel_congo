extends ColorRect

@onready var commentField: PackedScene = preload("res://levels/network_testing/chat_comment.tscn")
# Called when the node enters the scene tree for the first time.
@onready var inputTextField : TextEdit = $VBoxContainer/Input
@onready var comments : VBoxContainer = $VBoxContainer/Comments
func _ready():
  pass # Replace with function body.

func _input(event):
  if event is InputEventKey and (event as InputEventKey).physical_keycode == KEY_ENTER:
    if inputTextField.text.strip_edges(true,true) == "":
      print("empty field")
    else:
      rpc ( "post_comment" ,( inputTextField.text.strip_edges(true,true) ) )
      inputTextField.text = ""

@rpc("any_peer","call_local")
func post_comment(commentText):
  print("commenting " + commentText +"  --  " +str(multiplayer.get_unique_id()))
  var comment = commentField.instantiate()
  comment.name = str(multiplayer.get_unique_id())
  comment.text = "Name:"+commentText
  comments.add_child(comment)


func _on_button_pressed():
  var btn:Button = $VBoxContainer/Comments/ServerButton 
  btn.disabled = true
  btn.text = "Server Mode Enabled"
  NetworkChat.make_server()
  # disable client option
  btn = $VBoxContainer/Comments/ClientButton 
  btn.disabled = true
  pass # Replace with function body.


func _on_client_button_pressed():
  var btn:Button = $VBoxContainer/Comments/ClientButton 
  btn.disabled = true
  btn.text = "Client Mode Enabled"
  NetworkChat.connect_client()
  # disable server option
  btn = $VBoxContainer/Comments/ServerButton 
  btn.disabled = true
  pass # Replace with function body.
