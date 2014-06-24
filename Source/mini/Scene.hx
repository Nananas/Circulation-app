package mini;

import flash.geom.Point;
import mini.Entity;

class Scene
{
	public var mousePosition:Point;


	private var _list:Array<Entity>;


	public function new()
	{
		_list = new Array<Entity>();
		mousePosition = new Point(MN.width/2, MN.height/2);	
	}

	public function begin(){}

	public function render():Void
	{		
		// loop through all entities and do render()
		for (e in _list) {
			e.render();
		}
		
	}

	public function update(dt:Float):Void
	{
		// loop through all entities and do update() and such
		for (e in _list) {
			if (e.active) e.update(dt);
		}
	}

	/* returns the lenght of the new array
	*/
	public function add(e:Entity):Int
	{
		// add to list
		return _list.push(e);
	}

	public function addImage(i:Image, X:Int = 0, Y:Int = 0):Entity
	{
		var e:Entity = new Entity(X,Y,i);
		add(e);
		return e;
	}
	/* 
	* 	override this function
	*/
	public function onMouseDown(lx:Float, ly:Float)
	{
		// update mouse position
		mousePosition.x = lx;
		mousePosition.y = ly;

		// check for overlapping entities with mouse flag
		for (e in _list) {
			if (e.allowMouseOverlap && e.active)
			{
				if (MN.overlapPoint(e, mousePosition))
				{
					e.mouseDown(lx,ly);
				}
				
			}
		}
	}

	public function onMouseUp(lx:Float, ly:Float)
	{
		for (e in _list)
		{
			if (e.allowMouseOverlap && e.active)
			{
				e.mouseUp(lx, ly);
			}
		}
	}

}