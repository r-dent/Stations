//
//  XMLTransform.swift
//  Stations
//
//  Created by Roman Gille on 17.12.19.
//  Copyright © 2019 Roman Gille. All rights reserved.
//

import Foundation

class XMLTransform: NSObject, XMLParserDelegate {

    var error: Error?
    var builderStack: [XMLNode.Builder] = []

    func document(with data: Data) -> XMLNode? {
        builderStack = []
        error = nil

        // Parse the XML
        let parser = XMLParser(data: data)
        parser.delegate = self

        // Return the stack’s root on success
        if parser.parse(){
            return builderStack.first?.node
        }

        return nil
    }

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {

        let builder = XMLNode.Builder()
            .set(name: elementName)
            .set(attributes: attributeDict)
        builderStack.append(builder)
    }

    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {

        if
            builderStack.count > 1,
            let finishedElement = builderStack.popLast()?.node,
            var siblings = builderStack.last?.node.children
        {
            siblings.append(finishedElement)
            builderStack.last?.set(children: siblings)
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        var text = builderStack.last?.node.text ?? ""
        text.append(string)
        builderStack.last?.set(text: text)
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.error = parseError
        print(parseError)
    }
}
