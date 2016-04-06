import Cocoa

class GradientPanel:Element{
    var gradientSlider:GradientSlider?
    var colorInput:ColorInput?
    var alphaSpinner:LeverSpinner?
    var ratioSpinner:LeverSpinner?
    var itemHeight:CGFloat
    var gradient:IGradient
    var gradientTypeSelectGroup:SelectGroup?
    var focalPointRatioSpinner:LeverSpinner?
    init(_ width:CGFloat = NaN, _ height:CGFloat = NaN, _ itemHeight:CGFloat = NaN, _ gradient:IGradient? = nil, _ parent:IElement? = nil, _ id:String = "") {
        self.itemHeight = itemHeight
        self.gradient = gradient!
        super.init(width, height, parent, id)
    }
    override func resolveSkin() {
        super.resolveSkin()
        let linearRadioButton = addSubView(RadioButton(NaN,NaN,"Linear",true,self))
        let radialRadioButton = addSubView(RadioButton(NaN,NaN,"Radial",false,self))
        gradientTypeSelectGroup = SelectGroup([linearRadioButton,radialRadioButton],linearRadioButton)
        gradientSlider = addSubView(GradientSlider(width,12/*<--this should be NaN*/,20/*<--this should be NaN*/,gradient,0,1,self))
        let cgColor:CGColor = gradientSlider!.gradient!.colors[0]
        let nsColor:NSColor = NSColorParser.nsColor(cgColor)
        colorInput = addSubView(ColorInput(width,NaN,"Color:",nsColor,self))
        alphaSpinner = addSubView(LeverSpinner(width, NaN,"Alpha:",1,0.01,0,1,2,1,200,self))
        ratioSpinner = addSubView(LeverSpinner(width, NaN,"Ratio:",1,1,0,255,1,100,200,self))
        focalPointRatioSpinner = addSubView(LeverSpinner(width, NaN,"Focal point:",0,0.01,-1,1,2,100,200,self))
    }
    private func onGradientSliderChange(event : NodeSliderEvent) {
        let isStartNodeSelected:Bool = event.selected === gradientSlider!.startNode
        let ratio:CGFloat = isStartNodeSelected ? event.startProgress : event.endProgress
        //Swift.print("ratio: " + ratio);
        ratioSpinner!.setValue(round(ratio * 255))
    }
    private func onGradientSliderSelectGroupChange(event : SelectGroupEvent) {
        
        var index:UInt = event.selectable == gradientSlider.startNode ? 0 : 1
        Swift.print("index: " + index);
        Swift.print("_gradientSlider.gradient.colors: " + gradientSlider.gradient.colors);
        var color:uint = gradientSlider.gradient.colors[index]
        colorInput.setColor(color)
        ColorSync.receiver = colorInput
        ColorSync.setColor(color)
        alphaSpinner.setValue(gradientSlider.gradient.alphas[index])
        ratioSpinner.setValue(gradientSlider.gradient.ratios[index])
    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}