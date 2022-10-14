extends KinematicBody2D

var tile_size = 8
var turn = false
var move_speed = 200

var l = 0
var r = 0
var u = 0
var down = 0



func _physics_process(delta):
	movement(delta)

func movement(delta):
	if l == 0 and r == 0 and down == 0 and u == 0:
		move_input()

	if turn == true:
#		if Input.is_action_just_pressed("move_down") == false and Input.is_action_just_pressed("move_left") == false and Input.is_action_just_pressed("move_right") == false and Input.is_action_just_pressed("move_up") == false:
#			if l == 0 and r == 0 and down == 0 and u == 0:
#				turn = false
		if l == 0 and r == 0 and down == 0 and u == 0:
			turn = false
	if l != 0:
		global_position.x -= move_speed * delta
		l -= move_speed
	if r != 0:
		global_position.x += move_speed * delta
		r -= move_speed
	if u != 0:
		global_position.y -= move_speed * delta
		u -= move_speed
	if down != 0:
		global_position.y += move_speed * delta
		down -= move_speed

	Clamp()
	pass

func move_input():
	if turn == false:
		if Input.is_action_pressed("move_up") and $U.is_colliding() == false and turn == false:
			u = tile_size
			turn = true
		if Input.is_action_pressed("move_down") and $D.is_colliding() == false and turn == false:
			down = tile_size
			turn = true
		if Input.is_action_pressed("move_left") and $R.is_colliding() == false and turn == false:
			l = tile_size
			turn = true
		if Input.is_action_pressed("move_right") and $L.is_colliding() == false and turn == false:
			r = tile_size
			turn = true

func Clamp():
	u = clamp(u, 0, tile_size)
	l = clamp(l, 0, tile_size)
	r = clamp(r, 0, tile_size)
	down = clamp(down, 0, tile_size)
