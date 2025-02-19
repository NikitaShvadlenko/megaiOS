import Combine
import MEGADomain

final public class MockAccountPlanPurchaseUseCase: AccountPlanPurchaseUseCaseProtocol {
    private var accountPlanProducts: [AccountPlanEntity]
    private let _successfulRestorePublisher: PassthroughSubject<Void, Never>
    private let _incompleteRestorePublisher: PassthroughSubject<Void, Never>
    private let _failedRestorePublisher: PassthroughSubject<AccountPlanErrorEntity, Never>
    private let _purchasePlanResultPublisher: PassthroughSubject<Result<Void, AccountPlanErrorEntity>, Never>
    
    public var restorePurchaseCalled = 0
    public var purchasePlanCalled = 0
    public var registerRestoreDelegateCalled = 0
    public var deRegisterRestoreDelegateCalled = 0
    public var registerPurchaseDelegateCalled = 0
    public var deRegisterPurchaseDelegateCalled = 0
    
    public init(accountPlanProducts: [AccountPlanEntity] = [],
                successfulRestorePublisher: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>(),
                incompleteRestorePublisher: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>(),
                failedRestorePublisher: PassthroughSubject<AccountPlanErrorEntity, Never> = PassthroughSubject<AccountPlanErrorEntity, Never>(),
                purchasePlanResultPublisher: PassthroughSubject<Result<Void, AccountPlanErrorEntity>, Never> = PassthroughSubject<Result<Void, AccountPlanErrorEntity>, Never>()) {
        self.accountPlanProducts = accountPlanProducts
        _successfulRestorePublisher = successfulRestorePublisher
        _incompleteRestorePublisher = incompleteRestorePublisher
        _failedRestorePublisher = failedRestorePublisher
        _purchasePlanResultPublisher = purchasePlanResultPublisher
    }
    
    public func accountPlanProducts() async -> [AccountPlanEntity] {
        accountPlanProducts
    }
    
    public var successfulRestorePublisher: AnyPublisher<Void, Never> {
        _successfulRestorePublisher.eraseToAnyPublisher()
    }
    
    public var incompleteRestorePublisher: AnyPublisher<Void, Never> {
        _incompleteRestorePublisher.eraseToAnyPublisher()
    }
    
    public var failedRestorePublisher: AnyPublisher<AccountPlanErrorEntity, Never> {
        _failedRestorePublisher.eraseToAnyPublisher()
    }

    public func purchasePlanResultPublisher() -> AnyPublisher<Result<Void, AccountPlanErrorEntity>, Never> {
        _purchasePlanResultPublisher.eraseToAnyPublisher()
    }
    
    public func purchasePlan(_ plan: AccountPlanEntity) async {
        purchasePlanCalled += 1
    }
    
    public func restorePurchase() async {
        restorePurchaseCalled += 1
    }
    
    public func registerRestoreDelegate() async {
        registerRestoreDelegateCalled += 1
    }
    
    public func deRegisterRestoreDelegate() async {
        deRegisterRestoreDelegateCalled += 1
    }
    
    public func registerPurchaseDelegate() async {
        registerPurchaseDelegateCalled += 1
    }
    
    public func deRegisterPurchaseDelegate() async {
        deRegisterPurchaseDelegateCalled += 1
    }
}
