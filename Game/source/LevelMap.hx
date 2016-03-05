package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledMap.FlxTiledAsset;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.editors.tiled.TiledObject;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.system.FlxAssets.FlxGraphicAsset;
import haxe.io.Path;

class LevelMap extends TiledMap
{
	private inline static var c_PATH_LEVEL_TILESHEETS = "assets/images/";
	private inline static var c_PATH_INTERACTION_SCRIPTS = "assets/data/interactions/";
	
	public var surfaceTiles:FlxGroup;
	public var waterTiles:FlxGroup;
	public var objects:FlxGroup;
	public var interactables:FlxTypedGroup<Interactable>;
	
	public function new(data:String)
	{
		super(data);
		
		surfaceTiles = new FlxGroup();
		waterTiles = new FlxGroup();
		objects = new FlxGroup();
		interactables = new FlxTypedGroup<Interactable>();
		
		FlxG.camera.setScrollBoundsRect(0, 0, fullWidth, fullHeight, true);
		
		for (layer in layers)
		{
			if (layer.type == TiledLayerType.TILE)
			{
				loadTiles(cast layer);
			}
			else if (layer.type == TiledLayerType.OBJECT) 
			{
				loadObjects(cast layer);
			}
		}
	}
	public function loadTiles(layer:TiledTileLayer)
	{
		var tileSheetName:String = layer.properties.get("Tileset");
		
		if (tileSheetName == null)
		throw "'Tileset' property not defined for the '" + layer.name + "' layer. Please add the property to the layer.";
		
		var tileSet:TiledTileSet = null;
		for (ts in tilesets)
		{
			if (ts.name == tileSheetName)
			{
				tileSet = ts;
				break;
			}
		}
		
		if (tileSet == null)
			throw "Tileset '" + tileSheetName + " not found. Did you misspell the 'Tilesheet' property in " + layer.name + "' layer?";
			
		var imagePath = new Path(tileSet.imageSource);
		var processedPath = c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;
		
		var tilemap:FlxTilemap = new FlxTilemap();
		tilemap.loadMapFromArray(layer.tileArray, width, height, processedPath,
		tileSet.tileWidth, tileSet.tileHeight, OFF, tileSet.firstGID, 1, 1);
		
		if (layer.name == "Surface")
		{
			surfaceTiles.add(tilemap);
		}
		else if (layer.name == "Water") 
		{
			waterTiles.add(tilemap);
		}
	}
	public function loadObjects(layer:TiledObjectLayer)
	{
		for (object in layer.objects)
		{
			var x:Int = object.x;
			var y:Int = object.y;
			
			var tileSet:TiledTileSet = layer.map.getGidOwner(object.gid);
			var imagePath:Path = new Path(tileSet.imageSource);
			var sprite:FlxGraphicAsset = c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;
			
			// objects in tiled are aligned bottom-left (top-left in flixel)
			if (object.gid != -1)
				y -= tileSet.tileHeight;
			
			var instance:FlxSprite;
			if (object.name == "")
			{
				instance = new FlxSprite(x, y);
			}
			else 
			{
				instance = new Interactable(x, y, c_PATH_INTERACTION_SCRIPTS + object.name + ".xml");
				interactables.add(cast instance);
			}
			
			instance.loadGraphic(sprite, true, tileSet.tileWidth, tileSet.tileHeight);
			instance.animation.frameIndex = tileSet.fromGid(object.gid) - 1;
			
			objects.add(instance);
		}
	}
}