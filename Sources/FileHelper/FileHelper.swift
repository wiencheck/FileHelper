import Foundation

public class FileHelper {
    
    /// Returns URL constructed from specified directory
    public class func getURL(for directory: FileManager.SearchPathDirectory, folder: String? = nil, filename: String? = nil, fileExtension: String? = nil) -> URL {
        guard var url = FileManager.default.urls(for: directory,
                                                 in: .userDomainMask).first else {
            fatalError("Could not create URL for specified directory!")
        }
        
        if let folder = folder {
            url.appendPathComponent(folder, isDirectory: true)
        }
        if let filename = filename {
            url.appendPathComponent(filename, isDirectory: false)
        }
        if let fileExtension = fileExtension {
            url.appendPathExtension(fileExtension)
        }
        return url
    }
        
    /// Store an encodable struct to the specified directory on disk
    ///
    /// - Parameters:
    ///   - object: the encodable struct to store
    ///   - directory: where to store the struct
    ///   - filename: what to name the file where the struct data will be stored
    
    @discardableResult
    public class func store<T: Encodable>(_ object: T,
                                    to directory: FileManager.SearchPathDirectory,
                                    folder: String? = nil,
                                    as filename: String,
                                    fileExtension: String? = nil) throws -> URL {
        var url = getURL(for: directory)
        if let folder = folder {
            url.appendPathComponent(folder, isDirectory: true)
            if !FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: false)
                print("Created folder named \(folder)")
            }
        }
        url.appendPathComponent(filename)
        if let fileExtension = fileExtension {
            url.appendPathExtension(fileExtension)
        }
        
        let data: Data
        if T.self == Data.self {
            data = object as! Data
        }
        else {
            data = try JSONEncoder().encode(object)
        }
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
        FileManager.default.createFile(atPath: url.path, contents: data)
        
        return url
    }
    
    /// Retrieve and convert a struct from a file on disk
    ///
    /// - Parameters:
    ///   - filename: name of the file where struct data is stored
    ///   - directory: FileManager.SearchPathDirectory where struct data is stored
    ///   - type: struct type (i.e. Message.self)
    /// - Returns: decoded struct model(s) of data
    public class func retrieve<T: Decodable>(_ filename: String,
                                       folder: String? = nil,
                                       fileExtension: String? = nil,
                                       from directory: FileManager.SearchPathDirectory) -> T? {
        let url = getURL(for: directory, folder: folder, filename: filename, fileExtension: fileExtension)
        
        guard let data = FileManager.default.contents(atPath: url.path) else {
            return nil
        }
        
        if T.self == Data.self {
            return data as? T
        }
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(T.self, from: data)
            return model
        } catch {
            print("*** Could not retrieve file named: \(filename), error: \(error)")
            return nil
        }
    }
    
    /// Remove all files at specified directory
    public class func clear(_ directory: FileManager.SearchPathDirectory,
                            folder: String? = nil) throws {
        let url = getURL(for: directory, folder: folder)
        
        var isFolder = ObjCBool(false)
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isFolder) else {
            print("Path does not exist")
            return
        }
        if isFolder.boolValue {
            try FileManager.default.removeItem(atPath: url.path)
        }
        else {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for fileUrl in contents {
                try FileManager.default.removeItem(at: fileUrl)
            }
        }
    }
    
    /// Remove specified file from specified directory
    public class func remove(_ filename: String,
                             folder: String? = nil,
                             fileExtension: String? = nil,
                             from directory: FileManager.SearchPathDirectory) throws {
        let url = getURL(for: directory,
                         folder: folder,
                         filename: filename,
                         fileExtension: fileExtension)
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("File does not exist at path: \(url.path)")
            return
        }
        try FileManager.default.removeItem(at: url)
    }
    
    /// Returns BOOL indicating whether file exists at specified directory with specified file name
    public class func fileExists(_ filename: String,
                                 folder: String? = nil,
                                 fileExtension: String? = nil,
                                 in directory: FileManager.SearchPathDirectory) -> Bool {
        let url = getURL(for: directory,
                         folder: folder,
                         filename: filename,
                         fileExtension: fileExtension)
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    public class func directoryExists(_ name: String,
                                      in directory: FileManager.SearchPathDirectory) -> (exists: Bool, isEmpty: Bool?) {
        let url = getURL(for: directory, folder: name)
        var isFolder = ObjCBool(false)
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isFolder),
              isFolder.boolValue,
              let contents = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil) else {
            return (false, nil)
        }
        return (true, contents.isEmpty)
    }
    
    public class func getContents(ofDirectory directory: FileManager.SearchPathDirectory,
                                  folder: String? = nil) throws -> [URL] {
        let url = getURL(for: directory, folder: folder)
        return try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
    }
    
    @available(*, unavailable)
    init() {}
    
}
