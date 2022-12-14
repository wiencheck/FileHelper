//
//  File.swift
//  
//
//  Created by Adam Wienconek on 23/08/2022.
//

import Foundation

public extension FileHelper {
    
    struct Directory {
        
        public let rootDirectory: FileManager.SearchPathDirectory
        public var folder: String?
        
        public init(rootDirectory: FileManager.SearchPathDirectory, folder: String? = nil) {
            self.rootDirectory = rootDirectory
            self.folder = folder
        }
        
        public var url: URL {
            var url = FileManager.default.urls(for: rootDirectory, in: .userDomainMask)[0]
            if let folder = folder {
                url.appendPathComponent(folder, isDirectory: true)
            }
            return url
        }
        
        public var path: String { url.path }
        
    }
    
}

public extension FileHelper.Directory {
    
    static func documents(folder: String? = nil) -> Self {
        return .init(rootDirectory: .documentDirectory, folder: folder)
    }
    
    static func applicationSupport(folder: String? = nil) -> Self {
        return .init(rootDirectory: .applicationSupportDirectory, folder: folder)
    }
    
    static func caches(folder: String? = nil) -> Self {
        return .init(rootDirectory: .cachesDirectory, folder: folder)
    }
    
}
