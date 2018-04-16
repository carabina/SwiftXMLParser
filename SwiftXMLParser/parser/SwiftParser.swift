
import Foundation
/**
 * A event based parser with very limited capability. It can not handle all the
 * XML constructs correctly. It has been written keeping in mind that it will be
 * used only for XMPP packet parsing. Also, normal text and { CDataSection}
 * are handled the same way in the parser currently.
 *
 * <p>
 * It can not handle comment blocks
 * </p>
 */
public class SwiftParser:NSObject,XmlParser,XMLParserDelegate {
    
    
    /**
     * { SwiftParser} is to be used as singleton. Therefore, restricting
     * constructor access to package. Parser instance must be retrieved using
     * { XmlParserFactory}
     */
    public override init() {
        super.init()
        print("create parser object")
    }
    
    public func parse( handler:ParseEventHandler,  charSource:CharSource) throws  {
        
        var parserState:ParserState! = handler.getParserState();
        handler.saveParserState(state: parserState);
        while (charSource.hasNext()) {
            let c = charSource.next()
            if (ParsingStage.START == parserState.stage) {
                if (c == ParserConfiguration.OPEN_BRACKET) {
                    
                    parserState.stage = ParsingStage.OPEN_BRACKET;
                    parserState.slashFound = false;
                }
               
            } else if (ParsingStage.OPEN_BRACKET == parserState.stage) {
                
                handleOpenBracketStage(parserState: parserState, c: c);
                
            } else if (ParsingStage.START_ELEMENT_NAME == parserState.stage) {
                
                startElementNameStage(handler: handler, parserState: parserState, c: c);
                
            } else if (ParsingStage.CLOSE_ELEMENT == parserState.stage) {
                
                closeElement(handler: handler, parserState: parserState, c: c);
                
            } else if (ParsingStage.END_ELEMENT_NAME == parserState.stage) {
                
                endElementName(handler: handler, parserState: parserState, c: c);
                
            } else if (ParsingStage.START_ATTR_NAME == parserState.stage) {
                
                startAttributeName(parserState: parserState, c: c);
                
            } else if (ParsingStage.END_ATTR_NAME == parserState.stage) {
                
                endAttributeName(parserState: parserState, c: c);
                
            } else if (ParsingStage.START_ATTR_VALUE_SQ == parserState.stage) {
                
                startAttributeValueSQ(parserState: parserState, c: c);
                
            } else if (ParsingStage.START_ATTR_VALUE_DQ == parserState.stage) {
               
                startAttributeValueDQ(parserState: parserState, c: c);
                
            }  else if (ParsingStage.ELEMENT_TEXT == parserState.stage) {
                
                startElementValue(handler: handler, parserState: parserState, c: c);
                
            }else if (ParsingStage.START_CDATA == parserState.stage) {
                
                startElementCData(handler: handler, parserState: parserState, c: c);
                
            } else if (ParsingStage.START_CDATA_CONTENT == parserState.stage) {
               
                startCDataContent(handler: handler, parserState: parserState, c: c);
                
            } else if (ParsingStage.END_CDATA == parserState.stage) {
               
                endCDataContent(handler: handler, parserState: parserState, c: c);
                
                
            }    else if (ParsingStage.ENTITY == parserState.stage) {
                
                entity(parserState: parserState, c: c);
                
            } else if (ParsingStage.END_OF_ROOT == parserState.stage) {
                
                parserState.stage = ParsingStage.START;
                charSource.setPosition(position: charSource.getPosition() - 1);
                
                return;
                
            } else if (ParsingStage.OTHER_XML == parserState.stage) {
                
                otherXml(handler: handler, parserState: parserState, c: c);
                
            } else if (ParsingStage.ERROR == parserState.stage) {
                
                handler.onError(errorMessage: parserState.errorMessage);
                parserState = nil
                return;
                
            } else {
                throw  ParserException(msg: "Unknown parser state");
            }
        }
        
        if (handler.hasParsedElement()) {
            parserState.stage = ParsingStage.START;
        }
    }
    
    
    public func parse( handler:ParseEventHandler,  byteSource:ByteSource) throws  {
        var parserState:ParserState! = handler.getParserState();
        handler.saveParserState(state: parserState);
        
        while (byteSource.hasNext()) {
            let c = Character(UnicodeScalar(byteSource.next()))
            let s = String(c).unicodeScalars
            if (!s[s.startIndex].isASCII) {
                parserState.errorMessage = "Character '" + String(c) + "' is not allowed in XML stream";
                parserState.stage = ParsingStage.ERROR;
                parserState.errorType =  ParserStateError.CHAR_NOT_ALLOWED
            }
            
            if (ParsingStage.START == parserState.stage) {
                if (c == ParserConfiguration.OPEN_BRACKET) {
                    parserState.stage = ParsingStage.OPEN_BRACKET;
                    parserState.slashFound = false;
                }
                
            } else if (ParsingStage.OPEN_BRACKET == parserState.stage) {
                handleOpenBracketStage(parserState: parserState, c: c);
                
            } else if (ParsingStage.START_ELEMENT_NAME == parserState.stage) {
                startElementNameStage(handler: handler, parserState: parserState, c: c);
                
            } else if (ParsingStage.CLOSE_ELEMENT == parserState.stage) {
                closeElement(handler: handler, parserState: parserState, c: c);
                
            } else if (ParsingStage.END_ELEMENT_NAME == parserState.stage) {
                endElementName(handler: handler, parserState: parserState, c: c);
                
            } else if (ParsingStage.START_ATTR_NAME == parserState.stage) {
                startAttributeName(parserState: parserState, c: c);
                
            } else if (ParsingStage.END_ATTR_NAME == parserState.stage) {
                endAttributeName(parserState: parserState, c: c);
                
            } else if (ParsingStage.START_ATTR_VALUE_SQ == parserState.stage) {
                startAttributeValueSQ(parserState: parserState, c: c);
                
            } else if (ParsingStage.START_ATTR_VALUE_DQ == parserState.stage) {
                startAttributeValueDQ(parserState: parserState, c: c);
                
            }
            else if (ParsingStage.ELEMENT_TEXT == parserState.stage) {
                startElementValue(handler: handler, parserState: parserState, c: c);
                
            }else if (ParsingStage.START_CDATA == parserState.stage) {
                startElementCData(handler: handler, parserState: parserState, c: c);
                
            } else if (ParsingStage.START_CDATA_CONTENT == parserState.stage) {
                startCDataContent(handler: handler, parserState: parserState, c: c);
                
            } else if (ParsingStage.END_CDATA == parserState.stage) {
                endCDataContent(handler: handler, parserState: parserState, c: c);
                
                
            }else if (ParsingStage.ENTITY == parserState.stage) {
                entity(parserState: parserState, c: c);
                
            } else if (ParsingStage.END_OF_ROOT == parserState.stage) {
                parserState.stage = ParsingStage.START;
                byteSource.setPosition(position: byteSource.getPosition() - 1);
                
                return;
                
            } else if (ParsingStage.OTHER_XML == parserState.stage) {
                otherXml(handler: handler, parserState: parserState, c: c);
                
            } else if (ParsingStage.ERROR == parserState.stage) {
                handler.onError(errorMessage: parserState.errorMessage);
                parserState = nil
                return;
                
            } else {
                throw ParserException(msg: "Unknown parser state");
            }
        }
        
        if (handler.hasParsedElement()) {
            parserState.stage = ParsingStage.START;
        }
    }
    
