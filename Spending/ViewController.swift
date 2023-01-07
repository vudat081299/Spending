//
//  ViewController.swift
//  Spending
//
//  Created by Dat Vu on 28/12/2022.
//

import UIKit

class ViewController: UIViewController {
    /// - Tag: OrthogonalBehavior
    enum SectionKind: Int, CaseIterable {
        case none, continuous, continuousGroupLeadingBoundary, paging, groupPaging, groupPagingCentered
        func orthogonalScrollingBehavior() -> UICollectionLayoutSectionOrthogonalScrollingBehavior {
            switch self {
            case .none:
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
    
    
    
    // MARK: -
    static let headerElementKind = "header-element-kind"
    static let footerElementKind = "footer-element-kind"
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Int, Payment>! = nil
    
    
    
    // MARK: - Data
    var groupedPaymentsDictionary: Dictionary<String, [Payment]>!
    
    /// Use to apply snapshot
    var sortedGroupedPaymentsDictionary: [Dictionary<String, [Payment]>.Element]! /// sorted by key (dateTime value)
    var groupedPaymentsArray: [[Payment]] = [] /// remove key from sortedGroupedPaymentsDictionary
    var flatPaymentsArray: [Payment] = [] /// flatten groupedPaymentsArray
    var numberOfSectionsInADateArray: [Int] = [] /// count elements in groupedPaymentsArray
    var headerIndexes: [Int] = []
    var footerIndexes: [Int] = []
    
    
    
    // MARK: - App default configuration
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        sample()
        prepareNavigationViewController()
        prepareData()
        configureHierarchy()
        configureDataSource()
        applySnapshot()
    }
    
    
    func prepareNavigationViewController() {
        title = "Spending"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.sizeToFit()
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        let rightBarItem: UIBarButtonItem = {
            let bt = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(rightBarItemAction))
            return bt
        }()
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    @objc func rightBarItemAction() {
        let createdDate = Date()
        if groupedPaymentsDictionary[createdDate.humanReadableDate] != nil {
        } else {
            groupedPaymentsDictionary[createdDate.humanReadableDate] = []
        }
        groupedPaymentsDictionary[createdDate.humanReadableDate]!.insert(
            Payment(
                icon: "☕️",
                type: "type",
                note: "note",
                dateTime: createdDate,
                amountMoney: "0",
                paymentMethod: .none
            ),
            at: 0
        )
        sortedGroupedPaymentsDictionary = groupedPaymentsDictionary.sorted(by: { $0.0 > $1.0 })
        preapreDataForCollection()
        applySnapshot()
        Ledger(payments: self.flatPaymentsArray).store()
    }
    
    
    // MARK: - Mini tasks
    func prepareData() {
        prepareDataForSnapshot()
        preapreDataForCollection()
    }
    func prepareDataForSnapshot() {
        groupedPaymentsDictionary = Ledger.retrieve().groupByDate()
        sortedGroupedPaymentsDictionary = groupedPaymentsDictionary.sorted(by: { $0.0 > $1.0 })
    }
    func preapreDataForCollection() {
        groupedPaymentsArray = sortedGroupedPaymentsDictionary.map { $0.1 }
        flatPaymentsArray = groupedPaymentsArray.flatMap { $0 }
        numberOfSectionsInADateArray = groupedPaymentsArray.map { $0.count }
        headerIndexes = Array(repeating: 0, count: numberOfSectionsInADateArray.count)
        var startHeaderIndex = 0
        numberOfSectionsInADateArray.enumerated().forEach { (index, numberOfSectionsInADate) in
            headerIndexes[index] = startHeaderIndex
            startHeaderIndex += numberOfSectionsInADate
        }
        footerIndexes = []
        footerIndexes.append(flatPaymentsArray.count - 1)
    }
}



// MARK: - Tasks
extension ViewController {
    
    
    
