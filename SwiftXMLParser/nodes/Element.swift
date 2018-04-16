
import Foundation
/**
 * This extremely simple implementation for XML element. It does not support
 * many features offered in XML specification for an implement. However it is
 * good enough to handle XMPP Stanza elements.
 *
 * Currently this does not support  CDataSection
 */
public class Element: NSObject, XMLNode {
    
    @objc var name:String!
    
    @objc var defxmlns:String! = nil
    @objc var xmlns:String! = nil
    var childrens:[XMLNode]!
    @objc var attributes:[String:String]!
    
    /**
     * Performs a deep copy on the supplied element and populates instance
     * variable of this instance.
     */
    required override public init() {
        
    }
    /**
     * Creates a blank element with the name given
     */
    @objc required public init(name:String) {
        self.name = name
    }
    /**
     * Performs a deep copy on the supplied element and populates instance
     * variable of this instance.
     */
    @objc public init(element:Element) {
        let src:Element = element.copy() as! Element;
        
        self.attributes = src.attributes;
        self.name = src.name;
        self.defxmlns = src.defxmlns;
        self.xmlns = src.xmlns;
        self.childrens = src.childrens;
    }
    
    public init(name:String,attributeName:[String?]!,attributeValues:[String?]!){
        self.name = name;
        if(attributeName != nil && attributeValues != nil){
            attributes =  [:]
            for i in 0 ..< attributeName.count
            {
                if(attributeName[i] == nil || attributeValues[i] == nil){
                    break;
                }
                attributes[attributeName[i]!] = attributeValues[i]
            }
        }
        
        
    }
    
    
    /**
     * Creates a simple element with given and name and text value
     */
    @objc public init( name:String,  text:String!) {
        super.init()
        setName(argName: name);
        
        if (text != nil) {
            addText(text: text);
        }
    }
    
    @objc public func getChildStaticStr(name:String)->Element! {
        if (childrens != nil) {
            for el in childrens {
                if el.isKind(of: Element.self) {
                    let elem =  el as! Element
                    
                    if (elem.getName() == name) {
                        return elem;
                    }
                }
            }
        }
        
        return nil;
    }
    @objc public func getChild(name:String)->Element! {
        if (childrens != nil) {
            for  el in childrens {
                if el.isKind(of: Element.self) {
                    let elem =  el as! Element;
                    if (elem.getName() == name) {
                        return elem;
                    }
                }
            }
        }
        
        return nil;
    }
    @objc public func findChild(elemPath:[String])-> Element!{
        var elemPaths:[String] = []
        if !(elemPath[0].isEmpty) {
            elemPaths = Array(elemPath[ 1 ..< elemPath.count ])
        }
        if elemPath[0] != getName() {
            return nil;
        }
        
        var child:Element! = self
        
        // we must start with 1 not 0 as 0 is name of parent element
        if child != nil {
            for  i in  1 ..< elemPaths.count  {
                let str = elemPaths[i];
                
                child = child.getChild(name: str);
            }
        }
        return child;
    }
    
    @objc public func getChild(name:String,child_xmlns:String!)-> Element! {
        if (child_xmlns == nil) {
            return getChild(name: name);
        }
        if (childrens != nil) {
            for  el in childrens {
                if (el.isKind(of: Element.self)) {
                    let elem =  el as! Element
                    if (elem.getName() == name) && (child_xmlns == elem.getXMLNS()) {
                        return elem;
                    }
                }
            }
        }
        
        return nil;
    }
    /**
     * Returns value for the supplied attribute. As attributes are stored in a
     * list, it's a plain linear probe. We may change the data structure to a
     * { Map} if this degrades the performance. The assumption is that XMPP
     * packets do not have too many attributes.
     */
    @objc public func getAttribute(attName:String)->String! {
        if (attributes != nil) {
            for  key in Array(self.attributes.keys) {
                if (key == attName) {
                    return self.attributes[key]!;
                }
            }
        }
        
        return nil;
    }
    @objc public func getChildren() -> [Element]! {
        if (childrens != nil) {
            var result:[Element] = []
            
            for node in childrens {
                if (node.isKind(of: Element.self)) {
                    result.append(node as! Element)
                }
            }
            
            return result;
        }
        
        return nil;
    }
    
    @objc public func getChildren(elementPath:[String])-> [Element]! {
        let child = findChild(elemPath: elementPath);
        
        return (child != nil) ? child!.getChildren() : nil;
    }
    
    @objc public func getXMLNS()->String! {
        if (xmlns == nil) {
            xmlns = getAttribute(attName: "xmlns");
            xmlns = ((xmlns != nil) ? xmlns: nil);
        }
        
        return (xmlns != nil) ? xmlns : defxmlns;
    }
    
    @objc public func getXMLNS(elementPath:[String])->String! {
        let child = findChild(elemPath: elementPath);
        
        return (child != nil) ? child!.getXMLNS() : nil;
    }
    
    @objc public func removeAttribute(key:String) {
        if (attributes != nil) {
            attributes.removeValue(forKey: key);
        }
    }
    
    
    
    @objc public func getChildAttribute( childName:String, attName:String) -> String{
        var result:String! = nil;
        let child = getChild(name: childName);
        
        if (child != nil) {
            result = child!.getAttribute(attName: attName);
        }
        
        return result;
    }
    /**
     * Returns attributes for this element. Any change in the returned
     * attributes will reflect back in this element attribute list
     */
    @objc public func getAttributes()-> [String:String] {
        return attributes;
    }
    /**
     * Adds text node in the children of this element. This operation will
     * remove exiting CDataSection and  Text nodes from the
     * children
     */
    @objc public func addText(text:String) {
        addText(text: text, removeExiting: true);
    }
    