    private func otherXml( handler:ParseEventHandler, parserState:ParserState,  c:Character) {
        if (c == ParserConfiguration.CLOSE_BRACKET) {
            parserState.stage = ParsingStage.START;
            handler.onOtherXML(other: parserState.elementCData!);
            parserState.elementCData = nil
            return;
            
        }
        
        if (parserState.elementCData == nil) {
            parserState.elementCData = ""
        }
        
        parserState.elementCData?.append(c)
        
        if ((parserState.elementCData?.count)! > ParserConfiguration.CDATA_MAX_SIZE) {
            parserState.stage = ParsingStage.ERROR;
            parserState.errorMessage = "Max cdata size exceeded: " + String(ParserConfiguration.CDATA_MAX_SIZE) + "\nreceived: "
                + parserState.elementCData!
            parserState.errorType =  ParserStateError.ELEMENT_VALUE_SIZE_LIMIT_EXCEEDED
        }
    }
    
    private func entity( parserState:ParserState,  c:Character) {
        let s = String(c).unicodeScalars
        let letters = CharacterSet.letters
        let digits = CharacterSet.decimalDigits
        let alpha = letters.contains(s[s.startIndex])
        let numeric = digits.contains(s[s.startIndex])
        
        var valid = true;
        
        switch (parserState.entityType) {
        case Entity.UNKNOWN:
            if (alpha) {
                parserState.entityType = Entity.NAMED;
            } else if (c == ParserConfiguration.HASH) {
                parserState.entityType = Entity.CODEPOINT;
            } else {
                valid = false;
            }
            break;
        case Entity.NAMED:
            if (!(alpha || numeric)) {
                if (c != ParserConfiguration.SEMICOLON){
                    valid = false
                }
                else{
                    parserState.stage = parserState.prevStage
                }
            }
            break;
        case Entity.CODEPOINT:
            let x:Character = "x"
            if (c == x) {
                parserState.entityType = Entity.CODEPOINT_HEX;
            }
            if (numeric) {
                parserState.entityType = Entity.CODEPOINT_DEC;
            } else {
                valid = false;
            }
            break;
        case Entity.CODEPOINT_DEC:
            if (!numeric) {
                if (c != ParserConfiguration.SEMICOLON){
                    valid = false
                }
                else{
                    parserState.stage = parserState.prevStage
                }
            }
            break;
        case Entity.CODEPOINT_HEX:
            let hexArray:[Character] = ["a","b","c","d","e","f","A","B","C","D","E","F"]
            if (hexArray.contains(c) || numeric) {
                if (c != ParserConfiguration.SEMICOLON){
                    valid = false
                }
                else{
                    parserState.stage = parserState.prevStage
                }
            }
            break
        }
        
        if (valid) {
            switch (parserState.prevStage!) {
            case ParsingStage.START_ATTR_VALUE_DQ: break
            case ParsingStage.START_ATTR_VALUE_SQ:
                parserState.attributeValues[parserState.curAttrIndex].append(c);
                break
            case ParsingStage.START_CDATA:
                parserState.elementCData?.append(c)
                break
            case ParsingStage.ELEMENT_TEXT:
                parserState.elementCData?.append(c)
                break
            default:
                break
            }
        } else {
            parserState.stage = ParsingStage.ERROR;
            parserState.errorMessage = "Invalid XML entity";
            parserState.errorType =  ParserStateError.INVALID_ENTITY
        }
    }
    
    
    private func startElementValue( handler:ParseEventHandler,  parserState:ParserState, c:Character) {
        if (c == ParserConfiguration.OPEN_BRACKET) {
            parserState.stage = ParsingStage.OPEN_BRACKET;
            parserState.slashFound = false;
            
            if (parserState.elementCData != nil) {
                handler.onElementText(text: parserState.elementCData!);
                parserState.elementCData = nil;
            }
            
        } else {
            
            if (parserState.elementCData == nil) {
                parserState.elementCData =  ""
            }
            
            parserState.elementCData?.append(c)
            if (c == "&") {
                parserState.prevStage = parserState.stage;
                parserState.stage = ParsingStage.ENTITY;
                parserState.entityType = Entity.UNKNOWN;
            }
            
            if ((parserState.elementCData?.count)! > ParserConfiguration.CDATA_MAX_SIZE) {
                parserState.stage = ParsingStage.ERROR;
                parserState.errorMessage = "Max cdata size exceeded: " + String(ParserConfiguration.CDATA_MAX_SIZE) + "\nreceived: "
                    + parserState.elementCData!
                parserState.errorType =   ParserStateError.ELEMENT_VALUE_SIZE_LIMIT_EXCEEDED
            }
        }
    }
    
