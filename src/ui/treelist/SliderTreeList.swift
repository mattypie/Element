import Foundation
/**
 * @Note you must supply the itemHeight, since we need it to calculate the interval
 */
class SliderTreeList:TreeList{
    var sliderInterval:CGFloat?
    var slider:VSlider?
    override func resolveSkin() {
        super.resolveSkin()
        let itemsHeight:CGFloat = TreeListParser.itemsHeight(self)
        sliderInterval = SliderParser.interval(itemsHeight, getHeight(), itemHeight)//Math.floor(itemsHeight - getHeight())/itemHeight;// :TODO: use ScrollBarUtils.interval instead?
        slider = addSubView(VSlider(itemHeight,getHeight(),itemHeight,0,self))
        let thumbHeight:CGFloat = SliderParser.thumbSize(getHeight()/itemsHeight, slider!.getHeight())
        slider!.setThumbHeightValue(thumbHeight)
        //slider!.hidden = !SliderParser.assertSliderVisibility(thumbHeight/slider!.getHeight())
    }
    /**
     * Updates the thumb position and the position of the itemsContainer
     */
    func update(){
        Swift.print("SliderTreeList.update()");
        var itemsHeight:CGFloat = TreeListParser.itemsHeight(self)/*total height of the items*/
        /*
        Swift.print("itemsHeight: " + itemsHeight);
        Swift.print("itemHeight: " + itemHeight);
        Swift.print("getHeight(): " +  getHeight());
        */
        sliderInterval = SliderParser.interval(itemsHeight, getHeight(), itemHeight)
        //			Swift.print("update() _sliderInterval: " + _sliderInterval);
        var thumbHeight:CGFloat = SliderParser.thumbSize(getHeight()/itemsHeight, slider.getHeight())
        slider.setThumbHeightValue(thumbHeight:)(thumbHeight)
        var progress:CGFloat = SliderParser.progress(itemContainer.y, getHeight(), itemsHeight)
        slider.setProgress(progress)
        //slider.hidden = !SliderParser.assertSliderVisibility(_slider.thumb.getHeight()/slider.getHeight())
        TreeListModifier.scrollTo(self, progress)
    }
}