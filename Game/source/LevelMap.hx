package;

import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledMap.FlxTiledAsset;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.editors.tiled.TiledObject;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import haxe.io.Path;

class LevelMap extends TiledMap
{
	private inline static var c_PATH_LEVEL_TILESHEETS = "assets/images/tilesets/";
	
	public var surfaceTiles:FlxGroup;	
	
	public function new(data:Dynamic) 
	{
		super(data);
		
		surfaceTiles = new FlxGroup();
		
		for (layer in layers)
		{
			if (layer.type == TiledLayerType.TILE)
			{
				var tileLayer:TiledTileLayer = cast layer;
			
				var tileSheetName:String = tileLayer.properties.get("Tileset");
				
				if (tileSheetName == null)
				throw "'Tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";
			
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
					throw "Tileset '" + tileSheetName + " not found. Did you misspell the 'Tilesheet' property in " + tileLayer.name + "' layer?";
					
				var imagePath 		= new Path(tileSet.imageSource);
				var processedPath 	= c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;
				
				var tilemap:FlxTilemap = new FlxTilemap();
				tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processedPath,
				tileSet.tileWidth, tileSet.tileHeight, OFF, tileSet.firstGID, 1, 1);
				surfaceTiles.add(tilemap);
			}
		}
	}
	
}