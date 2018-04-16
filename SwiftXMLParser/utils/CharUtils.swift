
import Foundation

public class CharUtils {
    public static let  SPACE:Character = " "
    public static let  LF:Character = "\n";
    public static let CR:Character = "\r";
    public static let TAB:Character = "\t";
    
    public static func isWhiteChar( c:Character)->Bool {
    return (c == CharUtils.SPACE || c == CharUtils.LF || c == CharUtils.CR || c == CharUtils.TAB) ? true : false;
    }
    
}
