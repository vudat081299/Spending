//
//  Ledger.swift
//  Spending
//
//  Created by Dat Vu on 02/01/2023.
//

import Foundation

// MARK: - Structure definition
typealias PaymentMethod = Payment.PaymentMethod
struct Payment {
    enum PaymentMethod: String {
        case none, cash, card, borrow
    }
    var icon: String?
    var type: String?
    var note: String?
    var dateTime: Date = Date()
    var amountMoney: String?
    var paymentMethod: PaymentMethod? = PaymentMethod.none
    
    enum CodingKeys: String, CodingKey {
        case icon
        case type
        case note
        case dateTime
        case amountMoney
        case paymentMethod
    }
    
    static func < (lhs: Payment, rhs: Payment) -> Bool {
        return lhs.dateTime < rhs.dateTime
    }
    
    static func == (lhs: Payment, rhs: Payment) -> Bool {
        return lhs.dateTime == rhs.dateTime
    }
    
    static func > (lhs: Payment, rhs: Payment) -> Bool {
        return lhs.dateTime > rhs.dateTime
    }
}
extension Payment: Hashable {} // To use UICollectionViewDiffableDataSource
extension Payment: CustomStringConvertible {
    var description: String {
        return "Payment: \(icon ?? "") \(type ?? "") \(note ?? "") \(dateTime) \(amountMoney ?? "") \(paymentMethod?.rawValue ?? "")"
    }
}

struct Ledger {
    var payments: [Payment]
    
    init(payments: [Payment] = []) {
        self.payments = payments
    }
}



// MARK: - Apply Codable
extension Ledger: Codable {
    struct PaymentKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }

        static let icon = PaymentKey(stringValue: "icon")!
        static let type = PaymentKey(stringValue: "type")!
        static let note = PaymentKey(stringValue: "note")!
        static let dateTime = PaymentKey(stringValue: "dateTime")!
        static let amountMoney = PaymentKey(stringValue: "amountMoney")!
        static let paymentMethod = PaymentKey(stringValue: "paymentMethod")!
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PaymentKey.self)
        
        for payment in payments {
            // Any product's `name` can be used as a key name.
            let dateTimeKey = PaymentKey(stringValue: payment.dateTime.description)!
            var productContainer = container.nestedContainer(keyedBy: PaymentKey.self, forKey: dateTimeKey)
            
            // The rest of the keys use static names defined in `ProductKey`.
            try productContainer.encode(payment.icon, forKey: .icon)
            try productContainer.encode(payment.type, forKey: .type)
            try productContainer.encode(payment.note, forKey: .note)
            try productContainer.encode(payment.amountMoney, forKey: .amountMoney)
            try productContainer.encode(payment.paymentMethod?.rawValue, forKey: .paymentMethod)
        }
    }
    
    public init(from decoder: Decoder) throws {
        var payments = [Payment]()
        let container = try decoder.container(keyedBy: PaymentKey.self)
        for key in container.allKeys {
            // Note how the `key` in the loop above is used immediately to access a nested container.
            let productContainer = try container.nestedContainer(keyedBy: PaymentKey.self, forKey: key)
            let icon = try productContainer.decode(String.self, forKey: .icon)
            let type = try productContainer.decodeIfPresent(String.self, forKey: .type)
            let note = try productContainer.decode(String.self, forKey: .note)
            let amountMoney = try productContainer.decodeIfPresent(String.self, forKey: .amountMoney)
            let paymentMethod = try productContainer.decode(String.self, forKey: .paymentMethod)

            // The key is used again here and completes the collapse of the nesting that existed in the JSON representation.
            let payment = Payment(icon: icon, type: type, note: note, dateTime: key.stringValue.toDate(), amountMoney: amountMoney, paymentMethod: PaymentMethod(rawValue: paymentMethod) ?? PaymentMethod.none)
            payments.append(payment)
        }
        self.init(payments: payments)
    }
}



// MARK: - Data handler
extension Ledger {
    func store() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let paymentsStorageFilePath = dir.appendingPathComponent("Payments")
            print("Payments storage filepath: \(paymentsStorageFilePath)")
            do {
                let encoder = JSONEncoder()
//                encoder.outputFormatting = .prettyPrinted
                try encoder.encode(self).write(to: paymentsStorageFilePath)
            }
            catch {
                print("Store payments failed! \(error)")
            }
        }
    }
    static func retrieve() -> Ledger {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let paymentsStorageFilePath = dir.appendingPathComponent("Payments")
            print("Retrieve data from payments storage filepath: \(paymentsStorageFilePath)")
            do {
                let jsonData = try Data(contentsOf: paymentsStorageFilePath)
                let ledger = try JSONDecoder().decode(Ledger.self, from: jsonData)
                var sortedLedger = ledger
                sortedLedger.payments = ledger.payments.sorted {
                    if ($0.dateTime > $1.dateTime) {
                        return true
                    }
                    return false
                }
                return sortedLedger
            }
            catch {
                print("Retrieve payments failed! \(error)")
            }
        }
        return Ledger()
    }
    
    mutating func delete(_ payment: Payment, completion: () -> ()) {
        payments.remove(at: SearchEngine.binarySearch(in: payments, for: payment))
        self.store()
        completion()
    }
    
    func groupByDate() -> Dictionary<String, [Payment]> {
        return Dictionary(grouping: payments, by: \.dateTime.humanReadableDate)
    }
}



// MARK: - Mini tasks
extension Ledger {
    var count: Int {
        return payments.count
    }
    subscript(index: Int) -> Payment {
        get {
            // Return an appropriate subscript value here.
            return payments[index]
        }
        set(newValue) {
            // Perform a suitable setting action here.
            payments[index] = newValue
        }
    }
}



// MARK: - Sample usage Payments storage engine
func sample() {
    let store = Ledger(payments: [
        .init(icon: "car", type: "borrow", note: "Buy my new car", dateTime: Date(), amountMoney: "2000", paymentMethod: .cash),
        .init(icon: "??????", type: "Highland", note: "With my friend", dateTime: "2022-12-28 17:30:22 +0000".toDate(), amountMoney: "20", paymentMethod: .card),
        .init(icon: "??????", type: "Starbuck", note: "With my boss", dateTime: "2022-12-28 17:30:21 +0000".toDate(), amountMoney: "30", paymentMethod: .cash),
        .init(icon: "????", type: "breakfast", note: "Delecious", dateTime: "2022-12-28 17:30:25 +0000".toDate(), amountMoney: "30", paymentMethod: .cash),
        .init(icon: "????", type: "EC", note: "At Uni", dateTime: "2022-12-28 17:30:20 +0000".toDate(), amountMoney: "20", paymentMethod: .cash)
    ])
    store.store()
    let payments = Ledger.retrieve()
    for payment in payments.payments {
        let dateTime = payment.dateTime
        if let icon = payment.icon,
           let type = payment.type,
           let note = payment.note,
           let amountMoney = payment.amountMoney,
           let paymentMethod = payment.paymentMethod
        {
            print("\(dateTime) \(icon) \(type) \(note) \(amountMoney) \(paymentMethod.rawValue)")
        }
    }
}
