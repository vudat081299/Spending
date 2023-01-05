//
//  Array+Extensions.swift
//  Spending
//
//  Created by Dat vu on 03/01/2023.
//

import Foundation

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
