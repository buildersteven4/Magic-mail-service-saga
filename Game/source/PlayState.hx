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
	
	override public function create():Void
	{
		super.create();
		
		level = new LevelMap("assets/maps/test1.tmx");
		
		add(level.surfaceTiles);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
