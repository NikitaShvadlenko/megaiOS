import UIKit

final class RegionListViewController: UIViewController, ViewType {
    // MARK: - Private properties
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "countryCell")
        table.delegate = self
        return table
    }()
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        return sc
    }()
    
    private var listSource: RegionListSource? {
        didSet {
            tableView.dataSource = listSource
            tableView.reloadData()
        }
    }
    
    private let viewModel: RegionListViewModel
    
    // MARK: - Init
    init(viewModel: RegionListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        
        viewModel.invokeCommand = { [weak self] command in
            DispatchQueue.main.async { self?.executeCommand(command) }
        }
        
        viewModel.dispatch(.onViewReady)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = false
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                if navigationController != nil {
                    AppearanceManager.forceNavigationBarUpdate(navigationController!.navigationBar, traitCollection: traitCollection)
                }
                AppearanceManager.forceSearchBarUpdate(searchController.searchBar, traitCollection: traitCollection)
                
                updateAppearance()
            }
        }
    }
    
    // MARK: - Config view
    private func configView() {
        title = AMLocalizedString("Choose Your Country")
        
        view.wrap(tableView)
        
        definesPresentationContext = true
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
            searchController.searchBar.barTintColor = .mnz_backgroundElevated(traitCollection)
        }
        
        updateAppearance()
    }
    
    private func updateAppearance() {
        tableView.sectionIndexColor = UIColor.mnz_turquoise(for: traitCollection)
        tableView.separatorColor = UIColor.mnz_separator(for: traitCollection)
    }
    
    // MARK: - Execute command
    func executeCommand(_ command: RegionListViewModel.Command) {
        switch command {
        case .reloadSearchedRegions(let regions):
            listSource = RegionListSearchSource(regions: regions)
        case let .reloadIndexedRegions(indexedRegions, collation):
            listSource = RegionListIndexedSource(indexedRegions: indexedRegions, collation: collation)
        }
    }
}

// MARK: - UITableViewDelegate
extension RegionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        func routeToSelectedRegion() {
            guard let region = listSource?.country(at: indexPath) else { return }
            viewModel.dispatch(.didSelectRegion(region))
        }
        
        if searchController.isActive {
            dismiss(animated: false) {
                routeToSelectedRegion()
            }
        } else {
            routeToSelectedRegion()
        }
    }
}

// MARK: - UISearchResultsUpdating
extension RegionListViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.trim else { return }
        viewModel.dispatch(.startSearching(searchText))
    }
}

// MARK: - UISearchControllerDelegate
extension RegionListViewController: UISearchControllerDelegate {
    func willDismissSearchController(_ searchController: UISearchController) {
        viewModel.dispatch(.finishSearching)
    }
}