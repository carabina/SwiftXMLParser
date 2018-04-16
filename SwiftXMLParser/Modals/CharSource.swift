
import Foundation

/**
 * { CharSource} is a wrapper around char array. It maintains vital fields
 * such as position, limit and capacity to facilitate better reading process.
 */
public class CharSource: Resetable {
    private var chars:[Character]!
    private var position:Int!
    private var limit:Int!
    
    public convenience init(chars:[Character]) {
        self.init(chars: chars, position: 0, limit: chars.count);
    }
    
    public init(chars:[Character], position:Int,limit:Int) {
        self.chars = chars;
        self.position = position;
        self.limit = limit;
    }
    
    public func getChars()-> [Character] {
        return chars;
    }
    
    public func getPosition()->Int {
        return position;
    }
    
    public func getLimit()->Int {
        return limit;
    }
    
    public func getCapacity()->Int {
        return chars == nil ? 0 : chars.count;
    }
    
    /**
     * Returns true if there is another byte which can be read from this
     * { ByteSource}
     */
    public func hasNext()->Bool {
        return self.position < self.limit;
    }
    
    /**
     * Reads next char from data source
     */
    public func next() -> Character{
        if position < self.chars.count {
            let next = self.chars[position]
            position = position + 1
            return next
        }
        
        return CharUtils.SPACE
        
        
    }
    
    /**
     * Copies remaining char data of this { CharSource} into the src char
     * array. If the length of src array is smaller than the remaining content,
     * the method will throw { ArrayIndexOutOfBoundsException}
     *
     * @param src
     */
    public func get( src:[Character]) {
        self.chars[position ... (position + src.count)] = ArraySlice<Character>(src)
        self.position = chars.count;
    }
    
    /**
     * Copies remaining char data of this { CharSource} into the src char
     * starting from the srcPos. If the length of src array is smaller than the
     * remaining content, the method will throw
     * { ArrayIndexOutOfBoundsException}
     *
     * @param src
     * @param srcPos
     */
    public func get(src:[Character],  srcPos:Int) {
        self.chars[position ... (position + src.count - srcPos)] = src[srcPos ... src.count]
        self.position = self.chars.count;
    }
    
    /**
     * Copies chars data of this { CharSource} into the src char starting
     * from the srcPos. If the length of src array is smaller than the remaining
     * content, the method will throw { ArrayIndexOutOfBoundsException}
     *
     * @param src
     * @param srcPos
     * @param length
     */
    public func get(src:[Character],  srcPos:Int, length:Int) {
        self.chars[position ... (position + length)] = src[srcPos ... (srcPos + length)]
        
        self.position = self.position + length;
    }
    
    
    public func reset() {
        self.chars = [];
        self.position = 0;
        self.limit = 0;
    }
    
    /**
     * Reloads this { CharSource} with given chars. The position of the
     * char source will be set to zero and limit will be set to the length of
     * the char array.
     *
     * @param chars
     *            chars array (data)
     */
    public func reload( chars:[Character]) {
        self.reload(chars: chars, position: 0, limit: chars.count);
    }
    
    /**
     * Reloads this { CharSource} with given chars. The position of the
     * char source will be set to the position supplied and limit will be set to
     * the length of the char array.
     *
     * @param chars
     *            chars array (data)
     * @param position
     *            position from which reading will start
     */
    public func reload(chars:[Character],  position:Int) {
        self.reload(chars: chars, position: position, limit: chars.count);
    }
    
    /**
     * Reloads this { CharSource} with given chars
     *
     * @param chars
     *            chars array (data)
     * @param position
     *            position from which reading will start
     * @param limit
     *            boundary index. The reading cursor will always be behind the
     *            boundary
     */
    public func reload(chars:[Character],  position:Int,  limit:Int) {
        self.chars.removeAll()
        self.chars = chars
        self.position = position;
        self.limit = limit;
        
    }
    
    /**
     * Sets position index to the given value
     * 
     * @param position
     */
    public func setPosition( position:Int) {
        self.position = position;
    }
    
    
    /**
     * Number of chars remainig in this { CharSource}. The number is
     * calculated based on the value of { CharSource#limit} and
     * { CharSource#position} variables; although at any point underlying
     * array has all the elements.
     */
    public func remaining()->Int {
        return self.limit - self.position;
    }
}
