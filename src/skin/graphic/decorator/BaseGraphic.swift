import Cocoa
/*
* The BaseGraphic class is an Element DataObject class that holds the lineshape, lineStyle and fillStyle
* // :TODO: possibly get rid of the setters for the fillStyle and Line style and use implicit setFillStyle and setLineStyle?
* NOTE: We dont need a line mask, just subclass the Graphics class so it supports masking of the line aswell (will require some effort)
*/
class BaseGraphic :AbstractGraphicDecoratable,IBaseGraphic{
    lazy var graphics:Graphics = Graphics()
    override var graphic:IBaseGraphic {get{return self}set{}}
    var width:Double;
    var height:Double;
    var fillStyle:IFillStyle?
    var lineStyle:ILineStyle?
    var lineOffsetType:OffsetType?
    var path:CGMutablePath = CGPathCreateMutable()
    var linePath:CGMutablePath = CGPathCreateMutable()
    
    init(_ width:Double = 100, _ height:Double = 100,_ fillStyle:IFillStyle? = nil, _ lineStyle:ILineStyle? = nil, _ lineOffsetType:OffsetType? = nil) {
        self.width = width;
        self.height = height;
        self.fillStyle = fillStyle
        self.lineStyle = lineStyle
        self.lineOffsetType = lineOffsetType
    }
    /**
     * TODO: color cant be uint since uint cant be NaN, use Double, 
     * TODO:  check if cgfloat can be NaN?
     */
    override func beginFill(){
        if(fillStyle != nil && fillStyle!.color != NSColor.clearColor() ) {/*Updates only if fillStyle is of class FillStyle*/
            graphics.fill(fillStyle!.color)//Stylize the fill
        }
    }
    override func stylizeFill(){
        GraphicModifier.stylize(path,graphics)//realize style on the graphic
    }
    /**
     *
     */
    override func applyLineStyle() {
        if(lineStyle != nil) {/*updates only if lineStyle of class LineStyle*/
            graphics.line(lineStyle!.thickness, lineStyle!.color, lineStyle!.lineCap, lineStyle!.lineJoin, lineStyle!.miterLimit)
        }
    }
    override func stylizeLine(){
        GraphicModifier.stylize(linePath,graphics)//realize style on the graphic
    }
    func setPosition(position:CGPoint){
        CGPathModifier.translate(&path,position.x,position.y)//Transformations
    }
    func setSize(width:Double,height:Double) {
        self.width = width;
        self.height = height;
    }
    func setProperties(fillStyle:IFillStyle? = nil, lineStyle:ILineStyle? = nil){// :TODO: remove this and replace with setLineStyle and setFillStyle ?
        self.fillStyle = fillStyle;
        self.lineStyle = lineStyle;
    }
    override func getGraphic()->BaseGraphic{
        return self
    }
}
