package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
	public static var level:LevelMap;
	public static var player:Player;
	public static var hud:HUD;
	
	override public function create():Void
	{
		super.create();
		
		level = new LevelMap("assets/data/maps/test.tmx");
		player = new Player(10, 10);
		hud = new HUD();
		
		add(level.layerGroups);
		
		FlxG.camera.setScrollBoundsRect(level.bounds.x, level.bounds.y, level.bounds.width, level.bounds.height);
		FlxG.worldBounds.copyFrom(level.bounds);
		
		add(player);
		add(hud);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.collide(player, level.layerGroups);
	}
}
