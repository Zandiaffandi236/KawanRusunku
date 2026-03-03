import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Expense.createdAt, order: .reverse) private var expenses: [Expense]
    
    @State private var selectedCategory = "All"
    @State private var navigationPath = NavigationPath()

    private var totalSpent: Double {
        filteredExpenses.reduce(0) { $0 + $1.amount }
    }

    private var filteredExpenses: [Expense] {
        if selectedCategory == "All" {
            return expenses
        }
        return expenses.filter { $0.category == selectedCategory }
    }

    private var groupedExpenses: [(String, [Expense])] {
        let grouped = Dictionary(grouping: filteredExpenses) { expense in
            formatDateForGrouping(expense.createdAt)
        }
        return grouped.sorted { a, b in
            dateForGroupingKey(a.key) > dateForGroupingKey(b.key)
        }
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    BudgetCardView(totalSpent: totalSpent)
                        .padding(.horizontal, 16)

                    CategoryFilterView(selectedCategory: $selectedCategory)

                    if filteredExpenses.isEmpty {
                        emptyStateView
                    } else {
                        expenseListView
                    }
                }

                // Floating Action Button
                fabButton
            }
            .navigationTitle("Expenses")
            // PUSAT NAVIGASI: Satu tempat untuk semua tipe data
            .navigationDestination(for: Expense.self) { expense in
                ExpenseFormView(navigationPath: $navigationPath, expense: expense)
            }
            .navigationDestination(for: String.self) { value in
                if value == "create" {
                    ExpenseFormView(navigationPath: $navigationPath, expense: nil)
                }
            }
        }
    }

    // MARK: - Subviews
    private var expenseListView: some View {
        List {
            ForEach(groupedExpenses, id: \.0) { dateKey, dayExpenses in
                Section(header: Text(dateKey).font(.headline)) {
                    ForEach(dayExpenses) { expense in
                        NavigationLink(value: expense) {
                            ExpenseRowView(expense: expense)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "wallet.pass")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            Text("No expenses yet")
                .font(.headline)
            Text("Tap + to add your first expense")
                .font(.caption)
                .foregroundColor(.gray)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var fabButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink(value: "create") {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 4, x: 0, y: 2)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 30)
            }
        }
    }

    // MARK: - Helper Functions
    private func formatDateForGrouping(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return "Today" }
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }

    private func dateForGroupingKey(_ key: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        if key == "Today" { return Date() }
        if key == "Yesterday" { return Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date() }
        return formatter.date(from: key) ?? Date()
    }
}
