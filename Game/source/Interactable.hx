package;

import flixel.FlxSprite;
import flixel.system.FlxAssets;
import flixel.system.FlxAssets.FlxGraphicAsset;
import openfl.Assets;
import Xml;

/**
 * ...
 * @author ...
 */
class Interactable extends FlxSprite
{
	public var interactName:String = "talk";
	public var interactionScript:Xml;
	
	public function new(?X:Float=0, ?Y:Float=0, interactionScriptAddress:String) 
	{
		super(X, Y);
		
		interactionScript = Xml.parse(Assets.getText(interactionScriptAddress));
	}
	
	public function interact()
	{
		
	}
}