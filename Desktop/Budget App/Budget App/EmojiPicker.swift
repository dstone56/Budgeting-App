//
//  EmojiPicker.swift
//  Budget App
//
//  Created by Drew Stone on 1/8/25.
//

import SwiftUI
import EmojiPicker

struct EmojiPickerViewControllerWrapper: View {
    @Binding var selectedCategory: String
    
    var body: some View {
        EmojiPickerViewControllerRepresentable(selectedCategory: $selectedCategory)
            .edgesIgnoringSafeArea(.bottom)
    }
}

struct EmojiPickerViewControllerRepresentable: UIViewControllerRepresentable {
    @Binding var selectedCategory: String
    
    func makeUIViewController(context: Context) -> EmojiPickerViewController {
        let pickerViewController = EmojiPickerViewController()
        pickerViewController.delegate = context.coordinator
        return pickerViewController
    }
    
    func updateUIViewController(_ uiViewController: EmojiPickerViewController, context: Context) {
        // Update the view controller if needed.
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedCategory: $selectedCategory)
    }
    
    class Coordinator: NSObject, EmojiPickerDelegate {
        @Binding var selectedCategory: String
        
        init(selectedCategory: Binding<String>) {
            _selectedCategory = selectedCategory
        }
        
        func didGetEmoji(emoji: String) {
            selectedCategory = emoji
        }
    }
}
