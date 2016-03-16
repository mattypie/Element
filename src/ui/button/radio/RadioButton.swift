import Foundation

class RadioButton:TextButton,ISelectable{// :TODO: impliment IDisableable also and extend DisableTextButton
    var radioBullet:RadioBullet?
    var isSelected:Bool
    init(_ width:CGFloat, _ height:CGFloat, _ text:String = "defaultText", _ isSelected:Bool = false, _ parent:IElement? = nil, _ id:String? = nil) {
        self.isSelected = isSelected
        super.init(text,width,height,parent,id)
    }
    /**
     * @Note:when added to stage and if RadioBullet dispatches selct event it will bubble up and through this class (so no need for extra eventlistners and dispatchers in this class)
     * @Note the _radioBullet has an id of "radioBullet" (this may be usefull if you extend CheckBoxButton and that subclass has children that are of type Button and you want to identify this button and noth the others)
     */
    override func resolveSkin() {
        super.resolveSkin();
        radioBullet = addSubView(RadioBullet(13,13,isSelected,self))
    }
    func setSelected(isSelected:Bool) {
        radioBullet!.setSelected(isSelected);
    }
    /**
     * @Note this method represents something that should be handled by a method named getSelected, but since this class impliments ISelectable it has to implment selected and selectable
     */
    func getSelected()->Bool {
        return radioBullet != nil ? radioBullet!.isSelected : isSelected;/*Temp fix*/
    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}