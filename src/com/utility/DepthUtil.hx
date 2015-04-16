package com.utility;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;

/**
 * @time 2013/10/30 10:26:54
 * @author Hoothin
 */
class DepthUtil{
	public static function bringToBottom(mc:DisplayObject):Void{
		var parent:DisplayObjectContainer = mc.parent;
		if (parent != null) {
			if(parent.getChildIndex(mc) != 0){
				parent.setChildIndex(mc, 0);
			}
		}
	}
	
	public static function bringToTop(mc:DisplayObject):Void{
		var parent:DisplayObjectContainer = mc.parent;
		if (parent != null) {
			var maxIndex:Int = parent.numChildren - 1;
			if (parent.getChildIndex(mc) != maxIndex) { 
				parent.setChildIndex(mc, maxIndex);
			}
		}
	}
	
	public static function isTop(mc:DisplayObject):Bool { 
		var parent:DisplayObjectContainer = mc.parent;
		if (parent != null) {
			return (parent.numChildren - 1) == parent.getChildIndex(mc);
		}
		return false;
	}
	
	public static function isBottom(mc:DisplayObject):Bool { 
		var parent:DisplayObjectContainer = mc.parent;
		if (parent != null) {
			return parent.getChildIndex(mc) == 0;
		}
		return false;
	}
	
	public static function isJustBelow(mc:DisplayObject, aboveMC:DisplayObject):Bool { 
		var parent:DisplayObjectContainer = mc.parent;
		if (parent != null) {
			if (aboveMC.parent != parent) {
				return false;
			}
			return parent.getChildIndex(mc) == parent.getChildIndex(aboveMC) - 1;
		}
		return false;
	}
	
	public static function isJustAbove(mc:DisplayObject, belowMC:DisplayObject):Bool{
		return isJustBelow(belowMC, mc);
	}

}