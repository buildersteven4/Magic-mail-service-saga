package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
	public var level:LevelMap;
	public var player:Player;
	
	override public function create():Void
	{
		super.create();
		
		level = new LevelMap("assets/data/maps/test1.tmx");
		player = new Player(10, 10);
		
		add(level.surfaceTiles);
		add(level.waterTiles);
		add(player);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.collide(player, level.waterTiles);
	}
}
