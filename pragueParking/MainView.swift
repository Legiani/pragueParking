//
//  ContentView.swift
//  pragueParking
//
//  Created by Jakub Bednář on 21.06.2021.
//

import SwiftUI
import MapKit

struct MainView: View {
    
    @State public var selected: String?
    @State private var showSerch = false {
        willSet {
            self.selected = nil
        }
    }
    @State public var searchText: String?
    @State var isLinkActive = false
    
    var body: some View {
        NavigationView {
            ZStack {
                MapView(selected: $selected, search: $searchText)
                    .edgesIgnoringSafeArea(.all)
                
                
                VStack(alignment: .center, spacing: 10.0){
                    HStack{
                        Spacer()
                        HStack(alignment: .top) {
                            if self.showSerch {
                                SearchBar(text: $searchText)
                            }
                            
                            Button {
                                withAnimation {
                                    self.showSerch.toggle()
                                }
                            } label: {
                                
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                                    .padding(.all, 4)
                                
                            }
                        }.background(Color(UIColor.systemGray5))
                        .cornerRadius(10)
                        
                    }
                    
                    HStack{
                        Spacer()
                        NavigationLink(destination: Text("OtherView"), isActive: $isLinkActive) {
                            Button {
                                self.isLinkActive = true
                                
                            } label: {
                                
                                Image(systemName: "cart.circle.fill")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                                    .padding(.all, 4)
                            }.background(Color(UIColor.systemGray5))
                            .cornerRadius(10)
                        }
                        
                    }
                    
                    Spacer()
                    if selected != nil {
                        MapSummaryView(selected ?? "nic")
                           
                    }
                }.padding(.all, 10)
            }.navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView(searchText: nil)
                .previewDevice("iPhone 11")
        }
    }
}


//HStack(spacing: 0.0){
//    Button {
//        self.section = 0
//    } label: {
//        HStack{
//            Label("Mapa", systemImage: "map.fill")
//                .foregroundColor(Color.white)
//                .font(.headline)
//                .frame(maxWidth: .infinity)
//                .padding(.vertical)
//        }
//        .background(RoundedCorners(color: self.section != 0 ? Color(UIColor.systemGray5) : Color(UIColor.systemGray), tl: 30, bl: 30))
//
//    }
//    .padding([.top, .leading, .bottom], 10)
//    .frame(maxWidth: .infinity)
//
//    Button {
//        self.section = 1
//    } label: {
//        HStack{
//            Label("Přehled", systemImage: "text.justify")
//                .foregroundColor(Color.white)
//                .font(.headline)
//                .frame(maxWidth: .infinity)
//                .padding(.vertical)
//
//        }
//        .background(RoundedCorners(color: self.section != 1 ? Color(UIColor.systemGray5) : Color(UIColor.systemGray), tr: 30, br: 30))
//    }
//    .padding([.top, .trailing, .bottom], 10)
//    .frame(maxWidth: .infinity)
//}
//.background(Color(UIColor.systemGray5))
//.cornerRadius(30)
//.frame(minWidth: .none, idealWidth: .infinity, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: .none, idealHeight: .none, maxHeight: .none, alignment: .top)
//
