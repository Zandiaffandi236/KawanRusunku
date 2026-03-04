//
//  AddExpenseSheetView.swift
//  KawanRusunku
//
//  Created by SlabPixel Designer on 04/03/26.
//
import SwiftUI
import SwiftData

struct AddExpenseSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // State untuk input form
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var selectedDate: Date = Date()
    
    // Default dipilih "Food & Drink"
    @State private var selectedCategory: String = CategoryInfo.foodDrink.name
    
    // Warna khusus untuk aksen hijau neon
    let limeAccent = Color.lime
    
    // Membagi CategoryInfo.allCategories menjadi 2 baris (4 item pertama, dan sisanya)
    private var categoriesRow1: [CategoryInfo] {
        Array(CategoryInfo.allCategories.prefix(4))
    }
    private var categoriesRow2: [CategoryInfo] {
        Array(CategoryInfo.allCategories.suffix(from: 4))
    }
    
    var body: some View {
        VStack(spacing: 24) {
            
            VStack(spacing: 0) {
                Text("Where the")
                    .font(.system(size: 28, weight: .bold))
                Text("Cash Going?")
                    .font(.system(size: 28, weight: .bold))
                    .italic()
            }
            .padding(.top, 16)
            
            VStack(spacing: 16) {
                CustomInputField(placeholder: "Name", text: $name)
                CustomInputField(placeholder: "Price", text: $price, isNumber: true)
                    .onChange(of: price) { _, newValue in
                        let formatted = formatNumber(newValue)
                        if formatted != newValue { price = formatted }
                    }
                HStack {
                    Text("Date")
                        .italic()
                        .foregroundColor(.gray)
                    Spacer()
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .labelsHidden()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.gray.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Categories")
                    .font(.system(size: 16, weight: .bold))
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        ForEach(categoriesRow1, id: \.name) { category in
                            CategoryPill(
                                title: category.name,
                                isSelected: selectedCategory == category.name,
                                limeAccent: limeAccent
                            ) {
                                selectedCategory = category.name
                            }
                        }
                    }
                    
                    HStack(spacing: 8) {
                        ForEach(categoriesRow2, id: \.name) { category in
                            CategoryPill(
                                title: category.name,
                                isSelected: selectedCategory == category.name,
                                limeAccent: limeAccent
                            ) {
                                selectedCategory = category.name
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                
                Button(action: {
                    let newExpense = Expense(
                        name: name,
                        amount: Double(price.filter { $0.isNumber }) ?? 0,
                        category: selectedCategory,
                        createdAt: selectedDate
                    )
                    modelContext.insert(newExpense)
                    dismiss()
                }) {
                    Text("Done")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(limeAccent)
                        .clipShape(Capsule())
                }
            }
            .padding(.bottom, 8)
        }
        .padding(24)
        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
    }

    private func formatNumber(_ value: String) -> String {
        let digits = value.filter { $0.isNumber }
        guard let number = Int(digits) else { return "" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: number)) ?? digits
    }
}

// MARK: - Komponen Pendukung
struct CustomInputField: View {
    var placeholder: String
    @Binding var text: String
    var isNumber: Bool = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .italic()
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
            }
            
            TextField("", text: $text)
                .keyboardType(isNumber ? .decimalPad : .default)
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
        }
        .background(Color.gray.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let limeAccent: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isSelected ? limeAccent : Color.white)
                .clipShape(Capsule())
        }
    }
}
