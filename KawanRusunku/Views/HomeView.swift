import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Expense.createdAt, order: .reverse) private var expenses: [Expense]
    @AppStorage("lastBudgetMonth") private var lastBudgetMonth: String = ""
    @State private var selectedCategory = "All"
    @State private var selectedExpense: Expense?
    @State private var showingAddSheet = false
    @State private var showingBudgetSheet = false
    
    private var overallSpent: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

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
    

    private func formatDateForGrouping(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
    }

    private func dateForGroupingKey(_ key: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"

        if key == "Today" {
            return Date()
        } else if key == "Yesterday" {
            return Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        } else {
            return formatter.date(from: key) ?? Date()
        }
    }
    
    private func sectionHeader(dateKey: String, dayExpenses: [Expense]) -> some View {
        HStack {
            Text(dateKey).font(.headline).bold()
            
            Spacer()
            
            let dayTotal = dayExpenses.reduce(0) { $0 + $1.amount }
            
            Text("Rp \(dayTotal, format: .number.grouping(.automatic))")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
        .textCase(nil)
    }
    
    private var currentDateText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: Date())
    }
    
    private var dayProgressText: String {
        let calendar = Calendar.current
        let today = Date()
        
        let currentDay = calendar.component(.day, from: today)
        
        if let range = calendar.range(of: .day, in: .month, for: today) {
            let totalDays = range.count
            return "Hari ke \(currentDay)/\(totalDays)"
        }
        return ""
    }
    
    private let filterCategories = CategoryInfo.filterCategories


    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    HStack(alignment: .lastTextBaseline) {
                        Text(currentDateText)
                            .font(.title2)
                            .bold()
                        
                        Spacer()
                        
                        Text(dayProgressText)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                    
                    BudgetCardView(totalSpent: overallSpent)
                        .padding(.horizontal, 16)

                    CategoryFilterView(selectedCategory: $selectedCategory)

                    if filteredExpenses.isEmpty {
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
                    } else {
                        List {
                            ForEach(groupedExpenses, id: \.0) { dateKey, dayExpenses in
                                Section(header: sectionHeader(dateKey: dateKey, dayExpenses: dayExpenses)) {
                                    ForEach(dayExpenses, id: \.id) { expense in
                                        Button {
                                            selectedExpense = expense
                                        } label: {
                                            ExpenseRowView(expense: expense)
                                        }
                                        .buttonStyle(.plain)
                                        .listRowSeparator(.hidden)
                                        .listRowInsets(EdgeInsets())
                                        .listRowBackground(Color.clear)
                                    }
                                }
                                .listSectionSeparator(.hidden)
                            }
                        }
                        .listStyle(.plain)
                        .padding(.horizontal, 16)
                    }
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingAddSheet = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(width: 56, height: 56)
                                .background(Color.lime)
                                .clipShape(Circle())
                                .shadow(radius: 4, x: 0, y: 2)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .sheet(item: $selectedExpense) { expense in
                ExpenseDetailSheetView(expense: expense)
                    .presentationDetents([.fraction(0.75)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(32)
            }
            .sheet(isPresented: $showingAddSheet) {
                AddExpenseSheetView()
                    .presentationDetents([.fraction(0.75)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(32)
            }
            .sheet(isPresented: $showingBudgetSheet) {
                SetBudgetSheetView()
                    .presentationDetents([.fraction(0.6)])
                    .presentationCornerRadius(40)
                    .interactiveDismissDisabled()
            }
            .onAppear {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM"
                let currentMonth = formatter.string(from: Date())
                if lastBudgetMonth != currentMonth {
                    showingBudgetSheet = true
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Expense.self, configurations: config)

    let sampleData = [
        Expense(name: "Kopi V60", amount: 45000, category: "Food & Drink"),
        Expense(name: "Makan Siang", amount: 35000, category: "Food & Drink")
    ]
    sampleData.forEach { container.mainContext.insert($0) }

    return HomeView()
        .modelContainer(container)
}
