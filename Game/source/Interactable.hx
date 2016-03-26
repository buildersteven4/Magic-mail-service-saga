package;

import flixel.FlxSprite;
import flixel.system.FlxAssets;
import flixel.system.FlxAssets.FlxGraphicAsset;
import hscript.Expr;
import hscript.Interp;
import hscript.Parser;
import openfl.Assets;

/**
 * ...
 * @author ...
 */
class Interactable extends FlxSprite
{
	public var interactName:String = "talk";
	public var interaction:Expr;
	
	
	public function new(?X:Float=0, ?Y:Float=0, interactionScriptAddress:String) 
	{
		super(X, Y);
		immovable = true;
		
		interaction = ScriptService.parse(Assets.getText(interactionScriptAddress));
	}
	
	public function interact()
	{
		ScriptService.execute(interaction);
	}
}