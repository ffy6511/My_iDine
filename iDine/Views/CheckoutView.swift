//
//  CheckoutView.swift
//  iDine
//
//  Created by Paul Hudson on 08/02/2021.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var order: Order
    @State private var paymentType = "Cash"
    @State private var addLoyaltyDetails = false
    @State private var loyaltyNumber = ""
    @State private var tipAmount = 15
    @State private var showingPaymentAlert = false
    @State private var pickUpTime = "Now"

    let paymentTypes = ["Cash", "Credit Card", "iDine Points"]
    let tipAmounts = [10, 15, 20, 25, 0]
    let pickUpTimes = ["Now", "Tonight", "Tomorrow Moring"]

    var totalPrice: String {
        let total = Double(order.total)
        let tipValue = total / 100 * Double(tipAmount)
        return (total + tipValue).formatted(.currency(code: "USD"))
    }

    var body: some View {
        Form {
            Section {
                Picker("How do you want to pay?", selection: $paymentType) {
                    ForEach(paymentTypes, id: \.self) {
                        Text($0)
                    }
                }

                Toggle("Add iDine loyalty card", isOn: $addLoyaltyDetails.animation())

                if addLoyaltyDetails {
                    TextField("Enter your iDine ID", text: $loyaltyNumber)
                }
            }

            Section("Add a tip?") {
                Picker("Percentage:", selection: $tipAmount) {
                    ForEach(tipAmounts, id: \.self) {
                        Text("\($0)%")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section("When do you want to pick up?"){
                Picker("I will pick up", selection: $pickUpTime){
                    ForEach(pickUpTimes, id:\.self){
                        Text("\($0)")
                    }
                }
            }

            Section("Total: \(totalPrice)") {
                
                HStack{
                    Spacer()
                    Button("Confirm order") {
                        showingPaymentAlert.toggle()
                    }
                    Spacer()
                }
                
            }
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Order confirmed", isPresented: $showingPaymentAlert) {
            // no buttons needed
        } message: {
            Text("Your total was \(totalPrice) \n Remeber to pick up \(pickUpTime) \n \n  Thank you!")
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
            .environmentObject(Order())
    }
}
