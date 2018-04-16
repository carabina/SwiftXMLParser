
import Foundation

public class ParserInternalError: Error {
    private var msg:String!
    
    public init() {
    }
    
    public init( msg:String) {
        
        self.msg = msg
    }
    
}
