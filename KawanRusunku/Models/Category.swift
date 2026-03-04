//
//  Category.swift
//  KawanRusunku
//
//  Created by SlabPixel Designer on 03/03/26.
//
import SwiftUI

struct CategoryInfo {
    let name: String
    let icon: String
    let color: Color

    static let all = CategoryInfo(name: "All", icon: "line.3.horizontal.decrease.circle", color: .gray)
    static let foodDrink = CategoryInfo(name: "Food & Drink", icon: "fork.knife", color: .orange)
    static let laundry = CategoryInfo(name: "Laundry", icon: "washer.fill", color: .blue)
    static let electricity = CategoryInfo(name: "Electricity", icon: "bolt.fill", color: .yellow)
    static let rent = CategoryInfo(name: "Rent", icon: "building.2.fill", color: .gray)
    static let internet = CategoryInfo(name: "Internet", icon: "wifi", color: .blue)
    static let vehicle = CategoryInfo(name: "Vehicle", icon: "car.fill", color: .blue)
    static let gerai = CategoryInfo(name: "Gerai", icon: "storefront.fill", color: .pink)
    static let others = CategoryInfo(name: "Others", icon: "storefront.fill", color: .gray)

    static var allCategories: [CategoryInfo] {
        [.foodDrink, .laundry, .electricity, .rent, .internet, .vehicle, .gerai, .others]
    }

    static var filterCategories: [CategoryInfo] {
        [.all, .foodDrink, .laundry, .electricity, .rent, .internet, .vehicle, .gerai, .others]
    }

    static func info(for categoryName: String) -> CategoryInfo {
        switch categoryName {
        case "Food & Drink": return .foodDrink
        case "Laundry": return .laundry
        case "Electricity": return .electricity
        case "Rent": return .rent
        case "Internet": return .internet
        case "Vehicle": return .vehicle
        case "Gerai": return .gerai
        case "Others": return .others
        default: return .foodDrink
        }
    }
}
