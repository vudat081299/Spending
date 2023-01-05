//
//  String+Extensions.swift
//  Spending
//
//  Created by Dat Vu on 29/12/2022.
//

import Foundation

extension String {
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ" // 2022-12-28 17:09:15 +0000
        guard let date = dateFormatter.date(from: self) else {
            return Date()
        }
        return date
    }
}
