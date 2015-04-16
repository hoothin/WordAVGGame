package xmlVO;

/**
 * @time 2014/7/19 20:08:05
 * @author Hoothin
 */
class GameBlock {

	public var bg(get, null):String;
	public var index(get, null):String;
	public var nodeMap(get, null):Map<Int, Xml>;
	public var jump(get, null):String;
	public function new() {
		this.nodeMap = new Map();
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	public function analyzeXml(xmlData:Xml):Void {
		this.bg = xmlData.get("bg");
		this.index = xmlData.get("index");
		this.jump = xmlData.get("jump");
		var nodeIndex:Int = 0;
		for (node in xmlData.elements()) {
			this.nodeMap.set(nodeIndex, node);
			nodeIndex++;
		}
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	function get_bg():String {
		return bg;
	}
	
	function get_nodeMap():Map<Int, Xml> {
		return nodeMap;
	}
	
	function get_index():String {
		return index;
	}
	
	function get_jump():String {
		return jump;
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	
}