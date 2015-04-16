package com.utility;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import openfl.ui.Keyboard;

/**
 * @time 2013/11/1 11:38:08
 * @author Hoothin
 */
class ShortCutsKey{

	static var registedStateMap:Map < Int, Map < Int, Array<Dynamic> > > = new Map();
	
	static var _state:Int = 0;
	
	static var _isOpen:Bool = false;
	
	public static function addKeyEventListener(keyCode:Int, callBackFun:Int -> Void, state:Int = 0, withShift:Bool = false, withCtrl:Bool = false, withAlt:Bool = false):Void {
		if (!registedStateMap.exists(state)) registedStateMap.set(state, new Map());
		var registedKeyMap:Map < Int, Array<Dynamic> > = registedStateMap.get(state);
		if (registedKeyMap.exists(keyCode)) return;
		registedKeyMap.set(keyCode, [callBackFun, withShift, withCtrl, withAlt]);

		openListener();
	}
	
	public static function openListener():Void {
		if (!_isOpen) {
			Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, pressKeyHandler);
			_isOpen = true;
		}
	}
	
	public static function closeListener():Void {
		if (_isOpen) {
			Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, pressKeyHandler);
			_isOpen = false;
		}
	}
	
	private static function pressKeyHandler(e:KeyboardEvent):Void {
		var registedKeyMap:Map < Int, Array<Dynamic> > = registedStateMap.get(_state);
		if (registedKeyMap == null) return;
		for (key in registedKeyMap.keys()) {
			if (cast(e.keyCode, Int) == key) {
				if (registedKeyMap.get(key)[1] && !e.shiftKey 
				 || registedKeyMap.get(key)[2] && !e.ctrlKey
				 || registedKeyMap.get(key)[3] && !e.altKey)
					break;
				registedKeyMap.get(key)[0](key);
			}
		}
	}
	
	static function get_state():Int {
		return _state;
	}
	
	static function set_state(value:Int):Int {
		return _state = value;
	}
	
	static public var state(get_state, set_state):Int;

}