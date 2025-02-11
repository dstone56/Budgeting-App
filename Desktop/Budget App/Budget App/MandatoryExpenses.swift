//
//  MandatoryExpenses.swift
//  Budget App
//
//  Created by Drew Stone on 1/10/25.
//

import SwiftUI
import EmojiPicker


struct MandatoryExpensesCalculation: View {
    @Binding var mandatoryExpenses: [String]
    @Binding var selectedExpenseIndex: Int
    @Binding var isEmojiPickerPresented: Bool
    @Binding var mandatoryCategories: [String]
    
    var body: some View {
        ForEach(mandatoryExpenses.indices, id: \.self) { index in
            HStack {
                Button(action: {
                    selectedExpenseIndex = index
                    isEmojiPickerPresented.toggle()
                }) {
                    Text(mandatoryCategories[index].isEmpty ? " " : mandatoryCategories[index])
                        .padding(7.0)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(1000)
                }
                
                TextField("Expense \(index + 1)", text: $mandatoryExpenses[index])
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
}