    private func startCDataSection( handler:ParseEventHandler,  parserState:ParserState, c:Character) {
        if (c == ParserConfiguration.OPEN_BRACKET) {
            parserState.stage = ParsingStage.OPEN_BRACKET;
            parserState.slashFound = false;
            
            if (parserState.elementCData != nil) {
                handler.onElementCData(cdata: parserState.elementCData!);
                parserState.elementCData = nil;
            }
            
        } else {
            if (parserState.elementCData == nil) {
                parserState.elementCData = ""
            }
            
            parserState.elementCData?.append(c)
            if (c == ParserConfiguration.AMP) {
                parserState.prevStage = parserState.stage;
                parserState.stage = ParsingStage.ENTITY;
                parserState.entityType = Entity.UNKNOWN;
            }
            
            if ((parserState.elementCData?.count)! > ParserConfiguration.CDATA_MAX_SIZE) {
                parserState.stage = ParsingStage.ERROR;
                parserState.errorMessage = "Max cdata size exceeded: " + String(ParserConfiguration.CDATA_MAX_SIZE) + "\nreceived: "
                    + parserState.elementCData!
                parserState.errorType =  ParserStateError.ELEMENT_VALUE_SIZE_LIMIT_EXCEEDED
            }
        }
    }
    
    
    
