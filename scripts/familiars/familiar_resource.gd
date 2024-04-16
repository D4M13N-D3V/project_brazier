class_name FamiliarResource
extends Resource

@export var id: Enums.Familiar
@export var name: String
@export_multiline var description: String
@export var level: int
@export var health: int
@export var level_required: int
@export var familiar_type: Enums.FamiliarType
@export var sprite_resource: FamiliarSpriteResource
@export var required_items: Array[RecipieItemResource]
@export var available_actions: Array[Enums.ActionId]
@export var loot_table_id: Enums.Familiar
