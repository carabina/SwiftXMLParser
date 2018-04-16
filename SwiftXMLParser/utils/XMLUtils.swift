
import Foundation


public  class XMLUtils {
    private static let decoded:[String] = [ "&", "<", ">", "\"", "\'" ]
    private static let encoded:[String] = [ "&amp;", "&lt;", "&gt;", "&quot;", "&apos;" ]
    
    private static let decoded_1:[String] = [ "<", ">", "\"", "\'", "&" ]
    private static let encoded_1:[String] = [ "&lt;", "&gt;", "&quot;", "&apos;", "&amp;" ]
    
    public static func escape( input:String!)->String! {
        if (input != nil) {
            return translateAll(input: input, patterns: XMLUtils.decoded, replacements: encoded);
        } else {
            return nil;
        }
    }
    
    public static func translateAll( input:String, patterns:[String], replacements:[String])->String {
        var result = input;
        
        for  i in 0 ..< patterns.count {
            result = result.replacingOccurrences(of: patterns[i], with: replacements[i])
        }
        
        return result;
    }
    
    public static func unescape( input:String!) -> String!{
        if (input != nil) {
            return translateAll(input: input, patterns: XMLUtils.encoded_1, replacements: decoded_1);
        } else {
            return nil;
        }
    }
}