    private func startElementCData(handler:ParseEventHandler,  parserState:ParserState, c:Character) {
        parserState.cDataBoundaryCharIndex += 1;
        
        if (c == ParserConfiguration.CDATA_START[parserState.cDataBoundaryCharIndex]) {
            if (parserState.cDataBoundaryCharIndex == 8) {
                parserState.stage = ParsingStage.START_CDATA_CONTENT;
                parserState.elementCData =  ""
                parserState.cDataBoundaryCharIndex = -1;
                return;
            }
            
        } else {
            parserState.stage = ParsingStage.ERROR;
        }
    }
    
    private func startCDataContent(handler:ParseEventHandler,  parserState:ParserState, c:Character) {
        if (c == "]") {
            parserState.stage = ParsingStage.END_CDATA;
        } else {
            parserState.elementCData?.append(c);
        }
    }
    
    private func endCDataContent(handler:ParseEventHandler,  parserState:ParserState, c:Character) {
        if (c == "]") {
            return;
        } else if (c == ">") {
            parserState.stage = ParsingStage.ELEMENT_TEXT;
            handler.onElementCData(cdata: parserState.elementCData!);
            parserState.elementCData = nil;
        } else {
            parserState.stage = ParsingStage.ERROR;
        }
    }
    
    private func startAttributeValueDQ(parserState:ParserState, c:Character) {
        if (c == ParserConfiguration.DOUBLE_QUOTE) {
            parserState.stage = ParsingStage.END_ELEMENT_NAME;
            
            return;
        }
        
        parserState.attributeValues[parserState.curAttrIndex].append(c);
        
        switch (c) {
        case ParserConfiguration.AMP:
            parserState.prevStage = parserState.stage;
            parserState.stage = ParsingStage.ENTITY;
            parserState.entityType = Entity.UNKNOWN;
            break;
        case ParserConfiguration.OPEN_BRACKET:
            parserState.stage = ParsingStage.ERROR;
            parserState.errorMessage = "Not allowed character in element attribute value: " + String(c)
                + "\nExisting characters in element attribute value: "
                + parserState.attributeValues[parserState.curAttrIndex]
            parserState.errorType =  ParserStateError.CHAR_NOT_ALLOWED
            break;
        default:
            break;
        }
        
        if (parserState.attributeValues[parserState.curAttrIndex].count > ParserConfiguration.ATTR_VALUE_MAX_LENGTH) {
            parserState.stage = ParsingStage.ERROR;
            parserState.errorMessage = "Max attribute value size exceeded: " + String(ParserConfiguration.ATTR_VALUE_MAX_LENGTH ) + "\nreceived: "
                + parserState.attributeValues[parserState.curAttrIndex]
            parserState.errorType = ParserStateError.ATTR_VALUE_LENGTH_LIMIT_EXCEEDED
        }
    }
    
