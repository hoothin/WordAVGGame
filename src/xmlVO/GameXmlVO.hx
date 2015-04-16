package xmlVO ;

/**
 * @time 2014/7/19 19:27:17
 * @author Hoothin
 */
class GameXmlVO {

	static var _gameXmlVO:GameXmlVO;
	public var blockMap(get, null):Map<String, GameBlock>;
	public function new() {
		this.blockMap = new Map();
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	static public function getInstance():GameXmlVO {
		if (_gameXmlVO == null) {
			_gameXmlVO = new GameXmlVO();
		}
		return _gameXmlVO;
	}
	
	public function analyzeXml(xmlData:Xml):Void {
		for (blockXml in xmlData.elements()) {
			var block:GameBlock = new GameBlock();
			block.analyzeXml(blockXml);
			if (this.blockMap.exists(block.index)) {
				trace("block " + block.index + " is repeat!");
			}
			this.blockMap.set(block.index, block);
		}
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	function get_blockMap():Map<String, GameBlock> {
		return blockMap;
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	
}