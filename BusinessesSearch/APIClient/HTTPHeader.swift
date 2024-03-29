//
//  HTTPHeader.swift
//  BusinessesSearch
//
//  Created by Sharaf Nazaar on 12/4/20.
//

import Foundation

public enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

public struct HTTPHeader {
    public var field: String
    public var value: String
    
    public init(field: HTTPHeaderField, value: String) {
        self.field = field.rawValue
        self.value = value
    }
    
    public init(field: String, value: String) {
        self.field = field
        self.value = value
    }
}


public extension URLRequest {
    mutating func add(header: HTTPHeader) {
        self.addValue(header.value, forHTTPHeaderField: header.field)
    }
}
