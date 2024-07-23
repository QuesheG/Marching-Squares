class_name Point
extends Node2D

var draw_points: bool = false
var Position: Vector2
var Sprite: Sprite2D
var State: bool

func _init(text: CompressedTexture2D, pos: Vector2) -> void:
	Sprite = Sprite2D.new()
	Sprite.texture = text
	Position = pos
	Sprite.position = Position
	add_child(Sprite)
	State = randi_range(0, 1)

func _ready() -> void:
	if !State:
		Sprite.modulate = Color(0.2, 0.2, 0.2)
	if !draw_points:
		Sprite.modulate = Color(0,0,0,0)
