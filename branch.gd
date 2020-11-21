extends RigidBody2D
# branch script
# wind needs to be in a standalone node and sampled from there

var noise = OpenSimplexNoise.new()

var ntime := 500.0

var wind_amp := 25.0

var n := 0.0

func _ready():
	# wind noise
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 1000.0
	noise.persistence = 0.8

func _draw():
	draw_line(Vector2(0.0, 0.0), Vector2(n * 2, 0.0).rotated( - self.global_rotation),\
		Color(1.0, 1.0, 1.0, 0.1),\
		20,\
		true)

func _physics_process(_delta):
	
	# apply wind
	var npos : Vector2 = self.global_position
	n = noise.get_noise_3d(npos.x, npos.y, ntime)
	n = wind_amp * n#(n * 2.0 - 1.0)
	applied_force = Vector2(n ,0.0)

func _process(delta):
	ntime += (delta * 400.0)
	update()
