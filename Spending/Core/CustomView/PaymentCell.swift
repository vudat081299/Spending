//
//  PaymentCell.swift
//  Spending
//
//  Created by Dat Vu on 02/01/2023.
//

import UIKit

protocol DataEnterable {
    func alertForm(category: Payment.CodingKeys, keyPaths: [String: Any], of cell: PaymentCell)
    
}

enum HighLightColor: Int {
    case red, blue, orange, green, purple, cyan, mint, gray
    func color() -> UIColor {
        switch self {
        case .red: return .systemRed
        case .blue: return .link
        case .orange: return .systemOrange
        case .green: return .systemGreen
        case .purple: return .systemPurple
        case .cyan: return .systemCyan
        case .mint: return .systemMint
        case .gray: return .systemGray
        }
    }
}

class PaymentCell: UICollectionViewCell {
    static let reuseIdentifier = "PaymentCell"
    
    @IBOutlet weak var iconBackGround: UIImageView!
    @IBOutlet weak var icon: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var amountMoney: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var paymentMethodContainer: UIStackView!
    
    struct CellPayment {
        var iconName: String!
        var dateTime: Date
        var payment: Payment
    }
    
    var parentDelegate: DataEnterable!
    var iconName: String!
    var dateTime: Date!
    var cellPayment: CellPayment!
    var payment: Payment {
        get {
            return Payment(icon: iconName, type: type.text, note: note.text, dateTime: dateTime, amountMoney: amountMoney.text, paymentMethod: PaymentMethod(rawValue: paymentMethod.text ?? "") ?? PaymentMethod.none)
        }
        set(newValue) {
            cellPayment = CellPayment(iconName: newValue.icon, dateTime: newValue.dateTime, payment: newValue)
            prepareCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.contentView.layer.cornerRadius = 16
//        self.contentView.clipsToBounds = true
        self.contentView.backgroundColor = .systemBackground
        iconBackGround.layer.cornerRadius = iconBackGround.bounds.width / 2
        iconBackGround.clipsToBounds = true
        iconBackGround.borderOutline(2, color: .link)
        
        let enterType = UITapGestureRecognizer(target: self, action: #selector(enterType))
        let enterNote = UITapGestureRecognizer(target: self, action: #selector(enterNote))
        let enterAmountMoney = UITapGestureRecognizer(target: self, action: #selector(enterAmountMoney))
        let enterPaymentMethod = UITapGestureRecognizer(target: self, action: #selector(enterPaymentMethod))
        
        type.addGestureRecognizer(enterType)
        amountMoney.addGestureRecognizer(enterAmountMoney)
        paymentMethodContainer.addGestureRecognizer(enterPaymentMethod)
        note.addGestureRecognizer(enterNote)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepareCell()
    }
    
    func prepareCell() {
        let payment = cellPayment.payment
        iconName = cellPayment.iconName
        dateTime = cellPayment.dateTime
        icon.text = payment.icon
        type.text = payment.type
        note.text = payment.note
        amountMoney.text = payment.amountMoney != nil ? payment.amountMoney! + "" : ""
        if let amount = payment.amountMoney, let amountInt = Int(amount) {
            if amountInt >= 0 {
                amountMoney.textColor = .systemGreen
            } else {
                amountMoney.textColor = .systemRed
            }
        }
        time.text = payment.dateTime.humanReadableTime
        iconBackGround.borderOutline(2, color: (HighLightColor(rawValue: (Int(payment.dateTime.humanReadableSecond) ?? 0) % 8)!.color()))
        paymentMethod.text = payment.paymentMethod?.rawValue
        
    }
    
    @IBAction func enterIcon(_ sender: UIButton) {
        let keyPaths = [
            "label": \PaymentCell.icon,
            "fieldInPayment": \PaymentCell.payment.icon
        ] as [String : Any]
        parentDelegate.alertForm(category: .icon, keyPaths: keyPaths, of: self)
    }
    
    @objc func enterType(_ sender: UITapGestureRecognizer) {
        let keyPaths = [
            "label": \PaymentCell.type,
            "fieldInPayment": \PaymentCell.payment.type
        ] as [String : Any]
        parentDelegate.alertForm(category: .type, keyPaths: keyPaths, of: self)
    }
    @objc func enterNote(_ sender: UITapGestureRecognizer) {
        let keyPaths = [
            "label": \PaymentCell.note,
            "fieldInPayment": \PaymentCell.payment.note
        ] as [String : Any]
        parentDelegate.alertForm(category: .note, keyPaths: keyPaths, of: self)
    }
    @objc func enterAmountMoney(_ sender: UITapGestureRecognizer) {
        let keyPaths = [
            "label": \PaymentCell.amountMoney,
            "fieldInPayment": \PaymentCell.payment.amountMoney
        ] as [String : Any]
        parentDelegate.alertForm(category: .amountMoney, keyPaths: keyPaths, of: self)
    }
    @objc func enterPaymentMethod(_ sender: UITapGestureRecognizer) {
        let keyPaths = [
            "label": \PaymentCell.paymentMethod,
            "fieldInPayment": \PaymentCell.payment.paymentMethod
        ] as [String : Any]
        parentDelegate.alertForm(category: .paymentMethod, keyPaths: keyPaths, of: self)
    }
}
