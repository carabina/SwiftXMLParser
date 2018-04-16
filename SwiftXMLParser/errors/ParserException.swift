
import Foundation

/**
 * Exception thrown for pasring errors in in stream. The exception is used by
 * both { MultipartParser} and { SwiftParser}.
 */
public class ParserException: Error {
    private var msg:String!
    
    public init() {
    }
    
    public init( msg:String) {
        
        self.msg = msg
    }
    
}
