//
//  Expense.swift
//  KawanRusunku
//
//  Created by SlabPixel Designer on 03/03/26.
//
import Foundation
import SwiftData

@Model
final class Expense {
    var id: UUID
    var name: String
    var amount: Double
    var category: String
    var createdAt: Date

    init(name: String, amount: Double, category: String) {
        self.id = UUID()
        self.name = name
        self.amount = amount
        self.category = category
        self.createdAt = Date()
    }
}

