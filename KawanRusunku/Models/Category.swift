//
//  Category.swift
//  KawanRusunku
//
//  Created by SlabPixel Designer on 03/03/26.
//
import SwiftUI

extension Color {
    static let lime = Color(red: 0.82, green: 0.99, blue: 0.05)
}

struct CategoryInfo {
    let name: String
    let icon: String
    let color: Color

    static let all = CategoryInfo(name: "All", icon: "line.3.horizontal.decrease.circle", color: .lime)
    static let foodDrink = CategoryInfo(name: "Food & Drink", icon: "fork.knife", color: .lime)
    static let laundry = CategoryInfo(name: "Laundry", icon: "washer.fill", color: .lime)
    static let electricity = CategoryInfo(name: "Electricity", icon: "bolt.fill", color: .lime)
    static let rent = CategoryInfo(name: "Rent", icon: "building.2.fill", color: .lime)
    static let internet = CategoryInfo(name: "Internet", icon: "wifi", color: .lime)
    static let vehicle = CategoryInfo(name: "Vehicle", icon: "car.fill", color: .lime)
    static let gerai = CategoryInfo(name: "Gerai", icon: "storefront.fill", color: .lime)
    static let others = CategoryInfo(name: "Others", icon: "storefront.fill", color: .lime)

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


