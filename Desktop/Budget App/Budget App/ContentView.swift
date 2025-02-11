//
//  ContentView.swift
//  Budget App
//
//  Created by Drew Stone on 1/7/25.
//

import SwiftUI
import EmojiPicker

struct ContentView: View {
    @State private var totalIncome: String = ""
    @State private var mandatoryExpenses: [String] = [""]
    @State private var freeSpending: [String] = [""]
    @State private var mandatoryCategories: [String] = [""]
    @State private var freeCategories: [String] = [""]
    @State private var isEmojiPickerPresented: Bool = false
    @State private var selectedExpenseIndex: Int = -1
    @State private var selectedCategory: String = ""
    
    private func calculateTotal(for expenses: [String]) -> Double {
        expenses.compactMap { Double($0) }.reduce(0, +)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    TextField("Enter total income", text: $totalIncome)
                        .keyboardType(.decimalPad)
                        .onSubmit {
                            if let number = Double(totalIncome) {
                                totalIncome = NumberFormatter.localizedString(from: NSNumber(value: number), number: .currency)
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Mandatory Expenses")
                        .font(.headline)
                    
                    MandatoryExpensesCalculation(
                        mandatoryExpenses: $mandatoryExpenses,
                        selectedExpenseIndex: $selectedExpenseIndex,
                        isEmojiPickerPresented: $isEmojiPickerPresented,
                        mandatoryCategories: $mandatoryCategories
                    )
                    
                    
                    Button(action: {
                        mandatoryExpenses.append("")
                        mandatoryCategories.append("")
                    }) {
                        Label("Add Mandatory Expense", systemImage: "plus.circle")
                    }
                    
                    HStack{
                        Text("Free Spending")
                            .font(.headline)
                        
                        let availableForFreeSpending = (Double(totalIncome) ?? 0) - calculateTotal(for: mandatoryExpenses)
                        
                        
                        Text(" $\(availableForFreeSpending, specifier: "%.2f")")
                    }
                    
                    ForEach(freeSpending.indices, id: \.self) { index in
                        HStack {
                            Button(action: {
                                selectedExpenseIndex = index
                                isEmojiPickerPresented.toggle()
                            }) {
                                Text(freeCategories[index].isEmpty ? "  " : freeCategories[index])
                                    .padding(8)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                            }
                            
                            TextField("Expense \(index + 1)", text: $freeSpending[index])
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Button(action: {
                                freeSpending.remove(at: index)
                                freeCategories.remove(at: index)
                            }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    Button(action: {
                        freeSpending.append("")
                        freeCategories.append("")
                    }) {
                        Label("Add Free Spending", systemImage: "plus.circle")
                    }
                    
                    let totalExpenses = calculateTotal(for: mandatoryExpenses) + calculateTotal(for: freeSpending)
                    let remaining = (Double(totalIncome) ?? 0) - totalExpenses

                    Text("Total Expenses: $\(totalExpenses, specifier: "%.2f")")
                    Text("Remaining Balance: $\(remaining, specifier: "%.2f")")
                }
                .padding()
            }
            .navigationTitle("Budgeting App")
            .sheet(isPresented: $isEmojiPickerPresented) {
                EmojiPickerViewControllerWrapper(selectedCategory: $selectedCategory)
                    .onDisappear {
                        if selectedExpenseIndex != -1 {
                            if mandatoryCategories.indices.contains(selectedExpenseIndex) {
                                mandatoryCategories[selectedExpenseIndex] = selectedCategory
                            } else if freeCategories.indices.contains(selectedExpenseIndex) {
                                freeCategories[selectedExpenseIndex] = selectedCategory
                            }
                        }
                    }
            }
            
        }
    }
}
#Preview {
    ContentView()
}
