package mini;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import flash.events.MouseEvent;

class Engine extends Sprite
{
	
	
	public function new(width:Int, height:Int)
	{
		super();

		// calculating scale amount
		MN.width = width;
		MN.height = height;
		MN.boundaries = new flash.geom.Rectangle(0,0,MN.width, MN.height);

		MN.renderMode = RenderMode.Buffer;

		init();

	}

	private function init():Void
	{
		MN.stage = Lib.current.stage;
		MN.stage.addChild(this);

		MN.engine = this;

		MN.screen = new Screen();

		if (MN.scene == null)
			MN.scene = new Scene();

		
	#if flash
		MN.stage.scaleMode = flash.display.StageScaleMode.EXACT_FIT;
	#else
		MN.stage.scaleMode = flash.display.StageScaleMode.NO_BORDER;
	#end
		MN.stage.addEventListener(Event.RESIZE, function (e:Event) {
			resize();
		});
		MN.stage.addEventListener(Event.ACTIVATE, function (e:Event) {
			MN.focus = true;
			focus();
		});
		MN.stage.addEventListener(Event.DEACTIVATE, function (e:Event) {
			MN.focus = false;
			unfocus();
		});

		//MN.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		Input.enable();

		addEventListener (Event.ENTER_FRAME, onEnterFrame);
		MN.getElapsed();

		MN.scene.begin();
	}

	private function onEnterFrame(e:Event):Void
	{
		
		// if not paused
		if (!_paused)
		{	
			update();
			render();
		}

		// update input, even when paused
		Input.update();
	}

	/*
	*	override this
	*
	*/
	private function onMouseDown(e:MouseEvent)
	{
		// pass on to the scene object
		// no camera yet
		MN.scene.onMouseDown(e.localX, e.localY);


	}

	private function update():Void
	{
		// refresh input stashes
		Input.update();

		// get time between frames
		var dt:Float = MN.getElapsed();

		// update Scene
		MN.scene.update(dt);

	}

	private function render():Void
	{
		// resize?

		if (MN.renderMode == RenderMode.Buffer)
		{
			// swap to invisible buffer
			MN.screen.swap();
			// clear data with background color
			MN.screen.refresh();
		}

		// loop through all entities in current scene
		// -> draw each on the current buffer MN.buffer
		MN.scene.render();

		// set buffer to visible
		MN.screen.redraw();
	}

	private function resize()
	{

	}

	private function focus()
	{

	}

	private function unfocus()
	{

	}

	private var _paused:Bool = false;
}
