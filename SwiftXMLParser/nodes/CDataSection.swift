
import Foundation


/**
 * Represents CDATA section in XML DOM. Currently {@link SwiftParser} does not
 * support it.
 */
public class CDataSection: Text {
    
    @objc public init(cdata:String) {
        super.init(text: cdata)
    }
    
    @objc public func getCData()->String {
        return getText()
    }
    
    
    public override func stringify()->String {
        return super.stringify()
    }
    
    
    public override func children()-> Int {
        return 0
    }
    
    
    public override func stringifyChildren()-> String {
        return super.stringifyChildren()
    }
    
    
    public override func val()->String  {
        return super.val()
    }
    
    
    public override func clone() -> Any{
        return  CDataSection(cdata: getCData())
    }
    
    
    @objc public func toString()->String  {
        return ""
    }
    
}
