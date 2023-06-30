import AVFoundation
import Contacts
import Photos
import UserNotifications

// This protocol abstracts the interface of requesting permissions and checking
// permission status for device permissions that application needs to offer all the
// features to the user
// Those permissions are:
//   1. reading contact list
//   2. access to microphone
//   3. access to camera
//   4. access to read write into photo album
//   5. permission to send and present remote push notifications to the user
//
// note:
// This pure Swift API, for classes using ObjC,
// there is a simplified wrapper: DevicePermissionHandlerObjCWrapper
// so please use it instead of exposing any of this to ObjC,
// but better still, convert code you touch to Swift
public protocol DevicePermissionsHandling {
    
    // request read/write access level (do not use level directly, use .MEGAAccessLevel) to user's photo library
    // should return true if user given full or partial access
    // (.authorized or .limited)
    func requestPhotoLibraryAccessPermissions() async -> Bool
    
    // request access to capture media, we are only using .video and .audio
    // uses AVCaptureDevice
    func requestPermission(for mediaType: AVMediaType) async -> Bool
    
    // request access to user's contact list, using CNContactStore
    func requestContactsPermissions() async -> Bool
    
    // requsts from UNUserNotificationCenter permission to send badge and sound notifications
    func requestNotificationsPermission() async -> Bool
    
    // checks currrent status of authorization to user's photo library
    var photoLibraryAuthorizationStatus: PHAuthorizationStatus { get }
    
    // checks current authorization to microphone
    var audioPermissionAuthorizationStatus: AVAuthorizationStatus { get }
    
    // checks if access to camera is .authorized
    var isVideoPermissionAuthorized: Bool { get }
    
    // returns current status of the app to user's contact list
    var contactsAuthorizationStatus: CNAuthorizationStatus { get }
    
    // checks current status of permission to send push notifications to user
    // with badge and sound
    func notificationPermissionStatus() async -> UNAuthorizationStatus
    
    // returns true if microphone permission status is not determined (app needs/can to ask for permission)
    // false in any other case
    var shouldAskForAudioPermissions: Bool { get }
    
    // returns true if video permission status is not determined (app needs/can to ask for permission)
    // false in any other case
    var shouldAskForVideoPermissions: Bool { get }
    
    // returns true if photo library permission status is not determined (app needs/can to ask for permission)
    // false in any other case
    var shouldAskForPhotosPermissions: Bool { get }
    
    // returns true if user's contact list permission status is not determined (app needs/can to ask for permission)
    // false in any other case
    var shouldAskForContactsPermissions: Bool { get }
    
    // returns true if permission status to push notifications is not determined
    // returns false for any other case
    func shouldAskForNotificationPermission() async -> Bool
    
    // returns true if photo library access is fully authorized (read write)
    var hasAuthorizedAccessToPhotoAlbum: Bool { get }
}

// Extension below contains closure - based of async API's defined in the core protocol
public extension DevicePermissionsHandling {
    
    private func request(
        asker: @escaping () async -> Bool,
        handler: @escaping (Bool) -> Void
    ) {
        Task { @MainActor in 
            let granted = await asker()
            handler(granted)
        }
    }
    
    func requestAudioPermission(handler: @escaping (Bool) -> Void = { _ in }) {
        requestMediaPermission(mediaType: .audio, handler: handler)
    }
    
    func requestVideoPermission(handler: @escaping (Bool) -> Void = { _ in }) {
        requestMediaPermission(mediaType: .video, handler: handler)
    }
    
    private func requestMediaPermission(mediaType: AVMediaType, handler: @escaping (Bool) -> Void) {
        request(asker: { await requestPermission(for: mediaType) }, handler: handler)
    }
    
    func photosPermissionWithCompletionHandler(handler: @escaping (Bool) -> Void) {
        request(asker: { await requestPhotoLibraryAccessPermissions() }, handler: handler)
    }
    
    func contactsPermissionWithCompletionHandler(handler: @escaping (Bool) -> Void) {
        request(asker: { await requestContactsPermissions() }, handler: handler)
    }
    
    func notificationsPermission(with handler: @escaping (Bool) -> Void) {
        request(asker: { await requestNotificationsPermission() }, handler: handler)
    }
    
    func shouldAskForNotificationsPermissions(handler: @escaping (Bool) -> Void) {
        request(asker: { await shouldAskForNotificationPermission() }, handler: handler)
    }
        
    func notificationsPermissionsStatusDenied(handler: @escaping (Bool) -> Void) {
        request(asker: { await notificationPermissionStatus() == .denied }, handler: handler)
    }
}

public extension DevicePermissionsHandling {
    // aggregate method that checks if any permission needs to be requested
    func shouldSetupPermissions() async -> Bool {
        
        let shouldAskForAudioPermissions = shouldAskForAudioPermissions
        let shouldAskForVideoPermissions = shouldAskForVideoPermissions
        let shouldAskForPhotosPermissions = shouldAskForPhotosPermissions
        let shouldAskForContactsPermissions = shouldAskForContactsPermissions
        
        return (
            await shouldAskForNotificationPermission() ||
            shouldAskForAudioPermissions ||
            shouldAskForVideoPermissions ||
            shouldAskForPhotosPermissions ||
            shouldAskForContactsPermissions
        )
    }
    
    var hasContactsAuthorization: Bool {
        contactsAuthorizationStatus == .authorized
    }
    
    var isAudioPermissionAuthorized: Bool {
        switch audioPermissionAuthorizationStatus {
        case .notDetermined:
            return false
        case .restricted, .denied:
            return false
        default:
            return true
        }
    }
    
    var isPhotoLibraryAccessProhibited: Bool {
        let status = photoLibraryAuthorizationStatus
        return status == .restricted || status == .denied
    }
}
