//
//  PaymentCell.swift
//  Spending
//
//  Created by Dat Vu on 02/01/2023.
//

import UIKit

class PaymentCell: UICollectionViewCell {
    static let reuseIdentifier = "PaymentCell"
    
    var iconName: String!
    var dateTime: Date!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var amountMoney: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var paymentMethod: UILabel!
    
    var payment: Payment {
        get {
            return Payment(icon: iconName, type: type.text, note: note.text, dateTime: dateTime, amountMoney: amountMoney.text, paymentMethod: Payment.PaymentMethod(rawValue: paymentMethod.text ?? "") ?? .none)
        }
        set(newValue) {
            iconName = newValue.icon
            dateTime = newValue.dateTime
            icon.image = UIImage(systemName: newValue.icon ?? "gear") ?? UIImage(systemName: "gear")
            type.text = newValue.type
            note.text = newValue.note
            amountMoney.text = newValue.amountMoney
            time.text = "00:00"
            paymentMethod.text = newValue.paymentMethod.rawValue
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        icon.clipsToBounds = true
        icon.layer.cornerRadius = 8
    }

}
