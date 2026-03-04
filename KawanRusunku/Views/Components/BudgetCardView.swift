//
//  BudgetCardView.swift
//  KawanRusunku
//
//  Created by SlabPixel Designer on 03/03/26.
//
import SwiftUI

struct BudgetCardView: View {
    @AppStorage("monthlyBudget") private var monthlyBudget: Double = 0
    let totalSpent: Double
    @State private var showBudgetEditor = false

    private var progressPercentage: Double {
        guard monthlyBudget > 0 else { return 0 }
        return min(totalSpent / monthlyBudget, 1.0)
    }

    private var progressColor: Color {
        guard monthlyBudget > 0 else { return .gray }
        let percentage = progressPercentage * 100
        if percentage < 75 {
            return .green
        } else if percentage < 90 {
            return .yellow
        } else {
            return .red
        }
    }

    private var remainingAmount: Double {
        max(monthlyBudget - totalSpent, 0)
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Monthly Budget")
                    .font(.body)
                    .foregroundColor(.gray)

                Spacer()

                Button(action: { showBudgetEditor = true }) {
                    Text("\(monthlyBudget, format: .currency(code: "IDR").precision(.fractionLength(0)))")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))

                    if monthlyBudget > 0 {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(progressColor)
                            .frame(width: geometry.size.width * (1.0 - progressPercentage ))
                    }
                }
            }
            .frame(height: 8)

            HStack {
                Text("Spent \(totalSpent, format: .currency(code: "IDR").precision(.fractionLength(0))) of \(monthlyBudget, format: .currency(code: "IDR").precision(.fractionLength(0)))")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()

                Text("Remaining: \(remainingAmount, format: .currency(code: "IDR").precision(.fractionLength(0)))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4, x: 0, y: 2)
        .shadow(color: Color.black.opacity(0.1), radius: 4)
        .alert("Edit Budget", isPresented: $showBudgetEditor) {
            TextField("Budget amount", value: $monthlyBudget, format: .number)
                .keyboardType(.decimalPad)

            Button("Cancel", role: .cancel) { }
            Button("Save") { }
        }
    }
}

#Preview {
    BudgetCardView(totalSpent: 300000)
        .padding()
        .background(Color(.systemGroupedBackground))
}



