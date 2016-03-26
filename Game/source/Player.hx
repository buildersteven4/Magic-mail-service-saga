package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ...
 */
class Player extends FlxSprite
{
	public var speed:Float = 300;
	
	private static inline var ANIMATION_FRAME_RATE:Int = 15;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic("assets/images/player.png", true, 64, 64);
		
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		
		animation.add("lr", [17, 18, 19, 20, 21, 22, 23], ANIMATION_FRAME_RATE, false);
		animation.add("u", [8, 9, 10, 11, 12, 13, 14, 15], ANIMATION_FRAME_RATE, false);
		animation.add("d", [1, 2, 3, 4, 5, 6], ANIMATION_FRAME_RATE, false);
		animation.add("idle lr", [16]);
		animation.add("idle u", [7]);
		animation.add("idle d", [0]);
		
		width = 32;
		height = 32;
		offset = new FlxPoint(16, 42);
		
		FlxG.camera.follow(this, TOPDOWN_TIGHT, 1);
	}
	
	override public function update(elapsed:Float):Void
	{
		movement();
		
		var interactable:Interactable = findInteraction();
		
		if (interactable != null && FlxG.keys.justPressed.E) 
		{
			interactable.interact();
		}
		
		PlayState.hud.interactObject = interactable;
		
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
		
		if (controlSpeed != 0)
		{
			if (Math.abs(controlY) > Math.abs(controlX))
			{
				if (controlY < 0)
					facing = FlxObject.UP;
				else
					facing = FlxObject.DOWN;
			}
			else
			{
				if (controlX < 0)
					facing = FlxObject.LEFT;
				else
					facing = FlxObject.RIGHT;
			}
		}
		
		switch (facing) 
		{
			case FlxObject.LEFT, FlxObject.RIGHT:
				if (velocity.distanceTo(new FlxPoint()) < 100)
					animation.play("idle lr");
				else
					animation.play("lr");
					
			case FlxObject.UP:
				if  (velocity.distanceTo(new FlxPoint()) < 100)
					animation.play("idle u");
				else
					animation.play("u");
					
			case FlxObject.DOWN:
				if  (velocity.distanceTo(new FlxPoint()) < 100)
					animation.play("idle d");
				else
					animation.play("d");
		}
		
		velocity.x = FlxMath.lerp(velocity.x, controlX*speed, .2);
		velocity.y = FlxMath.lerp(velocity.y, controlY*speed, .2);
	}
	
	private function findInteraction():Interactable
	{
		var nearestDist:Float = 128;
		var nearestInteractable:Interactable = null;
		for (interactable in PlayState.level.interactableGroup) 
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