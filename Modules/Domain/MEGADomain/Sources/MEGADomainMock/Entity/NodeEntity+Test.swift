import MEGADomain
import Foundation

public extension NodeEntity {
    init(changeTypes: ChangeTypeEntity = .attributes,
         nodeType: NodeTypeEntity? = nil,
         name: String = "",
         fingerprint: String? = nil,
         handle: HandleEntity = .invalid,
         base64Handle: String = "",
         restoreParentHandle: HandleEntity = .invalid,
         ownerHandle: HandleEntity = .invalid,
         parentHandle: HandleEntity = .invalid,
         isFile: Bool = false,
         isFolder: Bool = false,
         isRemoved: Bool = false,
         hasThumbnail: Bool = false,
         hasPreview: Bool = false,
         isPublic: Bool = false,
         isShare: Bool = false,
         isOutShare: Bool = false,
         isInShare: Bool = false,
         isExported: Bool = false,
         isExpired: Bool = false,
         isTakenDown: Bool = false,
         isFavourite: Bool = false,
         label: NodeLabelTypeEntity = .unknown,
         publicHandle: HandleEntity = .invalid,
         expirationTime: Date? = nil,
         publicLinkCreationTime: Date? = nil,
         size: UInt64 = .zero,
         creationTime: Date = Date(),
         modificationTime: Date = Date(),
         width: Int = .zero,
         height: Int = .zero,
         shortFormat: Int = .zero,
         codecId: Int = .zero,
         duration: Int = .zero,
         mediaType: MediaTypeEntity? = nil,
         latitude: Double? = nil,
         longitude: Double? = nil,
         isTesting: Bool = true,
         deviceId: String? = nil) {
        self.init(
            changeTypes: changeTypes,
            nodeType: nodeType,
            name: name,
            fingerprint: fingerprint,
            handle: handle,
            base64Handle: base64Handle,
            restoreParentHandle: restoreParentHandle,
            ownerHandle: ownerHandle,
            parentHandle: parentHandle,
            isFile: isFile,
            isFolder: isFolder,
            isRemoved: isRemoved,
            hasThumbnail: hasThumbnail,
            hasPreview: hasPreview,
            isPublic: isPublic,
            isShare: isShare,
            isOutShare: isOutShare,
            isInShare: isInShare,
            isExported: isExported,
            isExpired: isExpired,
            isTakenDown: isTakenDown,
            isFavourite: isFavourite,
            label: label,
            publicHandle: publicHandle,
            expirationTime: expirationTime,
            publicLinkCreationTime: publicLinkCreationTime,
            size: size,
            creationTime: creationTime,
            modificationTime: modificationTime,
            width: width,
            height: height,
            shortFormat: shortFormat,
            codecId: codecId,
            duration: duration,
            mediaType: mediaType,
            latitude: latitude,
            longitude: longitude,
            deviceId: deviceId
        )
    }
}