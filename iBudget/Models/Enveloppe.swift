//
//  Enveloppe.swift
//  iBudget
//
//  Created by Antoine Himpens on 03/02/2024.
//

import Foundation
import SwiftData

@Model class Enveloppe: Codable , ObservableObject{
    var enveloppe_id: UUID
    var enveloppe_name: String
    var enveloppe_category: String
    var enveloppe_timescale: Interval
    var enveloppe_start_date: Date
    var enveloppe_end_date: Date
    
    
    /*Timescale (Jour/Semaine/Mois/Année)
    ListOfDays[
    DayDate (01/02)
    DailyAmount (44.89)
    TotalAmount (855.86)
    
    var categories:  [Category] = []*/
    
    init(enveloppe_id: UUID = UUID(), enveloppe_name: String = "", enveloppe_category: String = "", enveloppe_timescale: Interval = .day, enveloppe_start_date: Date = Date(), enveloppe_end_date: Date = Date()) {
    self.enveloppe_id = enveloppe_id
    self.enveloppe_name = enveloppe_name
    self.enveloppe_category = enveloppe_category
    self.enveloppe_timescale = enveloppe_timescale
    self.enveloppe_start_date = enveloppe_start_date
    self.enveloppe_end_date = enveloppe_end_date
  }

  func description() -> String {
    return "enveloppe [Name: \(enveloppe_name), Date: \(enveloppe_start_date)]"
  }

  func update(enveloppe_name: String, enveloppe_end_date: Date, enveloppe_limit: Double, categories: [Category]) {
    self.enveloppe_name = enveloppe_name
    self.enveloppe_end_date = enveloppe_end_date
  }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        enveloppe_id = try values.decode(UUID.self, forKey: .enveloppe_id)
        enveloppe_name = try values.decode(String.self, forKey: .enveloppe_name)
        enveloppe_category = try values.decode(String.self, forKey: .enveloppe_category)
        enveloppe_timescale = try values.decode(Interval.self, forKey: .enveloppe_timescale)
        enveloppe_start_date=try values.decode(Date.self, forKey: .enveloppe_start_date)
        enveloppe_end_date=try values.decode(Date.self, forKey: .enveloppe_end_date)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(enveloppe_id, forKey: .enveloppe_id)
        try container.encode(enveloppe_name, forKey: .enveloppe_name)
        try container.encode(enveloppe_category, forKey: .enveloppe_category)
        try container.encode(enveloppe_timescale, forKey: .enveloppe_timescale)
        try container.encode(enveloppe_start_date, forKey: .enveloppe_start_date)
        try container.encode(enveloppe_end_date, forKey: .enveloppe_end_date)
    }

    enum CodingKeys: String, CodingKey {
        case enveloppe_id
        case enveloppe_name
        case enveloppe_category
        case enveloppe_timescale
        case enveloppe_start_date
        case enveloppe_end_date
        
    }


    func calculateEndDate(startDate: Date, interval: Interval, numberOfRecurrences: Int) -> Date? {
        guard let startDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: startDate) else {
            return nil
        }
        
        let calendarComponent: Calendar.Component
            switch interval {
            case .day:
                calendarComponent = .day
            case .week:
                calendarComponent = .weekOfYear
            case .month:
                calendarComponent = .month
            case .year:
                calendarComponent = .year
            }
        
        if let endDate = Calendar.current.date(byAdding: calendarComponent, value: numberOfRecurrences, to: startDate) {
                self.enveloppe_end_date = endDate
                return endDate
            } else {
                return nil
            }
    }

func listeJours(dateDebut: Date, dateFin: Date) -> [Date] {
    var jours: [Date] = []
    
    var currentDate = dateDebut
    while currentDate <= dateFin {
        jours.append(currentDate)
        if let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) {
            currentDate = nextDate
        } else {
            break
        }
    }
    
    return jours
}
}



/*
// Exemple d'utilisation :
let dateDebut = Date() // Remplacez cela par votre date de début
let frequence = (valeur: 7, unite: .day) // Remplacez cela par votre fréquence
if let dateFin = calculerDateFin(dateDebut: dateDebut, frequence: frequence) {
    print("Date de fin calculée : \(dateFin)")
} else {
    print("Erreur lors du calcul de la date de fin.")
}

// Exemple d'utilisation :
let dateDebut = Date() // Remplacez cela par votre date de début
let dateFin = calculerDateFin(dateDebut: dateDebut, frequence: (valeur: 14, unite: .day))! // Remplacez cela par votre date de fin
let joursEntreDates = listeJours(dateDebut: dateDebut, dateFin: dateFin)
print("Liste des jours entre la date de début et la date de fin : \(joursEntreDates)")
*/
