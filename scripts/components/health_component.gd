class_name HealthComponent

signal died

signal changed(health: int)

signal healed(health: int)

signal healed_fully

signal damaged(amount: int)

@export_range(1, 1000) var max_health: int = 100

var current_health := max_health:
	set(health_):
		current_health = clamp(health_, 0, max_health)


## Apply an amount of healing.
func heal(amount: int) -> void:
	if is_dead():
		return

	var old_heath := current_health

	current_health += amount

	healed.emit(current_health - old_heath)
	changed.emit(current_health)

	if is_maxed():
		healed_fully.emit()


## Apply a full amount of healing.
func heal_fully() -> void:
	heal(max_health)


## Apply an amount of damage.
func damage(amount: int) -> void:
	var old_heath := current_health

	current_health -= amount

	damaged.emit(old_heath - current_health)
	changed.emit(current_health)

	if is_dead():
		died.emit()


## Return whether the health should be considered "dead".
func is_dead() -> bool:
	return not is_alive()


## Return whether the health should be considered "alive".
func is_alive() -> bool:
	return current_health > 0.0


## Return whether the health is maxed out.
func is_maxed() -> bool:
	return current_health >= max_health
