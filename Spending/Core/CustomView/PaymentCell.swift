//
//  PaymentCell.swift
//  Spending
//
//  Created by Dat Vu on 02/01/2023.
//

import UIKit

protocol DataEnterable {
    func alertForm(category: Payment.CodingKeys, fieldLabel: UILabel, of cell: PaymentCell)
    
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
            return Payment(icon: iconName, type: type.text, note: note.text, dateTime: dateTime, amountMoney: amountMoney.text, paymentMethod: Payment.PaymentMethod(rawValue: paymentMethod.text ?? "") ?? .none)
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
        time.text = payment.dateTime.description
        paymentMethod.text = payment.paymentMethod.rawValue
    }
    
    @IBAction func enterIcon(_ sender: UIButton) {
        parentDelegate.alertForm(category: .icon, fieldLabel: icon, of: self)
    }
    
    @objc func enterType(_ sender: UITapGestureRecognizer) {
        parentDelegate.alertForm(category: .type, fieldLabel: type, of: self)
    }
    @objc func enterNote(_ sender: UITapGestureRecognizer) {
        parentDelegate.alertForm(category: .note, fieldLabel: note, of: self)
    }
    @objc func enterAmountMoney(_ sender: UITapGestureRecognizer) {
        parentDelegate.alertForm(category: .amountMoney, fieldLabel: amountMoney, of: self)
    }
    @objc func enterPaymentMethod(_ sender: UITapGestureRecognizer) {
        parentDelegate.alertForm(category: .paymentMethod, fieldLabel: paymentMethod, of: self)
    }
}
