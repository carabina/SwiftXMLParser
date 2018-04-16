

import Foundation


/**
 * Configuration holder class for Parser configurations
 */
public class ParserConfiguration {
    public static let OPEN_BRACKET:Character = "<";
    public static let CLOSE_BRACKET:Character  = ">";
    public static let QUESTION_MARK:Character  = "?";
    public static let EXCLAMATION_MARK:Character  = "!";
    public static let SLASH:Character  = "/";
    public static let SPACE:Character  = " ";
    public static let TAB:Character  = "\t";
    public static let LF:Character  = "\n";
    public static let CR:Character  = "\r";
    public static let AMP:Character  = "&";
    public static let EQUALS:Character  = "=";
    public static let HASH:Character  = "#";
    public static let SEMICOLON:Character  = ";";
    public static let SINGLE_QUOTE:Character  = "'";
    public static let DOUBLE_QUOTE:Character  = "\""
    public static let  WHITE_CHARS:[Character] = [ SPACE, LF, CR, TAB ]
    public static let CDATA_END:[Character] = [ "]", "]", ">"]
    public static let  CDATA_START:[Character] = [ "<", "!", "[", "C", "D", "A", "T", "A", "[" ]
    public static let  ERR_NAME_CHARS:[Character]  = [ OPEN_BRACKET, QUESTION_MARK, AMP ]
    public static let  IGNORE_CHARS:[Character]  = ["\0" ]
    public static var ALLOWED_CHARS_LOW:[Bool] =  []
    
    // Max number of attribute an element can have
    public static let MAX_ATTR_COUNT = 50
    
    // Block size is the initial size the attribute array. When parser
    // encounters an element with attributes, it allocates an array of blockSize
    // to hold these attributes. If the number of attributes that this element
    // has is more than the blockSize, parser resizes the attribute array
    // (increasing the size by blockSize). This is the space optimization
    // mechanism which avoids parser allocating attributes array size=
    // maxAttrCount always
    public static let ATTR_BLOCK_SIZE = 6
    
    // max length permitted for an attribute name
    public static let ATTR_NAME_MAX_LENGTH = 1024
    
    // max length permitted for an attribute value
    public static let ATTR_VALUE_MAX_LENGTH = 10 * 1024
    
    // max length permitted for an element name
    public static let ELM_NAME_MAX_LENGTH = 1024
    
    // max size permitted for CDATASection
    public static let CDATA_MAX_SIZE:Int = 1024 * 1024
    
    
}
