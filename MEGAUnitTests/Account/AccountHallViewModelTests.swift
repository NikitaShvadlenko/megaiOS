import XCTest
@testable import MEGA
import MEGADomain
import MEGADomainMock

final class AccountHallViewModelTests: XCTestCase {
    var accountHallUseCase: MockAccountHallUseCase!
    
    override func setUp() {
        super.setUp()
        accountHallUseCase = MockAccountHallUseCase()
    }
    
    func testAction_startOrJoinCallCleanUp_callCleanUp() {
        let sut = AccountHallViewModel(accountHallUsecase: accountHallUseCase)
        
        test(viewModel: sut, actions: [AccountHallAction.onViewAppear], expectedCommands: [AccountHallViewModel.Command.reload])
    }
    
    func testAction_didTapUpgradeButton_showUpgradeView() {
        let sut = AccountHallViewModel(accountHallUsecase: accountHallUseCase)
        
        test(viewModel: sut, actions: [AccountHallAction.didTapUpgradeButton], expectedCommands: [])
    }
    
    func testIsFeatureFlagEnabled_onNewUpgradeAccountPlanUI_shouldBeEnabled() {
        let sut = AccountHallViewModel(accountHallUsecase: accountHallUseCase, featureFlagProvider: MockFeatureFlagProvider(list: [.newUpgradeAccountPlanUI: true]))
        XCTAssertTrue(sut.isNewUpgradeAccountPlanEnabled())
    }

    func testIsFeatureFlagEnabled_onOtherToggles_shouldBeTurnedOff() {
        let sut = AccountHallViewModel(accountHallUsecase: accountHallUseCase, featureFlagProvider: MockFeatureFlagProvider(list: [.newUpgradeAccountPlanUI: false]))
        XCTAssertFalse(sut.isNewUpgradeAccountPlanEnabled())
    }
}
