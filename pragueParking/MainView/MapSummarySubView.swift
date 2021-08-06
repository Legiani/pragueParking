//
//  MapSummaryView.swift
//  pragueParking
//
//  Created by Jakub Bednář on 22.06.2021.
//

import SwiftUI
import PassKit

struct MapSummaryView: View {
    
    var name: String!
    let paymentHandler = PaymentHandler()
    
    @ObservedObject var observed = Observer()
    @State private var selectedItemId = 0

    init(_ name: String) {
        self.name = name
        
        let request = getPriceListRequest.init(licensePlate: "LOLL", placeCode: name)
        observed.getPriceList(request: request)
    }
    
    var body: some View {
       
        VStack(alignment: .leading, spacing: 10.0){
            VStack(alignment: .leading, spacing: 10.0){
                Text(name)
                    .font(.title)
                    .foregroundColor(Color(UIColor.label))
                
                if observed.priceListItem != nil {
                    Picker("Please choose something", selection: $selectedItemId) {
                        
                        ForEach(observed.priceListItem!, id: \.priceListItemID) {
                            Text("\($0.label) - \($0.price) \($0.currency ?? "")")
                        }
                        
                    }.frame(minHeight: 100)
                }else {
                    HStack{
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding(.all)
                        Spacer()
                    }
                }

                Button(action: {
                    print($selectedItemId)
                    guard let price = observed.priceListItem?[selectedItemId].price,
                          let label = observed.priceListItem?[selectedItemId].label,
                          let priceListItemId = observed.priceListItem?[selectedItemId].priceListItemID else {
                        print("chyba")
                        return
                    }
                    let total = PKPaymentSummaryItem(label: label, amount: NSDecimalNumber(string: "\(price)"), type: .final)

                    self.paymentHandler.startPayment(paymentSummaryItems: [total], priceListItemID: priceListItemId){ (success) in
                        if success {
                            
                            print("Success")
                        } else {
                            print("Failed")
                        }
                    }
                }, label: {
                    HStack{
                        Spacer()
                        Text("PAY WITH  APPLE")
                            .font(Font.custom("HelveticaNeue-Bold", size: 16))
                            .padding(10)
                            .foregroundColor(.white)
                        Spacer()
                    }

                }).frame(maxWidth: .infinity)
                .background(Color(UIColor.systemGray))
                .overlay(
                   RoundedRectangle(cornerRadius: 5)
                       .stroke(Color.white, lineWidth: 2)
                )
            }
            .padding(20)
        }
        .background(Color(UIColor.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 40))
    }
}

struct MapSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        MapSummaryView("P33-0987").previewLayout(.sizeThatFits)
    }
}
