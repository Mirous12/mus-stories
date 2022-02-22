extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	print("FUCK");
	var scene1 = self.get_parent();
	var global = scene1.get_parent();
	var scene2 = global.get_node("GameNode");
	
	scene1.visible = false;
	scene2.visible = true;
	scene2.onStart();
