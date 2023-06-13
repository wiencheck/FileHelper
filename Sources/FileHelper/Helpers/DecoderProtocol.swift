//
//  File.swift
//  
//
//  Created by Adam Wienconek on 13/06/2023.
//

import Foundation

public protocol DecoderProtocol {
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
    
}

extension JSONDecoder: DecoderProtocol {}
