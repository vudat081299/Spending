//
//  ViewController.swift
//  Spending
//
//  Created by Dat Vu on 28/12/2022.
//

import UIKit

//extension Array: Codable where Element == Payments.Payment {
//    typealias Payment = Payments.Payment
//
//    struct PaymentKey: CodingKey {
//        var stringValue: String
//        init?(stringValue: String) {
//            self.stringValue = stringValue
//        }
//
//        var intValue: Int? { return nil }
//        init?(intValue: Int) { return nil }
//
//        static let icon = PaymentKey(stringValue: "icon")!
//        static let type = PaymentKey(stringValue: "type")!
//        static let note = PaymentKey(stringValue: "note")!
//        static let dateTime = PaymentKey(stringValue: "dateTime")!
//        static let amountMoney = PaymentKey(stringValue: "amountMoney")!
//        static let paymentMethod = PaymentKey(stringValue: "paymentMethod")!
//    }
//
//    init(payments: [Payment] = []) {
//        self = payments
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: PaymentKey.self)
//
//        for payment in self {
//            // Any product's `name` can be used as a key name.
//            let dateTimeKey = PaymentKey(stringValue: payment.dateTime.description)!
//            var productContainer = container.nestedContainer(keyedBy: PaymentKey.self, forKey: dateTimeKey)
//
//            // The rest of the keys use static names defined in `ProductKey`.
//            try productContainer.encode(payment.icon, forKey: .icon)
//            try productContainer.encode(payment.type, forKey: .type)
//            try productContainer.encode(payment.note, forKey: .note)
//            try productContainer.encode(payment.amountMoney, forKey: .amountMoney)
//            try productContainer.encode(payment.paymentMethod.rawValue, forKey: .paymentMethod)
//        }
//    }
//
//    internal init(from decoder: Decoder) throws {
//        var payments = [Payment]()
//        let container = try decoder.container(keyedBy: PaymentKey.self)
//        for key in container.allKeys {
//            // Note how the `key` in the loop above is used immediately to access a nested container.
//            let productContainer = try container.nestedContainer(keyedBy: PaymentKey.self, forKey: key)
//            let icon = try productContainer.decode(String.self, forKey: .icon)
//            let type = try productContainer.decodeIfPresent(String.self, forKey: .type)
//            let note = try productContainer.decode(String.self, forKey: .note)
//            let amountMoney = try productContainer.decodeIfPresent(String.self, forKey: .amountMoney)
//            let paymentMethod = try productContainer.decode(String.self, forKey: .paymentMethod)
//
//            // The key is used again here and completes the collapse of the nesting that existed in the JSON representation.
//            let payment = Payment(icon: icon, type: type, note: note, dateTime: key.stringValue.toDate(), amountMoney: amountMoney, paymentMethod: Payment.PaymentMethod(rawValue: paymentMethod) ?? .none)
//            payments.append(payment)
//        }
//        self.init(payments: payments)
//    }
//
//
//
//
//
//
//    // Store an Array of Payments
//    func store() {
//        do {
//            let data = try PropertyListEncoder().encode(["a"])
//            try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
//
//            let success = NSKeyedArchiver.archiveRootObject(data, toFile: productsFile.path)
//        } catch {
//            print("Store payments failed! \(error)")
//        }
//    }
//
//    // Retrieve an Array of Payments
//    func retrieve() -> [Payment] {
//        var paymentStorageFilePath: URL = {
//            let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            return docDir.appendingPathComponent("PaymentsStorage.plist")
//        }()
////        try NSKeyedUnarchiver.unarchivedObject(ofClass: <#T##NSCoding.Protocol#>, from: <#T##Data#>)
//        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: paymentStorageFilePath.path) as? Data else { return [] }
//        do {
//            let payments = NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: Payment, from: data)
////            let payments = try PropertyListDecoder().decode([Payment].self, from: data)
//            return payments
//        } catch {
//            print("Retrieve Failed")
//            return []
//        }
//    }
//}

