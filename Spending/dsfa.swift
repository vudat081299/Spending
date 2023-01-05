//
//  dsfa.swift
//  Spending
//
//  Created by Dat Vu on 03/01/2023.
//

import UIKit

class ViewControllera: UIViewController {
    
    var resolvedUser: [String] = []
    var i = 0
    
    // MARK: - Collection view setting up.
    static let headerElementKind = "header-element-kind"
    
    enum SectionType: Int, CaseIterable {
        case list, collection
    }
    
    /// Cell data structure.
    class CellItem: Hashable {
        let image: UIImage?
        let data: (String?, String?) // (label, detaiLabel)
        let select: (() -> Void)? // select cell
        let cellClass: UITableViewCell // class of cell
        let viewControllerType: UIViewController.Type? // view show when select cell
        
        init(image: UIImage? = nil,
             data: (String?, String?) = (nil, nil),
             select: (() -> ())? = nil,
             cellClass: UITableViewCell = UITableViewCell(),
             viewControllerType: UIViewController.Type? = nil
        ) {
            self.image = image
            self.data = data
            self.select = select
            self.cellClass = cellClass
            self.viewControllerType = viewControllerType
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        static func == (lhs: CellItem, rhs: CellItem) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        private let identifier = UUID()
    }
    
    /// Sectiion data structure.
    class SectionItem {
        let cell: [CellItem]
        let sectionType: SectionType?
        let behavior: SectionKind?
        let supplementaryData: (String?, String?)
        let header: UICollectionReusableView?
        let footer: UICollectionReusableView?
        
        init(cell: [CellItem],
             sectionType: SectionType? = .list,
             behavior: SectionKind? = .continuous,
             supplementaryData: (String?, String?) = (nil, nil),
             header: UICollectionReusableView? = nil,
             footer: UICollectionReusableView? = nil
        ) {
            self.cell = cell
            self.sectionType = sectionType
            self.behavior = behavior
            self.supplementaryData = supplementaryData
            self.header = header
            self.footer = footer
        }
    }
    
    private lazy var listItems: [SectionItem] = {
        let listCell: [CellItem] = {
            var list: [CellItem] = []
            for i in 0...100 {
                let customCell = CellItem(data: ("\(i)", "\(i + 1)"), select: triggerCellAction)
                list.append(customCell)
            }
            return list
        }()
        return [
            SectionItem(cell: listCell, sectionType: .collection, behavior: .noneType),
//            SectionItem(cell: listCell, sectionType: .collection, behavior: .groupPaging),
//            SectionItem(cell: listCell, sectionType: .collection, behavior: .continuousGroupLeadingBoundary),
//            SectionItem(cell: listCell, sectionType: .list, behavior: .noneType),
//            SectionItem(cell: listCell, sectionType: .collection, behavior: .groupPagingCentered),
//            SectionItem(cell: listCell, sectionType: .list, behavior: .noneType),
//            SectionItem(cell: listCell, sectionType: .collection, behavior: .continuous),
//            SectionItem(cell: listCell, sectionType: .collection, behavior: .paging),
//            SectionItem(cell: [CellItem(data: ("1", "2"), select: triggerCellAction, viewControllerType: UITableViewController.self)], sectionType: .collection, behavior: .groupPaging),
        ]
    }()
    
    func triggerCellAction() {
        print("Trigger cell action!")
    }

    /// - Tag: OrthogonalBehavior
    enum SectionKind: Int, CaseIterable {
        case continuous, continuousGroupLeadingBoundary, paging, groupPaging, groupPagingCentered, noneType
        func orthogonalScrollingBehavior() -> UICollectionLayoutSectionOrthogonalScrollingBehavior {
            switch self {
            case .noneType:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.none
            case .continuous:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.continuous
            case .continuousGroupLeadingBoundary:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.continuousGroupLeadingBoundary
            case .paging:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.paging
            case .groupPaging:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPaging
            case .groupPagingCentered:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPagingCentered
            }
        }
    }
    
    
    
    // MARK: - Variables.
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    
    
    
    // MARK: - IBOutlet and UI constant.
//    var collectionView: UICollectionView! = nil
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    // MARK: - Navigation Bar set up and create component.
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "New Search"
        searchController.searchBar.searchBarStyle = .minimal
//        searchController.dimsBackgroundDuringPresentation = false // was deprecated in iOS 12.0
        searchController.definesPresentationContext = true
       return searchController
    }()
    
    @objc func leftBarItemAction() {
        print("Left bar button was pressed!")
    }
    
    @objc func rightBarItemAction() {
        print("Right bar button was pressed!")
    }
    
    func setUpNavigationBar() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        
        navigationItem.largeTitleDisplayMode = .always
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
        
//        self.searchController.hidesNavigationBarDuringPresentation = true
//        self.searchController.searchBar.searchBarStyle = .prominent
//        // Include the search bar within the navigation bar.
//        self.navigationItem.titleView = self.searchController.searchBar
        