    // MARK: - Prepare
    func prepareCompositionalLayout(for scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior, at section: Int, in environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        switch scrollingBehavior {
        case .none:
            let layoutSection: NSCollectionLayoutSection
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.showsSeparators = false
            configuration.trailingSwipeActionsConfigurationProvider = { [weak self] (indexPath) in
                guard let self = self else { return nil }
                return self.trailingSwipeActionConfigurationForListCellItem(indexPath)
            }
            layoutSection = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
            layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10)
            
            var boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
            if (headerIndexes.contains(section)) {
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(60)),
                    elementKind: ViewController.headerElementKind,
                    alignment: .top)
                boundarySupplementaryItems.append(sectionHeader)
            }
            if (footerIndexes.contains(section)) {
                let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(60)),
                    elementKind: ViewController.footerElementKind,
                    alignment: .bottom)
                boundarySupplementaryItems.append(sectionFooter)
            }
            layoutSection.boundarySupplementaryItems = boundarySupplementaryItems
            return layoutSection
            do {
                //            let item = NSCollectionLayoutItem(
                //                layoutSize: NSCollectionLayoutSize(
                //                    widthDimension: .fractionalWidth(1.0),
                //                    heightDimension: .estimated(120)
                //                )
                //            )
                //            item.contentInsets = NSDirectionalEdgeInsets(
                //                top: 10,
                //                leading: 10,
                //                bottom: 10,
                //                trailing: 10
                //            )
                //            let containerGroup = NSCollectionLayoutGroup.horizontal(
                //                layoutSize: NSCollectionLayoutSize(
                //                    widthDimension: .fractionalWidth(1.0),
                //                    heightDimension: .absolute(item.layoutSize.heightDimension.dimension + 12)
                //                ),
                //                subitems: [item]
                //            )
                //            let section = NSCollectionLayoutSection(group: containerGroup)
                //            section.orthogonalScrollingBehavior = scrollingBehavior
                //            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                //                layoutSize: NSCollectionLayoutSize(
                //                    widthDimension: .fractionalWidth(1.0),
                //                    heightDimension: .estimated(44)
                //                ),
                //                elementKind: ViewController.headerElementKind,
                //                alignment: .top
                //            )
                //            section.boundarySupplementaryItems = [sectionHeader]
                //            return section
            }
        default:
            do {
                let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalHeight(1.0)))
                leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                
                let trailingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3)))
                trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0)), subitems: [trailingItem])
                
                let orthogonallyScrolls = scrollingBehavior != .none
                let containerGroupFractionalWidth = orthogonallyScrolls ? CGFloat(0.85) : CGFloat(1.0)
                let containerGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(containerGroupFractionalWidth),
                                                       heightDimension: .fractionalHeight(0.4)),
                    subitems: [leadingItem, trailingGroup])
                let section = NSCollectionLayoutSection(group: containerGroup)
                section.orthogonalScrollingBehavior = scrollingBehavior
                
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(44)),
                    elementKind: ViewController.headerElementKind,
                    alignment: .top)
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            }
        }
    }
    
    
    
    func trailingSwipeActionConfigurationForListCellItem(_ indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let sec = indexPath.section
        let _ = indexPath.row
        let starAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completion) in
            guard let self = self else {
                completion(false)
                return
            }
            var ledger = Ledger(payments: self.flatPaymentsArray)
            ledger.delete(self.flatPaymentsArray[sec]) {
                self.prepareData()
                self.applySnapshot()
            }
            completion(true)
        }
        starAction.image = UIImage(systemName: "trash")
//        starAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [starAction])
    }
}



