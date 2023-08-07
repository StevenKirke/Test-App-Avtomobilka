//
//  String.swift
//  Avtomobilka
//
//  Created by Steven Kirke on 06.08.2023.
//

import Foundation


extension String {
    func convertDate() -> String {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [
          .withFractionalSeconds,
          .withFullDate
        ]
        let date = inputFormatter.date(from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        guard let date = date else {
            return self
        }
        return dateFormatter.string(from: date)
    }
}