        let leftBarItem: UIBarButtonItem = {
            let bt = UIBarButtonItem(title: "Action", style: .done, target: self, action: #selector(leftBarItemAction))
            return bt
        }()
        let rightBarItem: UIBarButtonItem = {
            let bt = UIBarButtonItem(image: UIImage(systemName: "bookmark.circle"), style: .plain, target: self, action: #selector(rightBarItemAction))
            return bt
        }()
        navigationItem.leftBarButtonItem = leftBarItem
        navigationItem.rightBarButtonItem = rightBarItem
    }
    

    
    // MARK: - Life cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpNavigationBar()
        
        view.backgroundColor = .lightGray
        definesPresentationContext = true
        
        // Setting up collection view.
        configureHierarchy()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "pushSeque" {
//            // This segue is pushing a detailed view controller.
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                segue.destination.title = dataSource.city(index: indexPath.row)
//            }
//
//            // You choose not to have a large title for the destination view controller.
//            segue.destination.navigationItem.largeTitleDisplayMode = .never
//        } else {
//            // This segue is popping you back up the navigation stack.
//        }
//    }

}

// MARK: - Collection View.
extension ViewControllera {
    
    //   +-----------------------------------------------------+
    //   | +---------------------------------+  +-----------+  |
    //   | |                                 |  |           |  |
    //   | |                                 |  |           |  |
    //   | |                                 |  |     1     |  |
    //   | |                                 |  |           |  |
    //   | |                                 |  |           |  |
    //   | |                                 |  +-----------+  |
    //   | |               0                 |                 |
    //   | |                                 |  +-----------+  |
    //   | |                                 |  |           |  |
    //   | |                                 |  |           |  |
    //   | |                                 |  |     2     |  |
    //   | |                                 |  |           |  |
    //   | |                                 |  |           |  |
    //   | +---------------------------------+  +-----------+  |
    //   +-----------------------------------------------------+
    
    func createLayout() -> UICollectionViewLayout {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [self]
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
//            guard let sectionKind = SectionKind(rawValue: sectionIndex) else { fatalError("unknown section kind") }
            guard let sectionKind = listItems[sectionIndex].behavior, let sectionType = listItems[sectionIndex].sectionType else { fatalError("unknown section kind") }
            switch sectionType {
            case .collection:
                let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                            widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150)))
//                leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10)
                
                let trailingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                            widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3)))
                trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                                                                        widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0)),
                                                                     subitem: trailingItem,
                                                                     count: 2)
                
                let orthogonallyScrolls = sectionKind.orthogonalScrollingBehavior() != .none
                let containerGroupFractionalWidth = orthogonallyScrolls ? CGFloat(0.85) : CGFloat(1.0)
//                let containerGroup = NSCollectionLayoutGroup.horizontal(
//                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(containerGroupFractionalWidth),
//                                                       heightDimension: .fractionalHeight(0.4)),
//                    subitems: [leadingItem, trailingGroup])
                let containerGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(150)),
                    subitems: [leadingItem])
                let section = NSCollectionLayoutSection(group: containerGroup)
                section.orthogonalScrollingBehavior = sectionKind.orthogonalScrollingBehavior()
                
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(44)),
                    elementKind: ViewController.headerElementKind,
                    alignment: .top)
//                section.boundarySupplementaryItems = [sectionHeader]
                return section
            case .list:
                let section: NSCollectionLayoutSection
                var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//                configuration.leadingSwipeActionsConfigurationProvider = { [weak self] (indexPath) in
//                    guard let self = self else { return nil }
//                    guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return nil }
//                    return self.leadingSwipeActionConfigurationForListCellItem(item)
//                }
                section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
                
                return section
            }
            
        }, configuration: config)
        return layout
    }
}



// MARK: - CV DataSource.
extension ViewControllera {
    func configureHierarchy() {
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.frame = view.bounds
        collectionView.collectionViewLayout = createLayout()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemGroupedBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(UINib(nibName: PaymentCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PaymentCell.reuseIdentifier)
        collectionView.register(UINib(nibName: TitleSupplementaryView.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: ViewController.headerElementKind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
    }
    func configureDataSource() {
        
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            // Return the cell.
            switch self.listItems[indexPath.section].sectionType {
            case .list:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PaymentCell.reuseIdentifier,
                    for: indexPath) as? PaymentCell else { fatalError("Cannot create new cell") }
                cell.icon.image = UIImage(named: "avatar_11")
                return cell
//                return collectionView.dequeueConfiguredReusableCell(using: customCellRegistration, for: indexPath, item: identifier)
            default:
                return nil
            }
        }
        

        /// initial data.
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(Array(0 ..< (self.resolvedUser.count > 1 ? self.resolvedUser.count - 1 : self.resolvedUser.count)))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}



// MARK: - CV Delegate.
extension ViewControllera: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cellItem = listItems[indexPath.section].cell[indexPath.row]
        if let action = cellItem.select { action() }
        if let viewController = cellItem.viewControllerType {
            navigationController?.pushViewController(viewController.init(), animated: true)
        }
    }
    
}
