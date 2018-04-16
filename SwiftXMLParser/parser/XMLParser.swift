

import Foundation

/**
 * XML Parser interface which will be used by XML based protocols. This is not a
 * full fledged XML parser interface; it's a customized version of XML parser
 * which suits XMPP packet parsing.
 *
 * <p>
 * As this interface does not follow XML standards, it will require massive
 * amount of work to replace this parser with some other parser
 * </p>
 */
public protocol XmlParser: NameAware {
    /**
     * Returns name of the Parser
     */
    func getName<String>()->String
    
    /**
     * Parses the data stream
     *
     * @throws ParserException
     */
    func parse(handler:ParseEventHandler,  charSource:CharSource) throws
    
    /**
     * Parses the data stream
     *
     * @throws ParserException
     */
    func parse( handler:ParseEventHandler,  byteSource:ByteSource) throws
    
}
