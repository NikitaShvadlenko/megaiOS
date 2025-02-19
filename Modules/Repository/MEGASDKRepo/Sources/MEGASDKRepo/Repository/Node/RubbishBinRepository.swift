import MEGASdk
import MEGADomain

public struct RubbishBinRepository: RubbishBinRepositoryProtocol {
    public static var newRepo: RubbishBinRepository {
        RubbishBinRepository(sdk: MEGASdk.sharedSdk)
    }

    private let sdk: MEGASdk

    private enum Constants {
        static let syncDebrisFolderName = "SyncDebris"
        static let syncDebrisNodePath = "//bin/SyncDebris"
    }

    public init(sdk: MEGASdk) {
        self.sdk = sdk
    }

    public func isSyncDebrisNode(_ node: NodeEntity) -> Bool {
        guard let syncDebrisNodes = syncDebrisNodes(), syncDebrisNodes.isNotEmpty else { return false }

        return isSyncDebrisChild(node)
    }

    private func isSyncDebrisChild(_ node: NodeEntity) -> Bool {
        guard let megaNode = node.toMEGANode(in: sdk),
              let path = sdk.nodePath(for: megaNode) else { return false }

        return path.hasPrefix(Constants.syncDebrisNodePath)
    }

    private func syncDebrisNodes() -> [NodeEntity]? {
        guard let rubbishNode = sdk.rubbishNode else { return nil }

        return sdk.children(forParent: rubbishNode)
            .toNodeArray()
            .filter {
                $0.name == Constants.syncDebrisFolderName && $0.isFolder()
            }.toNodeEntities()
    }
}
