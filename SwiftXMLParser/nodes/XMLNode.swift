

import Foundation


/**
 * Represents a XML Node inside a DOM.
 */
public protocol XMLNode:NSObjectProtocol {
    /**
     * Returns number of children for this node. If this is leaf node, it will
     * return zero
     */
    func  children()-> Int
    
    /**
     * makes a deep copy of this XML Node and returns it
     *
     * @return
     */
    func clone() -> Any
    
    /**
     * Returns XML representation of this XML node
     */
    func  stringify()->String
    
    /**
     * Returns XML string with all the children nodes of this node
     *
     * @return
     */
    func  stringifyChildren()->String;
    
    /**
     * Returns concatenated String of  Text and CDataSection
     * nodes in the children. If there is no child of type  Text or
     * CDataSection exist, this method will return null
     */
    func  val()->String!;
    
}
