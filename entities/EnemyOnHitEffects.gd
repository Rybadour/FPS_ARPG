extends Node3D
class_name EnemyOnHitEffects

const DAMAGE_FADE_SPEED = 0.4;

@onready var audio: AudioStreamPlayer = $Audio;
@onready var damageNum: Label3D = $Damage;
@onready var onHitParticles: CPUParticles3D = $OnHitParticles;

var damageTween: Tween;
var accumDamage: float = 0;
		
func onTweenComplete():
	accumDamage = 0;

func onHit(damage: float, globalHitSpot: Vector3):
	audio.play();
	
	accumDamage += damage;
	damageNum.text = str(floor(accumDamage));
	damageNum.modulate = Color.RED;
	damageNum.outline_modulate = Color.BLACK;
	damageNum.scale = Vector3(1, 1, 1);
	
	if damageTween != null && damageTween.is_running():
		damageTween.kill();
	
	onHitParticles.global_position = globalHitSpot;
	onHitParticles.restart();
	
	damageTween = get_tree().create_tween();
	damageTween.set_parallel(true);
	damageTween.tween_property(damageNum, "modulate", Color(Color.RED, 0), DAMAGE_FADE_SPEED);
	damageTween.tween_property(damageNum, "outline_modulate", Color(Color.BLACK, 0), DAMAGE_FADE_SPEED);
	damageTween.tween_property(damageNum, "scale", Vector3(0.5, 0.5, 0.5), DAMAGE_FADE_SPEED);
	damageTween.connect("finished", onTweenComplete);
