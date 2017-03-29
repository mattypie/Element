import Cocoa
@testable import Utils
/**
 * New
 */
class ScrollFastList:FastList,ScrollableFast {
    /**
     * NOTE: Basically when you perform a scroll-gesture on the touch-pad
     */
    /**
     * When the the user scrolls
     * NOTE: this method overides the Native NSView scrollWheel method
     */
    override func scrollWheel(with event:NSEvent) {
        scroll(event)
        //TODO: ⚠️️ you want to do super.scrollWhe...here, as NSView may need it up hirarchy etc
    }
}
