
import Foundation


/**
 * { ArrayUtils} has convenience methods for java arrays.
 */
public class ArrayUtils {
    public static func  resizeArray( src:[String],  size:Int)->[String] {
        var array:[String] = []
    array.append(contentsOf: src)
    
    return array;
    }
    
    public static func initArray( size:Int)->[String] {
        let array:[String] = []
    
    
    return array;
    }
    
}