    /**
     * adds  Text node to this element children. If
     *  removeExisting flag is on, exisitng  CDataSection and
     *  Text nodes will be removed
     *
     * @param text
     * @param removeExiting
     */
    @objc public func addText(text:String,removeExiting:Bool) {
        if (removeExiting) {
            removeText();
        }
        
        addChild(child: Text(text: text));
    }
    
    @objc public func addAttribute(attName:String,attValue:String) {
        setAttribute(key: attName, value: attValue);
    }
    
    @objc public func addAttributes(attrs:[String:String]!) {
        if (attributes == nil) {
            attributes = [:]
        }
        
        for key in  Array(attrs.keys){
            attributes[key] = attrs[key]
        }
    }
    
    @objc public func addChildren(children:[Element]!) {
        if (children == nil) {
            return;
        }
        
        if (self.childrens == nil) {
            self.childrens = []
        }
        
        for child in children {
            self.childrens.append(child.clone() as! XMLNode);
        }
    }
    public func addChild(child:XMLNode!) {
        if (child == nil) {
            print("Element child can not be null.");
        }
        if (childrens == nil) {
            childrens = [];
        }
        
        childrens.append(child);
    }
    /**
     * Removes  Text nodes and CDataSection nodes from the
     * children of this element
     */
    @objc public func removeText() {
        if (self.childrens == nil){
            return
        }
        for child in self.childrens {
            if (child.isKind(of: Text.self) && !child.isKind(of:CDataSection.self)) {
                self.childrens = self.childrens.filter{ $0.isKind(of: Text.self) && ($0 as! Text)  != (child as! Text)}
            }
        }
    }
    
    /**
     * Adds  CDataSection node in the children of this element
     */
    @objc public func addCDATASection(cdata:String){
        addChild(child: CDataSection(cdata: cdata));
    }
    
    @objc public func setDefXMLNS(ns:String) {
        defxmlns = ns;
    }
    
    @objc public func setName(argName:String) {
        self.name = argName;
    }
    
    @objc public func setXMLNS(ns:String!) {
        if (ns == nil) {
            xmlns = nil
            removeAttribute(key: "xmlns");
        } else {
            xmlns = ns
            setAttribute(key: "xmlns", value: xmlns);
        }
    }
    
    
    @objc public func removeChild(child:Element)-> Bool {
        var res = false;
        
        if (childrens != nil) {
            childrens   = childrens.filter {($0 as! Element) != child}
            res =  true
        }
        
        return res;
    }
    
    @objc public func setAttribute(key:String,value:String) {
        if (attributes == nil) {
            attributes =  [:]
        }
        
        let k = key
        var v = value
        
        if (k == "xmlns") {
            xmlns = value
            v = xmlns;
        }
        
        attributes[k] = v
    }
    
    
    @objc public func getName() ->String{
        return self.name;
    }
    
    @objc public func  stringify()->String
    {
        var xml =  String()
        
        xml.append("<")
        xml.append(name)
        if (attributes != nil) {
            for key in Array(self.attributes.keys) {
                xml.append(" ")
                xml.append(key)
                xml.append(" = ")
                xml.append(self.attributes[key]!)
                xml.append(" ");
            }
        }
        
        if (childrens != nil && !childrens.isEmpty) {
            xml.append(">");
            xml.append(stringifyChildren());
            xml.append("</")
            xml.append(name)
            xml.append(">");
        } else {
            xml.append("/>");
        }
        
        return xml;
    }
    @objc public func  stringifyChildren()->String
    {
        var xml =  String()
        
        if (childrens != nil && !childrens.isEmpty) {
            for  child in childrens {
                xml.append(child.stringify());
            }
        }
        
        return xml;
    }
    
    public func setChildren(children:[XMLNode]) {
        self.childrens = []
        
        for child in children {
            self.childrens.append(child.clone() as! XMLNode)
        }
    }
    
    @objc public func clone()-> Any {
        
        var clone:Element! = nil;
        
        
        
        clone = super.copy() as! Element;
        
        
        if (self.attributes != nil) {
            clone.attributes =  self.attributes ;
            
        } else {
            clone.attributes = nil;
        }
        
        if (childrens != nil) {
            clone.setChildren(children: self.childrens);
            
        } else {
            clone.childrens = nil;
        }
        
        return clone;
    }
    
    
    @objc public func equals(obj:AnyObject!)-> Bool {
        if (obj != nil && obj.isKind(of: Element.self)) {
            let objString = (obj as! Element).stringify();
            let thisString = self.stringify();
            
            return objString == thisString;
        }
        
        return false;
    }
    
    @objc public func children()-> Int {
        return childrens != nil && !childrens.isEmpty ? childrens.count : 0;
    }
    
    @objc public func toString()->String {
        return "Element " + self.name + " [Children: \(self.children()) ]";
    }
    
    @objc public func  val()->String!
    {
        if (self.childrens == nil){
            return nil;
        }
        var val =  String();
        
        for child in self.childrens {
            if (child.isKind(of: Text.self) || child.isKind(of:CDataSection.self)) {
                val.append(child.val());
            }
        }
        
        return val;
    }
    
    //flatMapChildren,forEachChild
    @objc public func forEachChild(accept:((_ t:Element)->Void)) {
        if (childrens != nil) {
            for  node in childrens! {
                if (!(node.isKind(of: Element.self) )) {
                    continue;
                }
                
                let el:Element = node as! Element
                accept(el)
            }
        }
    }
    
    public func flatMapChildren<R>( mapper:((_ t:Element)->R))-> [R]!{
        var result:[R]! = []
        if (childrens != nil) {
            for  node in childrens! {
                if (!(node.isKind(of: Element.self) )) {
                    continue;
                }
                
                let el =  node as! Element
                result.append(mapper(el))
            }
            
            return result;
        }
        
        return nil;
    }
}
