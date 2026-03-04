import SwiftUI
import SwiftData

struct ExpenseFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Binding var navigationPath: NavigationPath

    let expense: Expense?
    
    @State private var name = ""
    @State private var amount = ""
    @State private var selectedCategory = "Food & Drink"
    @State private var showDeleteConfirmation = false

    private var isEditMode: Bool { expense != nil }

    private var isSaveDisabled: Bool {
        name.trimmingCharacters(in: .whitespaces).isEmpty || (Double(amount) ?? 0) <= 0
    }

    var body: some View {
        // Hapus NavigationStack dari sini
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                formFields
                categorySelection
                Spacer()
                actionButtons
            }
            .padding(.vertical, 16)
        }
        .navigationTitle(isEditMode ? "Edit Expense" : "New Expense")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let expense = expense {
                name = expense.name
                amount = String(format: "%.2f", expense.amount)
                selectedCategory = expense.category
            }
        }
    }

    // MARK: - Subviews
    private var formFields: some View {
        VStack(spacing: 12) {
            TextField("Expense name", text: $name)
                .padding(12)
                .background(Color.white)
                .cornerRadius(8)
            
            HStack(spacing: 8) {
                Text("Rp").font(.headline).padding(.leading, 12)
                TextField("0.00", text: $amount)
                    .keyboardType(.numberPad)
                    .padding(.vertical, 12)
            }
            .background(Color.white)
            .cornerRadius(8)
        }
        .padding(.horizontal, 16)
    }

    private var categorySelection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Category").font(.headline).padding(.horizontal, 16)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(CategoryInfo.allCategories, id: \.name) { category in
                        CategoryPillView(
                            category: category,
                            isSelected: selectedCategory == category.name,
                            action: { selectedCategory = category.name }
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            if isEditMode {
                deleteButton
            }
            
            HStack(spacing: 12) {
                cancelButton
                saveButton
            }
        }
        .padding(.horizontal, 16)
    }

    private var saveButton: some View {
        Button {
            if let expense = expense {
                expense.name = name
                expense.amount = Double(amount) ?? 0
                expense.category = selectedCategory
            } else {
                let newExpense = Expense(name: name, amount: Double(amount) ?? 0, category: selectedCategory)
                modelContext.insert(newExpense)
            }
            navigationPath = NavigationPath() // Kembali ke Home
        } label: {
            Text("Save")
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(isSaveDisabled ? Color.gray.opacity(0.2) : Color.blue)
                .foregroundColor(isSaveDisabled ? .gray : .white)
                .cornerRadius(8)
        }
        .disabled(isSaveDisabled)
    }

    private var cancelButton: some View {
        Button(role: .cancel) {
            dismiss()
        } label: {
            Text("Cancel")
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.black)
                .cornerRadius(8)
        }
    }

    private var deleteButton: some View {
        Button(role: .destructive) {
            showDeleteConfirmation = true
        } label: {
            Text("Delete")
                .frame(maxWidth: .infinity)
                .padding(12)
                .foregroundColor(.red)
                .background(Color.white)
                .cornerRadius(8)
        }
        .alert("Delete Expense", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let expense = expense {
                    modelContext.delete(expense)
                    navigationPath = NavigationPath()
                }
            }
        } message: {
            Text("Are you sure you want to delete this expense?")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Expense.self, configurations: config)
    
    NavigationStack {
        ExpenseFormView(navigationPath: .constant(NavigationPath()), expense: nil)
    }
    .modelContainer(container)
}
