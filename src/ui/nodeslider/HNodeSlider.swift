import Cocoa
/**
 * HorizontalNodeSlider is used when 2 sliders are need, as in section definition or zoom, or gradient values
 */
class HNodeSlider:Element {
    var startNode:SelectButton?
    var endNode:SelectButton?
    var selectGroup:SelectGroup?
    var nodeWidth:CGFloat
    var tempNodeMouseX:CGFloat?
    var startProgress:CGFloat
    var endProgress:CGFloat
    var globalMouseMovedHandeler:AnyObject?
    init(_ width:CGFloat = NaN, _ height:CGFloat = NaN, _ nodeWidth:CGFloat = NaN, _ startProgress:CGFloat = 0, _ endProgress:CGFloat = 1, _ parent:IElement? = nil, _ id:String? = nil, _ classId:String? = nil) {
        self.startProgress = startProgress
        self.endProgress = endProgress
        self.nodeWidth = nodeWidth.isNaN ? height:nodeWidth
        super.init(width, height, parent, id)
    }
    override func resolveSkin() {
        super.resolveSkin();
        startNode = addSubView(SelectButton(nodeWidth, height, false, self, "start"))
        setStartProgressValue(startProgress)
        endNode = addSubView(SelectButton(nodeWidth, height, false, self, "end"))
        setEndProgressValue(endProgress)
        selectGroup = SelectGroup([startNode!,endNode!],startNode!)
    }
    func onStartNodeDown(event:ButtonEvent) {
//		DepthModifier.toFront(_startNode, this);
        tempNodeMouseX = startNode!.localPos().x
        globalMouseMovedHandeler = NSEvent.addLocalMonitorForEventsMatchingMask([.LeftMouseDraggedMask], handler:onStartNodeMove)//we add a global mouse move event listener
    }
    func onEndNodeDown(event:ButtonEvent) {
//		DepthModifier.toFront(_endNode, this);
        tempNodeMouseX = endNode!.localPos().x
        globalMouseMovedHandeler = NSEvent.addLocalMonitorForEventsMatchingMask([.LeftMouseDraggedMask], handler:onEndNodeMove)//we add a global mouse move event listener
    }
    func onStartNodeMove(event:NSEvent)-> NSEvent? {
        startProgress = Utils.progress(event.localPos(self).x, tempNodeMouseX!, width, nodeWidth)
        startNode!.x = Utils.nodePosition(startProgress, width, nodeWidth)
        super.onEvent(NodeSliderEvent(NodeSliderEvent.change,startProgress,endProgress,self))
        return event
    }
    func onEndNodeMove(event:NSEvent)-> NSEvent?  {
        endProgress = Utils.progress(event.localPos(self).x, tempNodeMouseX!, width, nodeWidth)
        endNode!.x = Utils.nodePosition(endProgress, width, nodeWidth)
        super.onEvent(NodeSliderEvent(NodeSliderEvent.change,startProgress,endProgress,self))
        return event
    }
    func onStartNodeUp(event : MouseEvent)  {
        //remove move event here
    }
    func onEndNodeUp(event : MouseEvent)  {
        //remove move event here
    }
    /**
     * @param progress (0-1)
     */
    func setStartProgressValue(progress:CGFloat){
        startProgress = progress
        startNode!.x = Utils.nodePosition(progress, width, nodeWidth)
    }
    func setEndProgressValue(progress:CGFloat){
        endProgress = progress
        endNode!.x = Utils.nodePosition(progress, width, nodeWidth)
    }
    override func setSize(width : CGFloat, _ height : CGFloat)  {
        super.setSize(width, height)
        setEndProgressValue(endProgress)
        setStartProgressValue(startProgress)
        startNode!.setSize(startNode!.width, height)
        endNode!.setSize(startNode!.width, height)
    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
private class Utils{
	/**
	 * Return the x position of a nodes @param progress
	 */
	static func nodePosition(progress:CGFloat, _ width:CGFloat, _ nodeWidth:CGFloat)->CGFloat {
		let minThumbPos:CGFloat = width - nodeWidth;/*Minimum thumb position*/
		return progress * minThumbPos;
	}
	/**
	 * Returns the progress derived from a node 
	 * @return a number between 0 and 1
	 */
	static func progress(mouseX:CGFloat,_ tempNodeMouseX:CGFloat,_ width:CGFloat,_ nodeWidth:CGFloat)->CGFloat {
		let progress:CGFloat = (mouseX-tempNodeMouseX) / (width-nodeWidth);
		return max(0,min(progress,1))/*Ensures that progress is between 0 and 1 and if its beyond 0 or 1 then it is 0 or 1*/
	}
}