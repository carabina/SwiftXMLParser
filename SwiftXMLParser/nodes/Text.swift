

import Foundation
/**
 * Represents text node in xml DOM
 */
public class Text:NSObject, XMLNode {
    
    private var text:String!
    public override init() {
        super.init()
    }
    @objc public init(text:String) {
        self.text = text;
    }
    
    @objc public func getText()-> String {
        return text;
    }
    
    
    @objc public func children()-> Int {
        return 0;
    }
    
    
    @objc public func stringify()-> String  {
        return self.text;
    }
    
    
    @objc public func stringifyChildren()-> String  {
        return "";
    }
    
    
    @objc public func clone()-> Any {
        return  Text(text: text);
    }
    
    
    @objc public func val()-> String!  {
        return text;
    }
    
}
