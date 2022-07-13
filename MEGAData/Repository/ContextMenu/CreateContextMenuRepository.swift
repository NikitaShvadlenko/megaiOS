
struct CreateContextMenuRepository: CreateContextMenuRepositoryProtocol {
    func createContextMenu(config: CMConfigEntity) -> CMEntity? {
        ContextMenuBuilder()
                        .setType(config.menuType)
                        .setViewMode(config.viewMode)
                        .setAccessLevel(config.accessLevel)
                        .setSortType(config.sortType)
                        .setIsAFolder(config.isAFolder)
                        .setIsRubbishBinFolder(config.isRubbishBinFolder)
                        .setIsRestorable(config.isRestorable)
                        .setIsInVersionsView(config.isInVersionsView)
                        .setVersionsCount(config.versionsCount)
                        .setIsSharedItems(config.isSharedItems)
                        .setIsIncomingShareChild(config.isIncomingShareChild)
                        .setIsDocumentExplorer(config.isDocumentExplorer)
                        .setIsAudiosExplorer(config.isAudiosExplorer)
                        .setIsVideosExplorer(config.isVideosExplorer)
                        .setIsCameraUploadExplorer(config.isCameraUploadExplorer)
                        .setIsHome(config.isHome)
                        .setShowMediaDiscovery(config.showMediaDiscovery)
                        .setChatStatus(config.chatStatus)
                        .setIsDoNotDisturbEnabled(config.isDoNotDisturbEnabled)
                        .setTimeRemainingToDeactiveDND(config.timeRemainingToDeactiveDND)
                        .setIsShareAvailable(config.isShareAvailable)
                        .setIsSharedItemsChild(config.isSharedItemsChild)
                        .setIsOutShare(config.isOutShare)
                        .setIsExported(config.isExported)
                        .build()
    }
}