// MARK: - Prepare collection view
extension ViewController {
    func configureHierarchy() {
        // configure collection view
        collectionView.collectionViewLayout = createLayout()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemGroupedBackground
        
        // collection view delegation
        collectionView.delegate = self
        
        // collection view hierarchy
        view.addSubview(collectionView)
        collectionView.register(UINib(nibName: PaymentCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PaymentCell.reuseIdentifier)
        collectionView.register(UINib(nibName: HeaderSupplementaryView.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: ViewController.headerElementKind, withReuseIdentifier: HeaderSupplementaryView.reuseIdentifier)
        collectionView.register(UINib(nibName: FooterSupplementaryView.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: ViewController.footerElementKind, withReuseIdentifier: FooterSupplementaryView.reuseIdentifier)
    }
    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: {(
                sectionIndex: Int,
                layoutEnvironment: NSCollectionLayoutEnvironment
            ) -> NSCollectionLayoutSection? in
                guard let sectionKind = SectionKind(rawValue: 0) else { fatalError("unknown section kind") }
                return self.prepareCompositionalLayout(for: sectionKind.orthogonalScrollingBehavior(), at: sectionIndex, in: layoutEnvironment)
            },
            configuration: config
        )
        return layout
    }
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Payment>(collectionView: collectionView) { [self]
            (collectionView: UICollectionView, indexPath: IndexPath, payment: Payment) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PaymentCell.reuseIdentifier,
                for: indexPath) as? PaymentCell else { fatalError("Cannot create new cell!") }
            cell.payment = payment
            cell.parentDelegate = self
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [self] (collectionView, elementKind, indexPath) in
            let sec = indexPath.section
            let _ = indexPath.row
            if elementKind == ViewController.headerElementKind {
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: HeaderSupplementaryView.reuseIdentifier,
                    for: indexPath
                ) as? HeaderSupplementaryView else { fatalError("Cannot create new header!") }
                header.title.text = flatPaymentsArray[sec].dateTime.humanReadableDate
                return header
            }
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: ViewController.footerElementKind,
                withReuseIdentifier: FooterSupplementaryView.reuseIdentifier,
                for: indexPath
            ) as? FooterSupplementaryView else { fatalError("Cannot create new footer!") }
            return footer
        }
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Payment>()
        var numberOfSections = 0
        for (_, value) in sortedGroupedPaymentsDictionary {
            let payments = value
            payments.enumerated().forEach { index, value in
                snapshot.appendSections([numberOfSections])
                numberOfSections += 1
                snapshot.appendItems([value])
            }
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}



// MARK: - Delegation
extension ViewController: DataEnterable {
    func alertForm(category: Payment.CodingKeys, keyPaths: [String: Any], of cell: PaymentCell) {
        let cellPayment = cell.payment
        guard let labelKeyPath = keyPaths["label"] as? KeyPath<PaymentCell, UILabel>,
              let fieldInPaymentKeyPath = keyPaths["fieldInPayment"] as? KeyPath<PaymentCell, Any> else { return }
        let label = cell[keyPath: labelKeyPath]
        let fieldInPayment = cell[keyPath: fieldInPaymentKeyPath]
        FeedbackInteraction.tapped(style: .light)
        let alertController = UIAlertController(
            title: category.rawValue.uppercased(),
            message: "message",
            preferredStyle: .alert
        )
        alertController.addTextField()
        alertController.textFields![0].text = label.text
        let doneAction = UIAlertAction(
            title: "Done",
            style: .default
        ) { [unowned alertController] _ in
            if alertController.textFields![0].text!.count > 0 {
                
                if let index = self.flatPaymentsArray.firstIndex(where: { $0.dateTime == cell.dateTime }) {
                    label.text = alertController.textFields![0].text
                    switch category {
                    case .icon:
                        cell.payment.icon = fieldLabel.text
                        self.flatPaymentsArray[index].icon = fieldLabel.text
                        break
                    case .type:
                        cell.payment.type = fieldLabel.text
                        self.flatPaymentsArray[index].type = fieldLabel.text
                        break
                    case .note:
                        cell.payment.note = fieldLabel.text
                        self.flatPaymentsArray[index].note = fieldLabel.text
                        break
                    case .amountMoney:
                        cell.payment.amountMoney = fieldLabel.text
                        self.flatPaymentsArray[index].amountMoney = fieldLabel.text
                        break
                    case .paymentMethod:
                        if let paymentMethod = PaymentMethod(rawValue: alertController.textFields![0].text!) {
                            fieldLabel.text = alertController.textFields![0].text
                            cell.payment.paymentMethod = paymentMethod
                            self.flatPaymentsArray[index].paymentMethod = paymentMethod
                        }
                        break
                    default:
                        break
                    }
                    Ledger(payments: self.flatPaymentsArray).store()
                }
            }
        }
        
        alertController.addAction(doneAction)
        alertController.preferredAction = doneAction
        self.present(alertController, animated: true)
    }
}



// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}




