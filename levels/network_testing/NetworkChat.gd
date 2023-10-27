extends Node


var Id: String
var _port: int = 20001

func _init():
  Id= str( randi_range(1,9999) )


func _ready():
  #negotiate client/server model
  #var network: MultiplayerPeer = ENetMultiplayerPeer.new()
  connect_client()
  
func connect_client():
  var network: MultiplayerPeer = WebSocketMultiplayerPeer.new()
  if network is WebSocketMultiplayerPeer:
    network.create_client("ws://localhost:"+str(_port))
  elif network is ENetMultiplayerPeer:
    network.create_client("localhost",_port)
  network.peer_connected.connect(_peer_connected)
  multiplayer.multiplayer_peer = network
  #_delayed_server_startup_init()

func _peer_connected():
  print(Id + " remains a client")
  DisplayServer.window_set_title("Client:"+Id)

#DEPRECATED We now use the server button to determine who is the server.
func _delayed_server_startup_init():
  var _delay_timer : Timer = Timer.new();
  self.add_child(_delay_timer)
  _delay_timer.timeout.connect(_server_check)
  _delay_timer.start( randf_range( 1.0 , 4.0 ) )
  pass

func _server_check():
  if not is_connected_to_server():
   make_server()
  else:
    pass
    # DEPRECATED used to check to ensure is server...but it never worked right sooo...
    # _peer_connected()

func make_server():
  var network: MultiplayerPeer = WebSocketMultiplayerPeer.new()
  #    var network: MultiplayerPeer = ENetMultiplayerPeer.new()
  network.create_server(_port)
  multiplayer.multiplayer_peer = network
  DisplayServer.window_set_title("Server:"+Id)

"""
This was always a little jankity, but it's supposed to check if we're connected.
Although, probably a connection callback would be a better approach.
"""
func is_connected_to_server() -> bool:
  return ( not multiplayer.multiplayer_peer is OfflineMultiplayerPeer) \
    and multiplayer.multiplayer_peer.get_connection_status()==MultiplayerPeer.CONNECTION_CONNECTED