    private func startAttributeValueSQ( parserState:ParserState, c:Character) {
        if (c == ParserConfiguration.SINGLE_QUOTE) {
            parserState.stage = ParsingStage.END_ELEMENT_NAME;
            
            return;
        }
        
        parserState.attributeValues[parserState.curAttrIndex].append(c);
        
        switch (c) {
        case ParserConfiguration.AMP:
            parserState.prevStage = parserState.stage;
            parserState.stage = ParsingStage.ENTITY;
            parserState.entityType = Entity.UNKNOWN;
            break;
        case ParserConfiguration.OPEN_BRACKET:
            parserState.stage = ParsingStage.ERROR;
            parserState.errorMessage = "Not allowed character in element attribute value: " + String(c)
                + "\nExisting characters in element attribute value: "
                + parserState.attributeValues[parserState.curAttrIndex]
            parserState.errorType = ParserStateError.CHAR_NOT_ALLOWED
            break;
        default:
            break;
        }
        
        if (parserState.attributeValues[parserState.curAttrIndex].count > ParserConfiguration.ATTR_VALUE_MAX_LENGTH) {
            parserState.stage = ParsingStage.ERROR;
            parserState.errorMessage = "Max attribute value size exceeded: " + String(ParserConfiguration.ATTR_VALUE_MAX_LENGTH) + "\nreceived: "
                + parserState.attributeValues[parserState.curAttrIndex]
            parserState.errorType = ParserStateError.ATTR_VALUE_LENGTH_LIMIT_EXCEEDED
        }
    }
    
    private func endAttributeName( parserState:ParserState, c:Character) {
        if (c == ParserConfiguration.SINGLE_QUOTE) {
            parserState.stage = ParsingStage.START_ATTR_VALUE_SQ;
            parserState.attributeValues.insert("", at: parserState.curAttrIndex)
        }
        
        if (c == ParserConfiguration.DOUBLE_QUOTE) {
            parserState.stage = ParsingStage.START_ATTR_VALUE_DQ;
            parserState.attributeValues.insert("", at: parserState.curAttrIndex)
        }
    }
    
    private func startAttributeName( parserState:ParserState, c:Character) {
        if (CharUtils.isWhiteChar(c: c) || (c == ParserConfiguration.EQUALS)) {
            parserState.stage = ParsingStage.END_ATTR_NAME;
            
            return;
        }
        
        if ((c == ParserConfiguration.ERR_NAME_CHARS[0]) || (c == ParserConfiguration.ERR_NAME_CHARS[1]) || (c == ParserConfiguration.ERR_NAME_CHARS[2])) {
            parserState.stage = ParsingStage.ERROR;
            parserState.errorMessage = "Not allowed character in element attribute name: " + String(c)
                + "\nExisting characters in element attribute name: "
                + parserState.attributeNames[parserState.curAttrIndex]
            parserState.errorType = ParserStateError.CHAR_NOT_ALLOWED
            return;
        }
        
        parserState.attributeNames[parserState.curAttrIndex].append(c);
        
        if (parserState.attributeNames[parserState.curAttrIndex].count > ParserConfiguration.ATTR_NAME_MAX_LENGTH) {
            parserState.stage = ParsingStage.ERROR;
            parserState.errorMessage = "Max attribute name size exceeded: " + String(ParserConfiguration.ATTR_NAME_MAX_LENGTH) + "\nreceived: "
                + parserState.attributeNames[parserState.curAttrIndex]
            parserState.errorType = ParserStateError.ATTR_COUNT_LIMIT_EXCEEDED
        }
    }
    
