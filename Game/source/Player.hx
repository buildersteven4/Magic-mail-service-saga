package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ...
 */
class Player extends FlxSprite
{
	public var speed:Float = 400;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		makeGraphic(16, 16, FlxColor.BLUE);
		
		FlxG.camera.follow(this, TOPDOWN_TIGHT, 1);
	}
	
	override public function update(elapsed:Float):Void
	{
		movement();
		
		var interactable:Interactable = findInteraction();
		
		super.update(elapsed);
	}
	
	private function movement():Void
	{
		var controlX:Float = 0;
		var controlY:Float = 0;
		
		controlY += FlxG.keys.anyPressed([UP, W]) ? 0 : 1;
		controlY -= FlxG.keys.anyPressed([DOWN, S]) ? 0 : 1;
		controlX += FlxG.keys.anyPressed([LEFT, A]) ? 0 : 1;
		controlX -= FlxG.keys.anyPressed([RIGHT, D]) ? 0 : 1;
		
		var controlSpeed:Float = FlxMath.vectorLength(controlX, controlY);
		if (controlSpeed > 1) 
		{
			controlX /= controlSpeed;
			controlY /= controlSpeed;
		}
		
		velocity.x = FlxMath.lerp(velocity.x, controlX*speed, .2);
		velocity.y = FlxMath.lerp(velocity.y, controlY*speed, .2);
	}
	
	private function findInteraction():Interactable
	{
		var nearestDist:Float = 128;
		var nearestInteractable:Interactable = null;
		for (interactable in PlayState.level.interactables.iterator()) 
		{
			var dist:Float = getMidpoint().distanceTo(interactable.getMidpoint());
			if (dist < nearestDist) 
			{
				nearestDist = dist;
				nearestInteractable = interactable;
			}
		}
		
		return nearestInteractable;
	}
}