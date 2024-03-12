//
//  Budget.swift
//  MyAppController
//
//  Created by Antoine Himpens on 28/10/2023.
//

import SwiftUI
import SwiftData

@Model class Budget : Codable{
    var budget_id: UUID
    var budget_name: String
    var budget_start_date: Date
    var budget_end_date: Date
    var budget_limit: Double
    var budget_number: Int
    var budget_interval: Interval
    var budget_category:  Category
    
    init(budget_id: UUID = UUID(), budget_name: String = "", budget_start_date: Date = Date(), budget_end_date: Date = Date(), budget_limit: Double=0, budget_number: Int=1, budget_interval: Interval = .month, budget_category: Category) {
    print("inside init")
        self.budget_id = budget_id
    self.budget_name = budget_name
    self.budget_start_date = budget_start_date
    self.budget_end_date = budget_end_date
    self.budget_limit = budget_limit
    self.budget_number = budget_number
    self.budget_interval = budget_interval
    self.budget_category = budget_category
  }

  func description() -> String {
    return "Budget [Name: \(budget_name), Date: \(budget_end_date), Limit: \(budget_limit)]"
  }

  func update(budget_name: String, budget_start_date: Date, budget_end_date: Date, budget_limit: Double, budget_category: Category) {
    self.budget_name = budget_name
    self.budget_end_date = budget_end_date
    self.budget_limit = budget_limit
      self.budget_category = budget_category
  }
    
    // Fonction pour générer les enveloppes
    func generateEnveloppes() -> [Enveloppe] {
        var enveloppes = [Enveloppe]()
        var startDate = budget_start_date
        var endDate = budget_start_date
        var calendarComponent: Calendar.Component = .month

        print("start : \(startDate)")
        print("end : \(budget_end_date)")
        while startDate <= budget_end_date {
            // Calcul de la prochaine échéance en fonction de la récurrence
            switch budget_interval {
            case .day:
                startDate = endDate
                calendarComponent = .day
                endDate = Calendar.current.date(byAdding: calendarComponent, value: 1, to: startDate)!
            case .week:
                startDate = Calendar.current.dateInterval(of: .weekOfYear, for: startDate)!.start
                startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
                endDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: startDate)!
                endDate = Calendar.current.date(byAdding: .day, value: -1, to: endDate)!
            case .month:
                startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: startDate))!
                startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
                endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate)!
                endDate = Calendar.current.date(byAdding: .day, value: -1, to: endDate)!
            case .year:
                startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year], from: startDate))!
                startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
                endDate = Calendar.current.date(byAdding: .year, value: 1, to: startDate)!
                endDate = Calendar.current.date(byAdding: .day, value: -1, to: endDate)!

            }

          print("startDate : \(startDate)")
          print("endDate : \(endDate)")

        //    let enveloppe = Enveloppe(enveloppe_name: budget_name, enveloppe_category: budget_category.category_name, enveloppe_timescale: .month, enveloppe_start_date: startDate, enveloppe_end_date: endDate)
         //   enveloppes.append(enveloppe)

            startDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate)!
        }

        return enveloppes
    }
    
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        budget_id = try values.decode(UUID.self, forKey: .budget_id)
        budget_name = try values.decode(String.self, forKey: .budget_name)
        budget_start_date=try values.decode(Date.self, forKey: .budget_start_date)
        budget_end_date=try values.decode(Date.self, forKey: .budget_end_date)
        budget_limit=try values.decode(Double.self, forKey: .budget_limit)
        budget_number=try values.decode(Int.self, forKey: .budget_number)
        budget_interval=try values.decode(Interval.self, forKey: .budget_interval)
        budget_category=try values.decode(Category.self, forKey: .budget_category)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(budget_id, forKey: .budget_id)
        try container.encode(budget_name, forKey: .budget_name)
        try container.encode(budget_limit, forKey: .budget_limit)
        try container.encode(budget_start_date, forKey: .budget_start_date)
        try container.encode(budget_end_date, forKey: .budget_end_date)
        try container.encode(budget_number, forKey: .budget_number)
        try container.encode(budget_interval, forKey: .budget_interval)
        try container.encode(budget_category, forKey: .budget_category)
    }

    enum CodingKeys: String, CodingKey {
        case budget_id
        case budget_name
        case budget_limit
        case budget_start_date
        case budget_end_date
        case budget_number
        case budget_interval
        case budget_category
    }
}
