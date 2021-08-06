//
//  SearchView.swift
//  pragueParking
//
//  Created by Jakub Bednář on 22.06.2021.
//

import SwiftUI
import CoreLocation

struct SearchBar: UIViewRepresentable {

    @Binding var text: String?

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String?
        init(text: Binding<String?>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchBar.text
            if searchText.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    searchBar.text = self.text
                }
            }
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.searchBarStyle = .default
        searchBar.becomeFirstResponder()
        return searchBar
    }

    func updateUIView(_ searchBar: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        searchBar.text = text
    }
}
