import Foundation

protocol FileCacheRepositoryProtocol {
    func tempFileURL(for node: NodeEntity) -> URL
    func existingTempFileURL(for node: NodeEntity) -> URL?
    
    var cachedOriginalImageDirectoryURL: URL { get }
    func cachedOriginalImageURL(for node: NodeEntity) -> URL
    func existingOriginalImageURL(for node: NodeEntity) -> URL?
    func cachedOriginalURL(for base64Handle: MEGABase64Handle, name: String) -> URL
    func tempUploadURL(for name: String) -> URL
    func cachedFileURL(for base64Handle: MEGABase64Handle, name: String) -> URL
    func offlineFileURL(name: String) -> URL
}