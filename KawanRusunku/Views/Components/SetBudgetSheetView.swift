//
//  SetBudgetSheetView.swift
//  KawanRusunku
//
//  Created by SlabPixel Designer on 04/03/26.
//
import SwiftUI

struct SetBudgetSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Simpan budget ke memori perangkat
    @AppStorage("monthlyBudget") private var monthlyBudget: Double = 0.0
    // Menyimpan rekam jejak bulan terakhir user mengatur budget
    @AppStorage("lastBudgetMonth") private var lastBudgetMonth: String = ""
    
    @State private var budgetInput: String = ""
    
    let limeAccent = Color.lime
    
    var body: some View {
        VStack(spacing: 40) {
            
            VStack(spacing: 0) {
                Text("Kickstart Your")
                    .font(.system(size: 32, weight: .bold))
                Text("Survival Fuel")
                    .font(.system(size: 32, weight: .bold))
                    .italic()
            }
            .padding(.top, 40)
            
            ZStack {
                // Background Box Abu-abu
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(UIColor.secondarySystemBackground))
                    .frame(height: 140)
                
                VStack {
                    HStack(alignment: .top, spacing: 8) {
                        // Label Rp
                        Text("Rp")
                            .font(.system(size: 24, weight: .semibold))
                            .padding(.top, 12)
                        
                        // Input Angka
                        TextField("0", text: $budgetInput)
                            .keyboardType(.numberPad)
                            .font(.system(size: 54, weight: .bold))
                            .multilineTextAlignment(.center)
                            .onChange(of: budgetInput) { _, newValue in
                                let formatted = formatNumber(newValue)
                                if formatted != newValue { budgetInput = formatted }
                            }
                    }
                    
                    HStack {
                        Spacer()
                        // Label /month
                        Text("/month")
                            .italic()
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.horizontal, 20)
            
            Button(action: {
                let digits = budgetInput.filter { $0.isNumber }
                if let amount = Double(digits), amount > 0 {
                    monthlyBudget = amount
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM"
                    lastBudgetMonth = formatter.string(from: Date())
                    
                    dismiss() // Tutup sheet
                }
            }) {
                ZStack {
                    Circle()
                        .fill(budgetInput.isEmpty ? Color.gray.opacity(0.3) : limeAccent)
                        .frame(width: 72, height: 72)
                        .shadow(color: budgetInput.isEmpty ? .clear : limeAccent.opacity(0.4), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(budgetInput.isEmpty ? .gray : .black)
                }
            }
            .disabled(budgetInput.isEmpty)
            
            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground))
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

#Preview {
    Text("Latar Belakang")
        .sheet(isPresented: .constant(true)) {
            SetBudgetSheetView()
                .presentationDetents([.fraction(0.6)])
                .presentationCornerRadius(40)
                .interactiveDismissDisabled()
        }
}