    private func endElementName(handler:ParseEventHandler,  parserState:ParserState,  c:Character) {
        if (c == ParserConfiguration.SLASH) {
            parserState.slashFound = true;
            return;
        }
        
        if (c == ParserConfiguration.CLOSE_BRACKET) {
            parserState.stage = ParsingStage.ELEMENT_TEXT;
            handler.onStartElement(name: parserState.elementName!, attr_names: parserState.attributeNames, attr_values: parserState.attributeValues);
            parserState.attributeNames = [];
            parserState.attributeValues = [];
            parserState.curAttrIndex = -1;
            
            if (parserState.slashFound) {
                _ = handler.onEndElement(name: parserState.elementName!);
            }
            
            parserState.elementName = nil;
            
            return;
        }
        
        if (!CharUtils.isWhiteChar(c: c)) {
            parserState.stage = ParsingStage.START_ATTR_NAME;
            
            if (parserState.attributeNames == nil) {
                parserState.attributeNames = []
                parserState.attributeValues = []
            } else {
                if (parserState.curAttrIndex == parserState.attributeNames.count - 1) {
                    if (parserState.attributeNames.count >= ParserConfiguration.MAX_ATTR_COUNT) {
                        parserState.stage = ParsingStage.ERROR;
                        parserState.errorMessage = "Attributes nuber limit exceeded: " + String(describing:ParserConfiguration.MAX_ATTR_COUNT) + "\nreceived: " + parserState.elementName!
                        parserState.errorType =  ParserStateError.ATTR_COUNT_LIMIT_EXCEEDED
                        return;
                    } else {
                        let new_size = parserState.attributeNames.count + ParserConfiguration.ATTR_BLOCK_SIZE;
                        parserState.attributeNames = ArrayUtils.resizeArray(src: parserState.attributeNames, size: new_size);
                        parserState.attributeValues = ArrayUtils.resizeArray(src: parserState.attributeValues, size: new_size);
                    }
                }
            }
            parserState.curAttrIndex = parserState.curAttrIndex + 1
            print(parserState.curAttrIndex)
            parserState.attributeNames.insert("",at:parserState.curAttrIndex)
            parserState.attributeNames[parserState.curAttrIndex].append(c);
        }
    }
    
    private func closeElement(handler:ParseEventHandler,  parserState:ParserState,  c:Character) {
        if (CharUtils.isWhiteChar(c: c)) {
            return;
        }
        
        if (c == ParserConfiguration.SLASH) {
            parserState.stage = ParsingStage.ERROR;
            parserState.errorMessage = "Not allowed character in close element name: " + String(c)
                + "\nExisting characters in close element name: " + parserState.elementName!
            parserState.errorType = ParserStateError.CHAR_NOT_ALLOWED
            return;
        }
        
        if (c == ParserConfiguration.CLOSE_BRACKET) {
            parserState.stage = ParsingStage.ELEMENT_TEXT;
            if (!handler.onEndElement(name: parserState.elementName!)) {
                parserState.stage = ParsingStage.ERROR;
                parserState.errorMessage = "Malformed XML: element close found without open for this element: " + parserState.elementName!
                parserState.errorType = ParserStateError.CLOSE_ELEMENT_BEFORE_OPEN
                return;
            }
            parserState.elementName = nil
            return;
        }
        
        if ((c == ParserConfiguration.ERR_NAME_CHARS[0]) || (c == ParserConfiguration.ERR_NAME_CHARS[1]) || (c == ParserConfiguration.ERR_NAME_CHARS[2])) {
            parserState.stage = ParsingStage.ERROR;
            parserState.errorMessage = "Not allowed character in close element name: " + String(c)
                + "\nExisting characters in close element name: " + parserState.elementName!
            parserState.errorType = ParserStateError.CHAR_NOT_ALLOWED
            return;
        }
        
        parserState.elementName?.append(c)
        
        if ((parserState.elementName?.count)! > ParserConfiguration.ELM_NAME_MAX_LENGTH) {
            parserState.stage = ParsingStage.ERROR;
            parserState.errorMessage = "Max element name size exceeded: " + String(ParserConfiguration.ELM_NAME_MAX_LENGTH) + "\nreceived: "
                + parserState.elementName!
            parserState.errorType =  ParserStateError.ELEMENT_NAME_SIZE_LIMIT_EXCEEDED
        }
    }
    
