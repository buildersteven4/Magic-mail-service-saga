import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTile;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.tile.FlxTilemapExt;
import flixel.addons.tile.FlxTileSpecial;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxRect;
import flixel.util.FlxSort;
import flixel.group.FlxGroup;
import haxe.io.Path;

/**
 * ...
 * @author MrCdK
 */
class LevelMap extends TiledMap
{
	public var layerGroups:FlxGroup;
	
	public var collisionGroup:FlxGroup;
	public var interactableGroup:FlxTypedGroup<Interactable>;
	
	public var bounds:FlxRect;

	private var tileset:TiledTileSet;
	private var animations:Dynamic;
	
	public function new(level:Dynamic) 
	{
		super(level);
		
		// background and foreground groups
		layerGroups = new FlxGroup();
		
		// events and collision groups
		interactableGroup = new FlxTypedGroup<Interactable>();
		collisionGroup = new FlxGroup();
		
		// The bound of the map for the camera
		bounds = FlxRect.get(0, 0, fullWidth, fullHeight);
		
		// Prepare tile set
		tileset = this.getTileSet("tileset");
		
		// Prepare the tile animations
		animations = TileAnims.getAnimations(tileset);
		
		for (layer in layers)
		{
			if (layer.type == TiledLayerType.TILE) 
				layerGroups.add(loadTileLayer(cast layer));
			else if (layer.type == TiledLayerType.OBJECT) 
			{
				layerGroups.add(loadObjectLayer(cast layer));
			}
		}
	}
	
	private function loadTileLayer(layer:TiledTileLayer):FlxTilemapExt
	{
		var tilemap:FlxTilemapExt = new FlxTilemapExt();
		tilemap.loadMapFromArray(
			layer.tileArray,
			layer.width,
			layer.height,
			"assets/images/tileset.png",
			tileset.tileWidth,
			tileset.tileHeight,
			OFF,
			tileset.firstGID
		);
		
		// Set tile properties
		for (i in 0...tileset.numTiles+1)
		{
			tilemap.setTileProperties(i, FlxObject.NONE);
		}
		tilemap.setTileProperties(31, FlxObject.ANY);
		tilemap.setTileProperties(32, FlxObject.ANY);
		tilemap.setTileProperties(33, FlxObject.ANY);
		tilemap.setTileProperties(34, FlxObject.ANY);
		tilemap.setTileProperties(35, FlxObject.ANY);
		tilemap.setTileProperties(38, FlxObject.DOWN);
		tilemap.setTileProperties(43, FlxObject.RIGHT);
		tilemap.setTileProperties(44, FlxObject.ANY);
		tilemap.setTileProperties(45, FlxObject.LEFT);
		tilemap.setTileProperties(50, FlxObject.UP);
		tilemap.setTileProperties(55, FlxObject.UP | FlxObject.LEFT);
		tilemap.setTileProperties(56, FlxObject.UP | FlxObject.RIGHT);
		tilemap.setTileProperties(61, FlxObject.DOWN | FlxObject.LEFT);
		tilemap.setTileProperties(62, FlxObject.DOWN | FlxObject.RIGHT);
		
		
		var specialTiles:Array<FlxTileSpecial> = new Array<FlxTileSpecial>();
		var tile:TiledTile;
		var animData;
		var specialTile:FlxTileSpecial;
		
		// For each tile in the layer
		for (i in 0...layer.tiles.length)
		{ 
			tile = layer.tiles[i];
			if (tile != null && isSpecialTile(tile))
			{
				specialTile = new FlxTileSpecial(tile.tilesetID, tile.isFlipHorizontally, tile.isFlipVertically, tile.rotate);
				// add animations if exists
				if (animations.exists(tile.tilesetID))
				{
					// Right now, a special tile only can have one animation.
					animData = animations.get(tile.tilesetID)[0];
					// add some speed randomization to the animation
					var randomize:Float = FlxG.random.float(-animData.randomizeSpeed, animData.randomizeSpeed);
					var speed:Float = animData.speed + randomize;
					
					specialTile.addAnimation(animData.frames, speed, animData.framesData);
				}
				specialTiles[i] = specialTile;
			}
			else
			{
				specialTiles[i] = null;
			}
		}
		// set the special tiles (flipped, rotated and/or animated tiles)
		tilemap.setSpecialTiles(specialTiles);
		// set the alpha of the layer
		tilemap.alpha = layer.opacity;
		
		return tilemap;
	}
	
	public function loadObjectLayer(layer:TiledObjectLayer):FlxGroup
	{
		var group:FlxGroup = new FlxGroup();
		
		for (obj in layer.objects)
		{
			var object:FlxObject = loadObject(obj, layer);
			if (object != null) 
			{
				group.add(object);
			}
		}
		
		return group;
	}
	
	private function loadObject(obj:TiledObject, layer:TiledObjectLayer):FlxObject
	{
		var x:Int = obj.x;
		var y:Int = obj.y;
		
		var tileSet:TiledTileSet = layer.map.getGidOwner(obj.gid);
		var imagePath:Path = new Path(tileSet.imageSource);
		var sprite:String = "assets/images/" + imagePath.file + "." + imagePath.ext;
		switch (obj.type.toLowerCase())
		{
			case "player":
				/*var player:Character = new Character(o.name, x, y, "images/chars/"+o.name+".json");
				player.setBoundsMap(bounds);
				player.controllable = true;
				FlxG.camera.follow(player);
				characterGroup.add(player);*/
				
			case "npc":
				var interactable:Interactable = new Interactable(x, y, "assets/data/interactions/"+obj.name+".hx");
				interactableGroup.add(interactable);
				
				interactable.loadGraphic(sprite, true, tileSet.tileWidth, tileSet.tileHeight);
				interactable.animation.frameIndex = tileSet.fromGid(obj.gid) - 1;
				
				return interactable;
				
			case "collision":
				var coll:FlxObject = new FlxObject(x, y, obj.width, obj.height);
				#if !FLX_NO_DEBUG
				coll.debugBoundingBoxColor = 0xFFFF00FF;
				#end
				coll.immovable = true;
				collisionGroup.add(coll);
		}
		
		return null;
	}
	
	public function update(elapsed:Float):Void
	{
		updateCollisions();
		updateEventsOrder();
	}
	
	public function updateEventsOrder():Void
	{
		interactableGroup.sort(FlxSort.byY);
	}
	
	public function updateCollisions():Void
	{
	}
	
	private inline function isSpecialTile(tile:TiledTile):Bool
	{
		return false;//(tile.isFlipHorizontally || tile.isFlipVertically || tile.rotate != FlxTileSpecial.ROTATE_0 || animations.exists(tile.tilesetID));
	}
}