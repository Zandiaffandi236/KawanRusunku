import SwiftUI
import SwiftData

struct EditExpenseSheetView: View {
    @Environment(\.dismiss) private var dismiss

    let expense: Expense
    var onSave: (() -> Void)? = nil

    @State private var name = ""
    @State private var price = ""
    @State private var selectedCategory = "Food & Drink"
    @State private var selectedDate = Date()

    let limeAccent = Color.lime

    private var isSaveDisabled: Bool {
        name.trimmingCharacters(in: .whitespaces).isEmpty || rawAmount() <= 0
    }

    private var categoriesRow1: [CategoryInfo] {
        Array(CategoryInfo.allCategories.prefix(4))
    }
    private var categoriesRow2: [CategoryInfo] {
        Array(CategoryInfo.allCategories.suffix(from: 4))
    }

    var body: some View {
        VStack(spacing: 24) {

            VStack(spacing: 0) {
                Text("Hold Up,")
                    .font(.system(size: 28, weight: .bold))
                Text("Let's Fix This.")
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
                    expense.name = name
                    expense.amount = rawAmount()
                    expense.category = selectedCategory
                    expense.createdAt = selectedDate
                    onSave?()
                    dismiss()
                }) {
                    Text("Done")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(isSaveDisabled ? .gray : .black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isSaveDisabled ? Color.gray.opacity(0.3) : limeAccent)
                        .clipShape(Capsule())
                }
                .disabled(isSaveDisabled)
            }
            .padding(.bottom, 8)
        }
        .padding(24)
        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
        .onAppear {
            name = expense.name
            price = formatNumber(String(Int(expense.amount)))
            selectedCategory = expense.category
            selectedDate = expense.createdAt
        }
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

    private func rawAmount() -> Double {
        let digits = price.filter { $0.isNumber }
        return Double(digits) ?? 0
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Expense.self, configurations: config)
    let sample = Expense(name: "Nasi Goreng", amount: 15000, category: "Food & Drink")
    container.mainContext.insert(sample)

    return EditExpenseSheetView(expense: sample)
        .modelContainer(container)
}
