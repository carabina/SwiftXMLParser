
import Foundation

/**
 * Plain  object to hold { SwiftParser} state.
 */
public class ParserState {
    var curAttrIndex:Int = -1;
    
    var stage = ParsingStage.START;
    var prevStage:ParsingStage! 
    
    var attributeNames:[String]! = [];
    var attributeValues:[String]! = [];
    
    var elementCData:String? = nil;
    var elementName:String? = nil;
    var cDataBoundaryCharIndex = -1;
    var slashFound = false;
    
    var entityType = Entity.UNKNOWN;
    
    var highSurrogate = false;
    
    var errorType:ParserStateError? = nil;
    var errorMessage:String! = nil;
    
    public func getElementName()-> String! {
        return elementName!;
    }
    
    public func getErrorType()-> ParserStateError {
        return errorType!;
    }
    
    public func getErrorMessage()-> String! {
        return errorMessage;
    }
    
    public func isError()-> Bool{
        return stage == ParsingStage.ERROR ? true : false;
    }
    
    
    public func foundRootElement(){
        self.stage = ParsingStage.END_OF_ROOT;
    }
    
    public func toString()-> String {
        var b = ""
        b = b.appending("<").appending(elementName!).appending(" ");
        
        if (attributeNames != nil) {
            for  i in 0 ..< attributeNames.count {
                b = b.appending(attributeNames[i]).appending("=").appending(attributeValues[i]).appending(" ");
            }
        }
        
        return b
    }
    
}
public enum ParserStateError {
    case ATTR_COUNT_LIMIT_EXCEEDED
    
    case ATTR_NAME_LENGTH_LIMIT_EXCEEDED
    
    case ATTR_VALUE_LENGTH_LIMIT_EXCEEDED
    
    case ELEMENT_NAME_SIZE_LIMIT_EXCEEDED
    
    case ELEMENT_VALUE_SIZE_LIMIT_EXCEEDED
    
    case INVALID_ENTITY
    
    case CHAR_NOT_ALLOWED
    
    case CLOSE_ELEMENT_BEFORE_OPEN
    
    case MALFORMED_XML
    
    case UNKNOWN
    
}

