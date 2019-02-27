
#import "NSError+CameraUpload.h"

NSString * const CameraUploadErrorDomain = @"nz.mega.cameraUpload";

@implementation NSError (CameraUpload)

+ (NSError *)mnz_cameraUploadNoEnoughDiskSpaceError {
    return [NSError errorWithDomain:CameraUploadErrorDomain code:CameraUploadErrorNoEnoughDiskFreeSpace userInfo:@{NSLocalizedDescriptionKey : @"no enough disk free space on device"}];
}

+ (NSError *)mnz_cameraUploadBackgroundTaskExpiredError {
    return [NSError errorWithDomain:CameraUploadErrorDomain code:CameraUploadErrorBackgroundTaskExpired userInfo:@{NSLocalizedDescriptionKey : @"background task is expired"}];
}

+ (NSError *)mnz_cameraUploadOperationCancelledError {
    return [NSError errorWithDomain:CameraUploadErrorDomain code:CameraUploadErrorOperationCancelled userInfo:@{NSLocalizedDescriptionKey : @"operation gets cancelled"}];
}

+ (NSError *)mnz_cameraUploadEncryptionCancelledError {
    return [NSError errorWithDomain:CameraUploadErrorDomain code:CameraUploadErrorEncryptionCancelled userInfo:@{NSLocalizedDescriptionKey : @"encryption gets cancelled"}];
}

+ (NSError *)mnz_cameraUploadNodeIsNotFoundError {
    return [NSError errorWithDomain:CameraUploadErrorDomain code:CameraUploadErrorCameraUploadNodeIsNotFound userInfo:@{NSLocalizedDescriptionKey : @"camera upload node is not found"}];
}

+ (NSError *)mnz_cameraUploadChunkMissingError {
    return [NSError errorWithDomain:CameraUploadErrorDomain code:CameraUploadErrorChunksMissing userInfo:@{NSLocalizedDescriptionKey : @"file chunk is not found"}];
}

+ (NSError *)mnz_cameraUploadNoWritePermissionErrorForFileURL:(NSURL *)URL {
    return [NSError errorWithDomain:CameraUploadErrorDomain code:CameraUploadErrorNoFileWritePermission userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"no write permission for file %@", URL]}];
}

+ (NSError *)mnz_cameraUploadEncryptionErrorForFileURL:(NSURL *)URL {
    return [NSError errorWithDomain:CameraUploadErrorDomain code:CameraUploadErrorEncryptionFailed userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"error occurred when to encrypt file URL %@", URL]}];
}

+ (NSError *)mnz_cameraUploadDataTransferErrorWithUserInfo:(NSDictionary *)userInfo {
    return [NSError errorWithDomain:CameraUploadErrorDomain code:CameraUploadErrorDataTransfer userInfo:userInfo];
}

@end
