//
//  Payee.swift
//  MyAppController
//
//  Created by Antoine Himpens on 28/10/2023.
//

import SwiftUI
import SwiftData

@Model class Payee : Codable {
    var payee_id: UUID
    var payee_name: String
    var payee_default_category: Category?

    init(payee_id: UUID = UUID(), payee_name: String = "", payee_default_category: Category? = nil) {
      self.payee_id = payee_id
      self.payee_name = payee_name
        self.payee_default_category = payee_default_category
  }

  func description() -> String {
    return "Name: \(payee_name)]"
  }

  func update(payee_name: String, payee_default_category: Category) {
    self.payee_name = payee_name
    self.payee_default_category = payee_default_category
  }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        payee_id = try values.decode(UUID.self, forKey: .payee_id)
        payee_name = try values.decode(String.self, forKey: .payee_name)
        payee_default_category = try values.decodeIfPresent(Category.self, forKey: .payee_default_category)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(payee_id, forKey: .payee_id)
        try container.encode(payee_name, forKey: .payee_name)
        try container.encodeIfPresent(payee_default_category, forKey: .payee_default_category)
    }

    enum CodingKeys: String, CodingKey {
        case payee_id
        case payee_name
        case payee_default_category
    }
    
    
}
