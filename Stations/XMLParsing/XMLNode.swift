//
//  XMLNode.swift
//  Stations
//
//  Created by Roman Gille on 17.12.19.
//  Copyright © 2019 Roman Gille. All rights reserved.
//

import Foundation

extension XMLTransform {

    struct XMLNode {

        private(set) var children: [XMLNode] = []
        private(set) var attributes: [String: Any] = [:]
        private(set) var text: String?
        private(set) var name: String = ""
        
        class Builder {

            private(set) var node = XMLNode()

            @discardableResult
            func set(children: [XMLNode] = []) -> Builder {
                node.children = children
                return self
            }

            @discardableResult
            func set(attributes: [String: Any] = [:]) -> Builder {
                node.attributes = attributes
                return self
            }

            @discardableResult
            func set(text: String?) -> Builder {
                node.text = text
                return self
            }

            @discardableResult
            func set(name: String) -> Builder {
                node.name = name
                return self
            }
        }
    }
}
