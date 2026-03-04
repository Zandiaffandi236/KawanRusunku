//
//  ExpenseRowView.swift
//  KawanRusunku
//
//  Created by SlabPixel Designer on 03/03/26.
//
import SwiftUI

struct ExpenseRowView: View {
    let expense: Expense

    private var categoryInfo: CategoryInfo {
        CategoryInfo.info(for: expense.category)
    }

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(categoryInfo.color)
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: categoryInfo.icon)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(expense.name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Text(expense.category)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            Text("\(expense.amount, format: .currency(code: "IDR").precision(.fractionLength(0)))")
                .font(.headline)
                .foregroundColor(.red)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(8)
    }
}

#Preview {
    ExpenseRowView(expense: Expense(name: "Nasi Goreng", amount: 12000, category: "Food & Drink"))
        .padding()
        .background(Color(.systemGroupedBackground))
}



