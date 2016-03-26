package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouse;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class HUD extends FlxSpriteGroup
{
	public var notebookSprite:FlxSprite;
	public var notebookText:FlxText;
	public var paperSprite:FlxSprite;
	public var jigsawSprite:FlxSprite;
	public var clockSprite:FlxSprite;
	public var interactHint:FlxText;
	public var chatBubble:FlxSprite;
	public var chatText:FlxText;
	public var chatImage:FlxSprite;
	
	public var interactObject:Interactable;
	
	private var notebookPos:FlxPoint = new FlxPoint(notebookPointIn.x, notebookPointIn.y);
	private var paperPos:FlxPoint = new FlxPoint(paperPointIn.x, paperPointIn.y);
	private var jigsawPos:FlxPoint = new FlxPoint(jigsawPointIn.x, jigsawPointIn.y);
	
	private static var notebookPointOut:FlxPoint = new FlxPoint(-150, -180);
	private static var notebookPointIn:FlxPoint = new FlxPoint(-30, -180);
	private static var paperPointOut:FlxPoint = new FlxPoint(-300, -80);
	private static var paperPointIn:FlxPoint = new FlxPoint(-300, -20);
	private static var jigsawPointOut:FlxPoint = new FlxPoint(20, -100);
	private static var jigsawPointIn:FlxPoint = new FlxPoint(10, -20);
	
	private static inline var foldSpeed:Float = .15;
	private static inline var unfoldSpeed:Float = .3;
	
	public function new() 
	{
		super();
		
		paperSprite = new FlxSprite();
		paperSprite.makeGraphic(300, 80);
		
		notebookSprite = new FlxSprite();
		notebookSprite.loadGraphic("assets/images/ui/notebook.png");
		
		notebookText = new FlxText(0, 0, notebookSprite.width - 20, "- Get laid\n- Eat waffles\n- Do stuff\n  - think of stuff\n  - do that stuff");
		notebookText.setFormat("assets/fonts/handwritten.ttf", 11, FlxColor.BLACK, LEFT);
		
		jigsawSprite = new FlxSprite();
		jigsawSprite.makeGraphic(140, 140, 0xFFFF4040);
		
		interactHint = new FlxText();
		interactHint.setFormat("assets/fonts/basic.ttf", 12, 0xFFFFFFFF, RIGHT, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		
		chatBubble = new FlxSprite(100, 100);
		
		add(interactHint);
		add(jigsawSprite);
		add(paperSprite);
		add(notebookSprite);
		add(notebookText);
		
		updatePositions();
		
		for (sprite in iterator()) 
		{
			if (sprite != interactHint) 
			{
				sprite.scrollFactor.set(0, 0);
			}
		}
		
		FlxG.watch.add(this, "interactObject");
	}
	
	override public function update(elapsed:Float):Void
	{
		var hoverNotebook:Bool = notebookSprite.pixelsOverlapPoint(FlxG.mouse.getWorldPosition());
		var hoverPaper:Bool = paperSprite.pixelsOverlapPoint(FlxG.mouse.getWorldPosition());
		var hoverJigsaw:Bool = jigsawSprite.pixelsOverlapPoint(FlxG.mouse.getWorldPosition());
		
		if (hoverNotebook || hoverJigsaw)
		{
			notebookPos.x = FlxMath.lerp(notebookPos.x, notebookPointOut.x, unfoldSpeed);
			notebookPos.y = FlxMath.lerp(notebookPos.y, notebookPointOut.y, unfoldSpeed);
		}
		else 
		{
			notebookPos.x = FlxMath.lerp(notebookPos.x, notebookPointIn.x, foldSpeed);
			notebookPos.y = FlxMath.lerp(notebookPos.y, notebookPointIn.y, foldSpeed);
		}
		
		if (hoverPaper) 
		{
			paperPos.x = FlxMath.lerp(paperPos.x, paperPointOut.x, unfoldSpeed);
			paperPos.y = FlxMath.lerp(paperPos.y, paperPointOut.y, unfoldSpeed);
		}
		else 
		{
			paperPos.x = FlxMath.lerp(paperPos.x, paperPointIn.x, foldSpeed);
			paperPos.y = FlxMath.lerp(paperPos.y, paperPointIn.y, foldSpeed);
		}
		
		if (hoverJigsaw && !hoverNotebook) 
		{
			jigsawPos.x = FlxMath.lerp(jigsawPos.x, jigsawPointOut.x, unfoldSpeed);
			jigsawPos.y = FlxMath.lerp(jigsawPos.y, jigsawPointOut.y, unfoldSpeed);
		}
		else 
		{
			jigsawPos.x = FlxMath.lerp(jigsawPos.x, jigsawPointIn.x, foldSpeed);
			jigsawPos.y = FlxMath.lerp(jigsawPos.y, jigsawPointIn.y, foldSpeed);
		}
		
		updatePositions();
		
		if (interactObject != null) 
		{
			interactHint.visible = true;
			interactHint.setPosition(interactObject.x, interactObject.y);
			interactHint.text = "[E]: "+interactObject.interactName;
		}
		else 
		{
			interactHint.visible = false;
		}
	}
	
	private function updatePositions():Void
	{
		notebookSprite.setPosition(FlxG.width + notebookPos.x, FlxG.height + notebookPos.y);
		notebookText.setPosition(notebookSprite.x + 10, notebookSprite.y + 10);
		paperSprite.setPosition(notebookSprite.x + paperPos.x, FlxG.height + paperPos.y);
		jigsawSprite.setPosition(notebookSprite.x + jigsawPos.x, notebookSprite.y + jigsawPos.y);
	}
}