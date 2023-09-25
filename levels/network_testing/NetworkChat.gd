extends Node


var Id: String
var _port: int = 20001

func _init():
  Id= str( randi_range(1,9999) )


func _ready():
  #negotiate client/server model
  var network: MultiplayerPeer = ENetMultiplayerPeer.new()
  network.create_client("localhost",_port)
  network.peer_connected.connect(_peer_connected)
  multiplayer.multiplayer_peer = network
  _delayed_server_startup_init()

func _peer_connected():
  print(Id + " remains a client")
  DisplayServer.window_set_title("Client:"+Id)


func _delayed_server_startup_init():
  var _delay_timer : Timer = Timer.new();
  self.add_child(_delay_timer)
  _delay_timer.timeout.connect(_server_check)
  _delay_timer.start( randf_range( 1.0 , 4.0 ) )
  pass

func _server_check():
  if not is_connected_to_server():
    var network: MultiplayerPeer = ENetMultiplayerPeer.new()
    network.create_server(_port)
    multiplayer.multiplayer_peer = network
    DisplayServer.window_set_title("Server:"+Id)
  else:
    _peer_connected()
    
func is_connected_to_server() -> bool:
  return ( not multiplayer.multiplayer_peer is OfflineMultiplayerPeer) \
    and multiplayer.multiplayer_peer.get_connection_status()==MultiplayerPeer.CONNECTION_CONNECTED
