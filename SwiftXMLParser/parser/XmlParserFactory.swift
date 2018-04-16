
import Foundation

/**
 * Factory to instantiate xml parser ({ SwiftParser}). The factory is
 * singleton meaning it maintains single instance of the parser and returns it
 */
public class XmlParserFactory {
    private static var xmlParser:XmlParser!
    
    public static func  getParser()-> XmlParser {
    if (xmlParser == nil) {
    		
    xmlParser =  SwiftParser()
    }
    
    
    return xmlParser
    }
}
