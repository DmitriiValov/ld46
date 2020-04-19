extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "texexport var cameraScale = 0.6
export var currentLevel = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	var anim = "idle"
	($Anim as AnimationPlayer).play(anim)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
