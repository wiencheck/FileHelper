//
//  File.swift
//  
//
//  Created by Adam Wienconek on 13/06/2023.
//

import Foundation

public protocol EncoderProtocol {
    
    func encode<T>(_ value: T) throws -> Data where T: Encodable
    
}

extension JSONEncoder: EncoderProtocol {}
