

import Foundation

/**
 * DomBuilder is an implementation of  ParseEventHandler. It is a very
 * simple implementation of Content Handler  ParseEventHandler for
 *  SwiftParser. DomBuilder can handle multiple document at the
 * same time (multi-root xml) and returns these document in the same order in
 * which they were received on the network.
 */
public class DomEventHandler:ParseEventHandler
{
    
    private var parserState:ParserState!
    private var parsedElement:Element! = nil
    private var elmStack:Stack<Element> =  Stack<Element>()
    private var namespaces:[String:String] = [:]
    private var callback:ParseEventCallback
     init( callback:ParseEventCallback) {
        print("object of dom event handler")
       self.parserState = ParserState()
        self.callback = callback
    }
    public func onStartElement(name:String,attr_names:[String?]!, attr_values:[String]!) {
        if (attr_names != nil) {
            for i in 0 ..< attr_names.count {
                if (attr_names[i] == nil) {
                    break;
                }
                
                if (attr_names[i]?.hasPrefix("xmlns:"))! {
                    namespaces[(attr_names[i]?.substring(from: (attr_names[i]?.index((attr_names[i]?.startIndex)!, offsetBy: "xmlns:".count ))!))!] =  attr_values[i]
                }
            }
        }
        var tmp_name = name
        var new_xmlns:String! = nil
        var prefix:String! = nil
        var tmp_name_prefix:String! = nil
        let colon:Character = ":"
        let index = tmp_name.index(of:colon)
        var idx = 0
        if index != nil{
            idx = tmp_name.distance(from: tmp_name.startIndex, to: index!)
        }
        if (idx > 0) {
            
            tmp_name_prefix = tmp_name.substring(to:tmp_name.index(tmp_name.startIndex, offsetBy: idx) );
        }
        
        if (tmp_name_prefix != nil) {
            for  pref in Array(namespaces.keys) {
                if (tmp_name_prefix == pref ) {
                    new_xmlns = namespaces[pref]
                    tmp_name = tmp_name.substring(from:tmp_name.index(tmp_name.startIndex, offsetBy: pref.count + 1) )
                    prefix = pref;
                }
            }
        }
        
        let elem = newElement(name: tmp_name, cdata: nil, attnames: attr_names as! [String]?, attvals: attr_values);
        let ns = elem.getXMLNS();
        
        if (ns == nil) {
            if (elmStack.stackArray.isEmpty || elmStack.peek()?.getXMLNS() == nil) {
                
            } else {
                elem.setDefXMLNS(ns: (elmStack.peek()?.getXMLNS())!);
            }
        }
        if (new_xmlns != nil
            ) {
            elem.setXMLNS(ns: new_xmlns);
            elem.removeAttribute(key: "xmlns:" + prefix);
        }
        
        if (tmp_name == "stream") {
            print("***********************" + "stream nodes" + elem.toString())
            
            addParsedElement(elem: elem)
        } else {
            print("***********************" + "other nodes" + elem.toString())
            elmStack.push(stringToPush: elem);
        }
        printElmStack()
    }
    
    public func onElementCData(cdata:String) {
        print("Adding cData:" + cdata);
        elmStack.peek()?.addCDATASection(cdata: cdata)
        
    }
    public func onElementText(text:String){
        
//        print("***********************" + (elmStack.peek()?.toString())!)
        elmStack.peek()?.addText(text: text)
        
    }
    
    public func onEndElement(name:String) ->Bool {
        var tmp_name = name
        var tmp_name_prefix:String! = nil
        let colon:Character = ":"
        let index = tmp_name.index(of:colon)
        var idx = 0
        if index != nil{
            idx = tmp_name.distance(from: tmp_name.startIndex, to: index!)
            
        }
        
        
        if (idx > 0) {
            tmp_name_prefix = tmp_name.substring(to:tmp_name.index(tmp_name.startIndex, offsetBy: idx) )
            print(tmp_name_prefix)
        }
        
        if (tmp_name_prefix != nil) {
            for  pref in Array(namespaces.keys) {
                if (tmp_name_prefix == pref ) {
                    tmp_name = tmp_name.substring(from:tmp_name.index(tmp_name.startIndex, offsetBy: pref.count + 1) )
                    
                }
            }
            
        }
        
        if (elmStack.stackArray.isEmpty) {
            // It means we have encountered end of element without start of it.
            addParsedElement(elem:newElement(name: tmp_name, cdata: nil, attnames: nil, attvals: nil))
            print("empty stack")
            return false;
        }
        
        let elem = elmStack.pop();
        if (elem?.getName() != tmp_name){
            print(elem!.getName())
            return false;
        }
        if (elmStack.stackArray.isEmpty) {
            addParsedElement(elem: elem!);
            
            
        } else {
            elmStack.peek()?.addChild(child: elem);
        }
        
        return true;
    }
    func addParsedElement(elem:Element) {
        self.parsedElement = elem
        print(elem)
        let quit:Bool = self.callback.onParsedElement(e:elem)
        if quit {
            self.parserState.foundRootElement()
        }
        
    }
    
    public func onError(errorMessage:String) {
        print("XML content parse error.");
        print(errorMessage);
        //        print(parserState.toString());
        printElmStack();
        self.elmStack.stackArray.removeAll()
        
    }
    
    public func onOtherXML(other:String)
    {
        print("Other XML content: " + other);
        
    }
    
    public func saveParserState(state:ParserState)
    {
        self.parserState = state;
    }
    
    public func getParserState() -> ParserState!
    {
        return self.parserState
    }
    
    private func newElement(name:String!,cdata:String!,attnames:[String]!,attvals:[String]!)-> Element {
        return  Element(name: name, attributeName: attnames, attributeValues: attvals);
    }
    public func printElmStack() {
        print("Printing ElmStack Elements");
        
        var itr = elmStack.stackArray.enumerated().makeIterator();
        var finished  = false
        while (!finished) {
            let eleItr = itr.next()
            if eleItr != nil {
            print((eleItr?.element.toString()) as Any)
            }
            else{
                finished = true
            }
        }
        
        print("End of stack");
    }
    
    public func getParsedElement() -> Element! {
        if self.parsedElement != nil
        {
           defer {
                self.parsedElement = nil
            }
            return self.parsedElement
        }
        
        return nil
    }
    
    public func hasParsedElement()-> Bool {
        return self.parsedElement != nil
    }
    
    
}
