package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		ScriptService.init();
		addChild(new FlxGame(640, 480, PlayState));
	}
}