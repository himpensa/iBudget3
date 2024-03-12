//
//  Utils.swift
//  iBudget
//
//  Created by Antoine Himpens on 03/02/2024.
//

import Foundation

enum Interval: String, CaseIterable, Codable {
    case day = "Jour"
    case week = "Semaine"
    case month = "Mois"
    case year = "Année"
}

enum Recurrence: CaseIterable, Codable, Identifiable, Equatable {
    case never
    case daily
    case weekly
    case monthly
    case yearly
    var id: Self { self }
}

func dateFormatted(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    return dateFormatter.string(from: date)
}
