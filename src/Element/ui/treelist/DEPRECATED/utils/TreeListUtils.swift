import Cocoa
@testable import Utils

typealias ItemData = (title:String,hasChildren:Bool,isOpen:Bool,isVisible:Bool,isSelected:Bool)

class TreeListUtils {
    /**
     * Returns SelectTextButton or a TreeListItem from an xml
     * NOTE: this method is used in the onDataBaseAddAt method in the TreeList class
     */
    static func item(_ xml:XML,_ parent:IElement,_ size:CGPoint)->NSView {
        let itemData:ItemData = TreeListUtils.itemData(xml)
        let item:NSView = Utils.treeItem(itemData, parent, size)
        if(itemData.hasChildren) {_ = treeItems(xml,item as! ITreeList,CGPoint(size.x, size.y)) as! NSView}/*Utils.treeItems(xml) and add each DisplayObject in treeItems*/
        return item
    }
    /**
     * NOTE: This method is recursive
     * NOTE: only use this method to add children to a new TreeList
     * PARAM: size is the size of each treeItem
     * TODO: this should just return not modify?!? and be moved to TreeListParser
     */
    static func treeItems(_ xml:XML, _ treeList:ITreeList, _ size:CGPoint) -> ITreeList {//TODO:use CGSize
        xml.children?.forEach {
            let child:XML = $0 as! XML
            let itemData:ItemData = TreeListUtils.itemData(child)
            let treeItem:Element = Utils.treeItem(itemData,treeList.itemContainer as! IElement,size)
            if(itemData.hasChildren) {
                _ = TreeListUtils.treeItems(child, treeItem as! ITreeList,size)
            }// :TODO: move this line into treeitem?
            treeList.addItem(treeItem)/*Adds the item to the treeList*/
        }
        return treeList
    }
    /**
     * Creates a data instance to make it easier to work with the attributes in the xml
     */
    static func itemData(_ xml:XML)->ItemData {
        var attributes:Dictionary<String,String> = XMLParser.attribs(xml)
        let hasChildren:Bool = (attributes["hasChildren"] != nil && attributes["hasChildren"]! == "true") || (xml.children != nil && xml.children!.count > 0)//swift 3 update, simplify this line please
        let title:String = attributes["title"]!
        let isOpen:Bool = attributes["isOpen"] != nil ? attributes["isOpen"] == "true" : false//<- you can shorten this by doing ??
        let isSelected:Bool = attributes["isSelected"] != nil ? attributes["isSelected"] == "true" : false//<- you can shorten this by doing ??
        let isVisible:Bool = attributes["isVisible"] != nil ?  attributes["isVisible"] == "true" : true//<- you can shorten this by doing ??
        return ItemData(title, hasChildren, isOpen, isVisible, isSelected)
    }
    /**
     * New
     */
    static func itemData(_ xml:XML,_ idx:[Int])->ItemData {
        let child:XML = XMLParser.childAt(xml, idx)!
        let itemData = TreeListUtils.itemData(child)
        return itemData
    }
}
private class Utils{
    /**
     * // :TODO: write java doc
     */
    static func treeItem(_ itemData:ItemData,_ parent:IElement,_ size:CGPoint) -> Element {
        let item:Element = itemData.hasChildren ? Utils.treeListItem(itemData, parent, size) : Utils.selectTextButton(itemData, parent, size)
        item.isHidden = !itemData.isVisible// :TODO: should this be here and do we need isVisible?
        return item
    }    
    static func treeListItem(_ itemData:ItemData,_ parent:IElement,_ size:CGPoint) -> TreeListItem {
        return TreeListItem(size.x,size.y,itemData.title,itemData.isOpen,itemData.isSelected,parent)
    }
    static func selectTextButton(_ itemData:ItemData,_ parent:IElement,_ size:CGPoint) -> SelectTextButton {
        return SelectTextButton(size.x,size.y,itemData.title,itemData.isSelected,parent)
    }
}



