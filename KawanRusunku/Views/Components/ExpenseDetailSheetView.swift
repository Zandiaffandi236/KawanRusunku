import SwiftUI
import SwiftData

struct ExpenseDetailSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let expense: Expense

    @State private var showDeleteConfirmation = false
    @State private var showEditSheet = false
    @State private var editDidSave = false

    private static let limeColor = Color.lime

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM yyyy"
        return formatter.string(from: expense.createdAt)
    }

    private var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        let numberString = formatter.string(from: NSNumber(value: expense.amount)) ?? "0"
        return "Rp \(numberString)"
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                VStack(spacing: 2) {
                    Text("Let's See")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("the Damage")
                        .font(.title)
                        .fontWeight(.bold)
                        .italic()
                }
                .padding(.top, 24)

                VStack(spacing: 0) {
                    detailRow(label: "Nama", value: expense.name)
                    Divider()
                    detailRow(label: "Categories", value: expense.category)
                    Divider()
                    detailRow(label: "Price", value: formattedPrice)
                    Divider()
                    detailRow(label: "Date", value: formattedDate)
                }
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .padding(.horizontal, 24)

                Spacer()

                HStack(spacing: 16) {
                    Button {
                        showDeleteConfirmation = true
                    } label: {
                        Text("Delete")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }

                    Button {
                        showEditSheet = true
                    } label: {
                        Text("Edit")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Self.limeColor)
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .alert("Delete Expense", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                modelContext.delete(expense)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this expense?")
        }
        .sheet(isPresented: $showEditSheet, onDismiss: {
            if editDidSave {
                editDidSave = false
                dismiss()
            }
        }) {
            EditExpenseSheetView(expense: expense, onSave: { editDidSave = true })
                .presentationDetents([.fraction(0.85)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(32)
        }
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Expense.self, configurations: config)
    let sample = Expense(name: "Nasi Goreng", amount: 15000, category: "Food & Drink")
    container.mainContext.insert(sample)

    return ExpenseDetailSheetView(expense: sample)
        .modelContainer(container)
}
