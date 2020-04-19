extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "texexport var cameraScale = 0.6
export var currentLevel = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	var anim = "fire"
	($Anim as AnimationPlayer).play(anim)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Fire_body_entered(body):	
	if(body.get_name() == "Player"):
		print(str('Body entered: ', body.get_name()))
		if(currentLevel == 0):
			get_tree().change_scene("res://GameScene.tscn")
		if(currentLevel == 1):
			get_tree().change_scene("res://GameComplete.tscn")
		if(currentLevel == 2):
			get_tree().change_scene("res://MenuScene.tscn")
