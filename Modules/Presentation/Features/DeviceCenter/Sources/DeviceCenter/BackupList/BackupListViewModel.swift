import Combine
import MEGADomain
import SwiftUI

public final class BackupListViewModel: ObservableObject {
    private let selectedDeviceId: String
    private let deviceCenterUseCase: any DeviceCenterUseCaseProtocol
    private let router: any BackupListRouting
    private let backupListAssets: BackupListAssets
    private let backupStatuses: [BackupStatus]
    private let devicesUpdatePublisher: PassthroughSubject<[DeviceEntity], Never>
    private let updateInterval: UInt64
    private(set) var backups: [BackupEntity]
    private var sortedBackupStatuses: [BackupStatusEntity: BackupStatus] {
        Dictionary(uniqueKeysWithValues: backupStatuses.map { ($0.status, $0) })
    }
    private var sortedBackupTypes: [BackupTypeEntity: BackupType] {
        Dictionary(uniqueKeysWithValues: backupListAssets.backupTypes.map { ($0.type, $0) })
    }
    private var backupsPreloaded: Bool = false
    
    var isFilteredBackupsEmpty: Bool {
        filteredBackups.isEmpty
    }
    
    var displayedBackups: [DeviceCenterItemViewModel] {
        isSearchActive && searchText.isNotEmpty ? filteredBackups : backupModels
    }
    
    @Published private(set) var backupModels: [DeviceCenterItemViewModel] = []
    @Published private(set) var filteredBackups: [DeviceCenterItemViewModel] = []
    @Published private(set) var emptyStateAssets: EmptyStateAssets
    @Published private(set) var searchAssets: SearchAssets
    @Published var isSearchActive: Bool
    @Published var searchText: String {
        didSet {
            filterBackups()
        }
    }
    
    init(
        selectedDeviceId: String,
        devicesUpdatePublisher: PassthroughSubject<[DeviceEntity], Never>,
        updateInterval: UInt64,
        deviceCenterUseCase: any DeviceCenterUseCaseProtocol,
        router: any BackupListRouting,
        backups: [BackupEntity],
        backupListAssets: BackupListAssets,
        emptyStateAssets: EmptyStateAssets,
        searchAssets: SearchAssets,
        backupStatuses: [BackupStatus]
    ) {
        self.selectedDeviceId = selectedDeviceId
        self.devicesUpdatePublisher = devicesUpdatePublisher
        self.updateInterval = updateInterval
        self.deviceCenterUseCase = deviceCenterUseCase
        self.router = router
        self.backups = backups
        self.backupListAssets = backupListAssets
        self.emptyStateAssets = emptyStateAssets
        self.searchAssets = searchAssets
        self.backupStatuses = backupStatuses
        self.isSearchActive = false
        self.searchText = ""
        
        loadBackupsInitialStatus()
    }
    
    private func loadBackupsInitialStatus() {
        loadBackupsModels()
        backupsPreloaded = true
    }
    
    private func resetFilteredBackups() {
        filteredBackups = backupModels
    }
    
    private func filterBackups() {
        let hasSearchQuery = searchText.isNotEmpty
        isSearchActive = hasSearchQuery
        if hasSearchQuery {
            resetFilteredBackups()
            filteredBackups = filteredBackups.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        } else {
            resetFilteredBackups()
        }
    }
    
    func updateDeviceStatusesAndNotify() async throws {
        while true {
            if Task.isCancelled { return }
            try await Task.sleep(nanoseconds: updateInterval * 1_000_000_000)
            if Task.isCancelled { return }
            await syncDevicesAndLoadBackups()
        }
    }
    
    func syncDevicesAndLoadBackups() async {
        let devices = await deviceCenterUseCase.fetchUserDevices()
        await filterAndLoadCurrentDeviceBackups(devices)
        devicesUpdatePublisher.send(devices)
    }
    
    @MainActor
    func filterAndLoadCurrentDeviceBackups(_ devices: [DeviceEntity]) {
        backups = devices.first {$0.id == selectedDeviceId}?.backups ?? []
        loadBackupsModels()
    }
    
    func loadBackupsModels() {
        backupModels = backups
            .compactMap { backup in
                if let assets = loadAssets(for: backup) {
                    return DeviceCenterItemViewModel(
                        itemType: .backup(backup),
                        assets: assets
                    )
                }
                return nil
            }
    }
    
    func loadAssets(for backup: BackupEntity) -> ItemAssets? {
        guard let backupStatus = backup.backupStatus,
              let status = sortedBackupStatuses[backupStatus],
              let backupType = sortedBackupTypes[backup.type] else {
            return nil
        }
        
        return ItemAssets(
            iconName: backupType.iconName,
            status: status
        )
    }
}
