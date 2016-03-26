import Cocoa

class TreeListUtils {
    /**
     * Returns SelectTextButton or a TreeListItem from an xml
     * @Note this method is used in the onDataBaseAddAt method in the TreeList class
     */
    class func item(xml:NSXMLElement,parent:IElement,_ size:CGPoint)->NSView {
        var itemData:ItemData = Utils.itemData(xml)
        var item:NSView = Utils.treeItem(itemData, parent, size)
        if(itemData.hasChildren) {treeItems(xml,item as ITreeList,new Point(size.x, size.y)) as NSView}/*Utils.treeItems(xml) and add each DisplayObject in treeItems*/
        return item
    }
    /**
     * @Note: This method is recursive
     * @Note only use this method to add children to a new TreeList
     * @param size is the size of each treeItem
     * // :TODO: this should just return not modify?!? and be moved to TreeListParser
     */
    class func treeItems(xml:NSXMLElement, _ treeList:ITreeList, _ size:CGPoint) -> ITreeList {
        for var child in xml.children! {
            var itemData:ItemData = Utils.itemData(child)
            var treeItem:NSView = Utils.treeItem(itemData,treeList.itemContainer as IElement,size)
            if(itemData.hasChildren) treeItems(child,treeItem as ITreeList,size)// :TODO: move this line into treeitem?
            treeList.addItem(treeItem)
        }
        return treeList;
    }
}
private class Utils{
    /**
     * // :TODO: write java doc
     */
    class func treeItem(itemData:ItemData,_ parent:IElement,_ size:CGPoint) -> NSView {
        var item:NSView = itemData.hasChildren ? Utils.treeListItem(itemData, parent, size) : Utils.selectTextButton(itemData, parent, size)
        item.visible = itemData.isVisible// :TODO: should this be here and do we need isVisible?
        return item;
    }
    /**
     *
     */
    class func itemData(xml:NSXMLElement)->ItemData {
        var attributes:Dictionary<String,String> = XMLParser.attributes(xml)
        var hasChildren:Bool = attributes["hasChildren"] == "true" || xml.children().length() > 0
        var title:String = attributes["title"]!
        var isOpen:Bool = attributes["isOpen"] != nil ? attributes["isOpen"] == "true" : false//<- you can shorten this by doing ??
        var isSelected:Bool = attributes["isSelected"] != nil ? attributes["isSelected"] == "true" : false//<- you can shorten this by doing ??
        var isVisible:Bool = attributes["isVisible"] != nil ?  attributes["isVisible"] == "true" : true//<- you can shorten this by doing ??
        return ItemData(title, hasChildren, isOpen, isVisible,isSelected)
    }
}
class ItemData{
    private var title:String;
    private var hasChildren:Bool
    private var isOpen:Bool
    private var isVisible:Bool
    private var isSelected:Bool
    init(_ title:String, _ hasChildren:Bool, _ isOpen:Bool, _ isVisible:Bool , _ isSelected:Bool) {
        self.title = title
        self.hasChildren = hasChildren
        self.isOpen = isOpen
        self.isVisible = isVisible
        self.isSelected = isSelected
    }
}
