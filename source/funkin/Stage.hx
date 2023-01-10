package funkin;

import base.ScriptHandler;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import haxe.ds.StringMap;
import states.PlayState;

// We allow null values here so we can adjust properly
typedef CharPosition = {
	var x:Null<Float>;
	var y:Null<Float>;
}

class Stage extends FlxTypedGroup<FlxBasic>
{
	public var defaultCamZoom(never, set):Float;
	public var addGirlfriend:Bool = true;

	function set_defaultCamZoom(value:Float):Float
	{
		PlayState.defaultCamZoom = value;
		return value;
	}

	public var stageModule:ForeverModule;
	public var foreground:FlxTypedGroup<FlxBasic>;
	public var layers:FlxTypedGroup<FlxBasic>;
	public var charPos:StringMap<CharPosition>;

	public function new(stage:String, ?camPos:FlxPoint)
	{
		super();

		foreground = new FlxTypedGroup<FlxBasic>();
		layers = new FlxTypedGroup<FlxBasic>();
		charPos = new StringMap<CharPosition>();

		charPos.set('dad', {x: null, y: null});
		charPos.set('boyfriend', {x: null, y: null});

		var exposure:StringMap<Dynamic> = new StringMap<Dynamic>();
		exposure.set('add', add);
		exposure.set('stage', this);
		exposure.set('foreground', foreground);
		if (camPos != null)
			exposure.set('camPos', camPos);
		stageModule = ScriptHandler.loadModule('$stage', 'stages/$stage', exposure);
		if (stageModule.exists("onCreate"))
			stageModule.get("onCreate")();
		trace('$stage loaded successfully');
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (stageModule.exists("onUpdate"))
			stageModule.get("onUpdate")(elapsed);
	}

	public function onStep(curStep:Int)
	{
		if (stageModule.exists("onStep"))
			stageModule.get("onStep")(curStep);
	}

	public function onBeat(curBeat:Int)
	{
		if (stageModule.exists("onBeat"))
			stageModule.get("onBeat")(curBeat);
	}

	public function dispatchEvent(myEvent:String)
	{
		if (stageModule.exists("onEvent"))
			stageModule.get("onEvent")(myEvent);
	}
}
