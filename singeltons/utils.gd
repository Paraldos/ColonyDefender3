extends Node

signal enemy_removed

enum Targets {
	PLAYER,
	ENEMY,
}

var player: Player
