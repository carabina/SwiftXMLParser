
import Foundation


/**
 * { ByteSource} is a wrapper around byte array. It maintains vital fields
 * such as position, limit and capacity to facilitate better reading process.
 * <p>
 * { ByteSource} is unidirectional (can be read only in one direction);
 * however it offers random access using index.
 * </p>
 * <p>
 * position is is the index of first byte which will be read. limit is the index
 * of first byte which will not be read.
 * </p>
 */
public class ByteSource: Resetable {
    private var bytes:[UInt8]
    private var position:Int!
    private var limit:Int!
    
    public convenience init(bytes:[UInt8]) {
        self.init(bytes: bytes, position: 0, limit: bytes.count);
    }
    
    public init(bytes:[UInt8],  position:Int, limit:Int) {
        self.bytes = bytes;
        self.position = position;
        self.limit = limit;
    }
    
    public func byte()-> [UInt8]{
        return bytes;
    }
    
    public func positions()-> Int {
        return position;
    }
    
    /**
     * Returns limit of this byte source. Important to note that limit is an
     * index; not an absolute number.
     */
    public func limits()-> Int {
        return limit;
    }
    
    public func capacity()-> Int {
        return bytes.isEmpty ? 0 : bytes.count;
    }
    
    public func getPosition()-> Int {
        return position;
    }
    
    /**
     * Reads next byte from data source; after reading the byte, position moves
     * to next byte.
     */
    public func next()->UInt8 {
        let next =  self.bytes[position]
        position = position + 1
        return next
    }
    
    /**
     * Returns true if there is another byte which can be read from this
     * { ByteSource}
     */
    public func hasNext()->Bool {
        return self.position < self.limit;
    }
    
    /**
     * Returns the byte at the index. The method does not change any marker such
     * as limit, position etc.
     *
     * @param index index of the byte
     */
    public func get( index:Int)-> UInt8 {
        return self.bytes[index];
    }
    
    /**
     * Copies remaining byte data of this { ByteSource} into the src byte
     * array. If the length of src array is smaller than the remaining content,
     * the method will throw { ArrayIndexOutOfBoundsException}
     *
     * @param src
     */
    public func get( src:[UInt8]) {
        self.bytes[position ... ( position + src.count )] = ArraySlice<UInt8>(src)
        self.position = bytes.count;
    }
    
    /**
     * Copies remaining byte data of this { ByteSource} into the src byte
     * starting from the srcPos. If the length of src array is smaller than the
     * remaining content, the method will throw
     * { ArrayIndexOutOfBoundsException}
     *
     * @param src
     * @param srcPos
     */
    public func get(src:[UInt8], srcPos:Int) {
        self.bytes[position ..< (position + src.count - srcPos)] = src[srcPos ... src.count]
        self.position = self.bytes.count;
    }
    
    /**
     * Copies bytes data of this { ByteSource} into the src byte starting
     * from the srcPos. If the length of src array is smaller than the remaining
     * content, the method will throw { ArrayIndexOutOfBoundsException}
     *
     * @param src
     * @param srcPos
     * @param length
     */
    public func get(src:[UInt8], srcPos:Int,  length:Int) {
        self.bytes[position ..< (position + length)] = src[srcPos ... (srcPos + length)]
        
        self.position = self.position + length
    }
    
    
    public func reset() {
        self.bytes = [];
        self.position = 0;
        self.limit = 0;
    }
    
    /**
     * Reloads this { ByteSource} with given bytes. The position of the
     * byte source will be set to zero and limit will be set to the length of
     * the byte array.
     *
     * @param bytes bytes array (data)
     */
    public func reload( bytes:[UInt8]) {
        self.reload(bytes: bytes, position: 0, limit: bytes.count);
    }
    
    /**
     * Reloads this { ByteSource} with given bytes. The position of the
     * byte source will be set to the position supplied and limit will be set to
     * the length of the byte array.
     *
     * @param bytes bytes array (data)
     * @param position position from which reading will start
     */
    public func reload(bytes:[UInt8],  position:Int) {
        self.reload(bytes: bytes, position: position, limit: bytes.count);
    }
    
    /**
     * Reloads this { ByteSource} with given bytes
     *
     * @param bytes bytes array (data)
     * @param position position from which reading will start
     * @param limit boundary index. The reading cursor will always be behind the
     *            boundary
     */
    public func reload(bytes:[UInt8],  position:Int,  limit:Int) {
        self.bytes.removeAll()
        self.bytes = bytes
        self.position = position
        self.limit = limit
    }
    
    /**
     * Sets position index to the given value
     *
     * @param position
     */
    public func setPosition(position:Int) {
        self.position = position;
    }
    
    
    /**
     * Number of chars remainig in this { ByteSource}. The number is
     * calculated based on the value of { ByteSourcee#limit} and
     * { ByteSource#position} variables; although at any point underlying
     * array has all the elements.
     */
    public func remaining() -> Int{
        return self.limit - self.position
    }
}


/**
 * Range captures a byte range with a start index and an end index. Start
 * index is the index at which byte can be read from the byte source. End
 * index is the first byte which can NOT be read.
 */
public class ByteRange {
    private var startIndex:Int
    private var endIndex:Int
    
    public convenience init( startIndex:Int) {
        self.init(startIndex: startIndex, endIndex: 0)
    }
    
    public init( startIndex:Int, endIndex:Int) {
        self.startIndex = startIndex
        self.endIndex = endIndex
    }
    
    /**
     * Returns start index of the {@code ByteRange}
     */
    public func start()->Int {
        return startIndex
    }
    
    /**
     * Returns end index of this {@code ByteRange}
     */
    public func end()->Int {
        return endIndex
    }
    
    /**
     * Sets the end index to the given value
     */
    public func end( endIndex:Int) {
        self.endIndex = endIndex
    }
    
    /**
     * Returns length of this {@code ByteRange}
     */
    public func length()->Int {
        return self.endIndex - self.startIndex
    }
    
    /**
     * Checks if the start index and end index are same. In this case range
     * represents nothing.
     */
    public func isNull()->Bool {
        return self.startIndex == self.endIndex
    }
    
}