class ViewController: UIViewController {
    
    static let headerElementKind = "header-element-kind"
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    
    
    
    // MARK: - Data
    let payments = Payments.retrieve()

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Orthogonal Section Behaviors"
        configureHierarchy()
        configureDataSource()
        
        // MARK: - Sample usage Payments storage engine
//        let store = Payments(payments: [
//            .init(icon: "car", type: "borrow", note: "Buy my new car", dateTime: Date(), amountMoney: "2000", paymentMethod: .cash),
//            .init(icon: "☕️", type: "Highland", note: "With my friend", dateTime: "2022-12-28 17:30:22 +0000".toDate(), amountMoney: "20", paymentMethod: .card),
//            .init(icon: "☕️", type: "Starbuck", note: "With my boss", dateTime: "2022-12-28 17:30:21 +0000".toDate(), amountMoney: "30", paymentMethod: .cash),
//            .init(icon: "🍕", type: "breakfast", note: "Delecious", dateTime: "2022-12-28 17:30:25 +0000".toDate(), amountMoney: "30", paymentMethod: .cash),
//            .init(icon: "📓", type: "EC", note: "At Uni", dateTime: "2022-12-28 17:30:20 +0000".toDate(), amountMoney: "20", paymentMethod: .cash)
//        ])
//        store.store()
//        let payments = Payments.retrieve()
//        for payment in payments.payments {
//            let paymentMethod = payment.paymentMethod
//            let dateTime = payment.dateTime
//            if let icon = payment.icon,
//               let type = payment.type,
//               let note = payment.note,
//               let amountMoney = payment.amountMoney
//            {
//                print("\(dateTime) \(icon) \(type) \(note) \(amountMoney) \(paymentMethod)")
//            }
//        }
        
        
    }
}

extension ViewController {
    
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
    
    func prepareCompositionalLayout(for scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior) -> NSCollectionLayoutSection {
        switch scrollingBehavior {
        case .none:
            let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0)))
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            let orthogonallyScrolls = scrollingBehavior != .none
            let containerGroupFractionalWidth = orthogonallyScrolls ? CGFloat(0.5) : CGFloat(1.2)
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(containerGroupFractionalWidth),
                                                   heightDimension: .fractionalHeight(0.4)),
                subitems: [leadingItem])
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = scrollingBehavior
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(44)),
                elementKind: ViewController.headerElementKind,
                alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        default:
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
    
    func createLayout() -> UICollectionViewLayout {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = SectionKind(rawValue: sectionIndex) else { fatalError("unknown section kind") }
            return self.prepareCompositionalLayout(for: sectionKind.orthogonalScrollingBehavior())
        }, configuration: config)
        return layout
    }
}

extension ViewController {
    func configureHierarchy() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(UINib(nibName: PaymentCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PaymentCell.reuseIdentifier)
    }
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { [self]
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            // Return the cell.
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentCell.reuseIdentifier, for: indexPath) as? PaymentCell else { fatalError("Cannot create new cell!") }
            cell.payment = payments[indexPath.row]
            return cell
//            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: ViewController.headerElementKind) {
            (supplementaryView, string, indexPath) in
            let sectionKind = SectionKind(rawValue: indexPath.section)!
            supplementaryView.label.text = "." + String(describing: sectionKind)
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: supplementaryRegistration, for: index)
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
//        var identifierOffset = 0 // come with sample
//        let itemsPerSection = 18
        
        /// sample
//        SectionKind.allCases.forEach {
//            snapshot.appendSections([$0.rawValue])
//            let maxIdentifier = identifierOffset + itemsPerSection
//            snapshot.appendItems(Array(identifierOffset..<maxIdentifier))
//            identifierOffset += itemsPerSection
//        }
        /// custom
        snapshot.appendSections([0])
        snapshot.appendItems(Array(0..<payments.count))
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension UIColor {
    static var cornflowerBlue: UIColor {
        return UIColor(displayP3Red: 100.0 / 255.0, green: 149.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
    }
}
