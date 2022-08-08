@testable import MEGA
import MEGADomain

struct MockFileCacheRepository: FileCacheRepositoryProtocol {
    static let newRepo = MockFileCacheRepository()
    
    var base64Handle: Base64HandleEntity = ""
    var name: String = ""
    
    func tempFileURL(for node: NodeEntity) -> URL {
        URL(fileURLWithPath: "temp/" + name)
    }
    
    func existingTempFileURL(for node: NodeEntity) -> URL? {
        URL(fileURLWithPath: "temp/" + name)
    }
    
    var cachedOriginalImageDirectoryURL: URL {
        URL(fileURLWithPath: "originalV3/")
    }
    
    func cachedOriginalImageURL(for node: NodeEntity) -> URL {
        URL(fileURLWithPath: "originalV3/" + base64Handle)
    }
    
    func existingOriginalImageURL(for node: NodeEntity) -> URL? {
        URL(fileURLWithPath: "originalV3/" + base64Handle)
    }
    
    func cachedOriginalURL(for base64Handle: Base64HandleEntity, name: String) -> URL {
        URL(fileURLWithPath: "originalV3/" + self.base64Handle)
    }
    
    func tempUploadURL(for name: String) -> URL {
        URL(fileURLWithPath: "temp/" + self.name)
    }
    
    func tempURL(for base64Handle: Base64HandleEntity) -> URL {
        URL(fileURLWithPath: "temp/" + self.base64Handle)
    }

    func cachedFileURL(for base64Handle: Base64HandleEntity, name: String) -> URL {
        URL(fileURLWithPath: "Library/Caches/" + self.base64Handle)
    }
    
    func offlineFileURL(name: String) -> URL {
        URL(fileURLWithPath: "thumbnailsV3/" + self.name)
    }
}
