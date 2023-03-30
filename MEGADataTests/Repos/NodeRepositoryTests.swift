import XCTest
import MEGADomainMock
import MEGADomain
@testable import MEGA

final class NodeRepositoryTests: XCTestCase {
    let rootNode = MockNode(handle: 1, nodeType: .folder)
    var repository: NodeRepository!
    var sdk: MockSdk!
    
    override func setUp() {
        super.setUp()
        
        sdk = MockSdk(megaRootNode: rootNode)
        repository = NodeRepository(sdk: sdk, sharedFolderSdk: MockSdk(), chatSdk: MockChatSDK())
    }
    
    func testParentTreeArray_severalFolderLevels() async {
        let grandParentNode = await MockNode(handle: 2, nodeType: .folder, parentHandle: 1)
        let parentNode = await MockNode(handle: 3, nodeType: .folder, parentHandle: 2)
        let childNode = await MockNode(handle: 4, nodeType: .file, parentHandle: 3)
    
        sdk.setNodes([rootNode, grandParentNode, parentNode, childNode])
        sdk.setShareAccessLevel(.accessOwner)
        
        let childNodeParentTreeArray = await repository?.parents(of: childNode.toNodeEntity())
        XCTAssertEqual(childNodeParentTreeArray, [grandParentNode, parentNode].toNodeEntities())
        
        let parentNodeParentTreeArray = await repository?.parents(of: parentNode.toNodeEntity())
        XCTAssertEqual(parentNodeParentTreeArray, [grandParentNode, parentNode].toNodeEntities())
        
        let grandParentNodeParentTreeArray = await repository?.parents(of: grandParentNode.toNodeEntity())
        XCTAssertEqual(grandParentNodeParentTreeArray, [grandParentNode.toNodeEntity()])
    }
    
    func testParentTreeArray_rootNodeChild_file() async {
        let rootNodeChild = await MockNode(handle: 5, nodeType: .file, parentHandle: 1)
        
        sdk.setNodes([rootNode, rootNodeChild])
        sdk.setShareAccessLevel(.accessOwner)
        
        let rootNodeParentTreeArray = await repository?.parents(of: rootNodeChild.toNodeEntity())
        XCTAssertTrue(rootNodeParentTreeArray?.isEmpty ?? false)
    }
}