    private func startElementNameStage( handler:ParseEventHandler,  parserState:ParserState,  c:Character) {
        if (CharUtils.isWhiteChar(c: c)) {
            parserState.stage = ParsingStage.END_ELEMENT_NAME;
            
            return;
        }
        
        if (c == ParserConfiguration.SLASH) {
            parserState.slashFound = true;
            
            return;
        }
        
        if (c == ParserConfiguration.CLOSE_BRACKET) {
            parserState.stage = ParsingStage.ELEMENT_TEXT;
            handler.onStartElement(name: parserState.elementName!, attr_names: nil, attr_values: nil);
            
            if (parserState.slashFound) {
                _ = handler.onEndElement(name: parserState.elementName!);
            }
            
            parserState.elementName = nil;
            
            return;
        }
        
        if ((c == ParserConfiguration.ERR_NAME_CHARS[0]) || (c == ParserConfiguration.ERR_NAME_CHARS[1]) || (c == ParserConfiguration.ERR_NAME_CHARS[2])) {
            parserState.stage = ParsingStage.ERROR;
            parserState.errorMessage = "Not allowed character in start element name: " + String(c)
                + "\nExisting characters in start element name: " + parserState.elementName!
            parserState.errorType =  ParserStateError.CHAR_NOT_ALLOWED
            
            return;
        }
        
        parserState.elementName?.append(c)
        
        if ((parserState.elementName?.count)! > ParserConfiguration.ELM_NAME_MAX_LENGTH) {
            parserState.stage = ParsingStage.ERROR;
            parserState.errorMessage = "Max element name size exceeded: " + String(ParserConfiguration.ELM_NAME_MAX_LENGTH) + "\nreceived: "
                + parserState.elementName!
            parserState.errorType = ParserStateError.ELEMENT_NAME_SIZE_LIMIT_EXCEEDED
        }
    }
    
    private func handleOpenBracketStage( parserState:ParserState,  c:Character) {
        switch (c) {
        case ParserConfiguration.QUESTION_MARK:
            parserState.stage = ParsingStage.OTHER_XML
            parserState.elementCData =  ""
            parserState.elementCData?.append(c)
            
            break
        case ParserConfiguration.EXCLAMATION_MARK:
            parserState.stage = ParsingStage.START_CDATA
            parserState.elementCData =  ""
            parserState.cDataBoundaryCharIndex = 1
            
            break
            
        case ParserConfiguration.SLASH:
            parserState.stage = ParsingStage.CLOSE_ELEMENT;
            parserState.elementName = ""
            parserState.slashFound = true;
            
            break;
            
        default:
            if !(ParserConfiguration.WHITE_CHARS.contains(c)) {
                if ((c == ParserConfiguration.ERR_NAME_CHARS[0]) || (c == ParserConfiguration.ERR_NAME_CHARS[1]) || (c == ParserConfiguration.ERR_NAME_CHARS[2])) {
                    parserState.stage = ParsingStage.ERROR;
                    parserState.errorMessage = "Not allowed character in start element name: " + String(c)
                    parserState.errorType = ParserStateError.CHAR_NOT_ALLOWED
                    break;
                }
                
                parserState.stage = ParsingStage.START_ELEMENT_NAME;
                parserState.elementName = ""
                parserState.elementName?.append(c)
            }
        }
    }
    
    
    
    
    public func getName<String>()->String {
        return "SwiftParser" as! String
    }
    
    
}
public  enum Entity {
    case NAMED
    
    case CODEPOINT
    
    case CODEPOINT_DEC
    
    case CODEPOINT_HEX
    
    case UNKNOWN
}

public enum ParsingStage {
    case START
    
    case OPEN_BRACKET
    
    case START_ELEMENT_NAME
    
    case END_ELEMENT_NAME
    
    case START_ATTR_NAME
    
    case END_ATTR_NAME
    
    case START_ATTR_VALUE_SQ
    
    case START_ATTR_VALUE_DQ
    
    case ELEMENT_TEXT
    
    case START_CDATA
    
    case START_CDATA_CONTENT
    
    case END_CDATA
    
    
    case OTHER_XML
    
    case CLOSE_ELEMENT
    
    case END_OF_ROOT
    
    case ENTITY
    
    case ERROR 
}
