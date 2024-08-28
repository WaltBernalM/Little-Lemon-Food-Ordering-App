//
//  UserProfile.swift
//  LittleLemonApp
//
//  Created by Walter Bernal on 27.08.2024.
//

import SwiftUI

struct UserProfile: View {
    @StateObject private var viewModel = ViewModel()
    
    @Environment(\.presentationMode) var presentation
    
    @State private var orderStatuses = true
    @State private var passwordChanges = true
    @State private var specialOffers = true
    @State private var newsletter = true
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    
    @State private var isLoggedOut = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            NavigationLink(destination: Onboarding(), isActive: $isLoggedOut) {
                EmptyView()
            }
            .hidden()
            
            VStack(spacing: 5) {
                VStack {
                    Text("Avatar")
                        .onboardingTextStyle()
                    HStack(spacing: 0) {
                        Image("profile-image-placeholder")
                            .resizable()
                            .aspectRatio( contentMode: .fit)
                            .frame(maxHeight: 75)
                            .clipShape(Circle())
                            .padding(.trailing)
                        Button("Change") { }
                            .buttonStyle(ButtonStylePrimaryColor1())
                        Button("Remove") { }
                            .buttonStyle(ButtonStylePrimaryColorReverse())
                        Spacer()
                    }
                }
                
                VStack{
                    Text("First name")
                        .onboardingTextStyle()
                    TextField("First Name", text: $firstName)
                }
                
                VStack {
                    Text("Last name")
                        .onboardingTextStyle()
                    TextField("Last Name", text: $lastName)
                    
                }
                
                VStack {
                    Text("E-mail")
                        .onboardingTextStyle()
                    TextField("E-mail", text: $email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                
                VStack {
                    Text("Phone number")
                        .onboardingTextStyle()
                    TextField("Phone number", text: $phoneNumber)
                        .keyboardType(.default)
                }
            }
            .textFieldStyle(.roundedBorder)
            .disableAutocorrection(true)
            .padding()
            
            Text("Email notifications")
                .font(.regularText())
                .foregroundColor(.primaryColor1)
            VStack {
                Toggle("Order statuses", isOn: $orderStatuses)
                Toggle("Password changes", isOn: $passwordChanges)
                Toggle("Special offers", isOn: $specialOffers)
                Toggle("Newsletter", isOn: $newsletter)
            }
            .padding()
            .font(Font.leadText())
            .foregroundColor(.primaryColor1)
            
            Button("Log out") {
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                UserDefaults.standard.set("", forKey: kFirstName)
                UserDefaults.standard.set("", forKey: kLastName)
                UserDefaults.standard.set("", forKey: kEmail)
                UserDefaults.standard.set("", forKey: kPhoneNumber)
                UserDefaults.standard.set(false, forKey: kOrderStatuses)
                UserDefaults.standard.set(false, forKey: kPasswordChanges)
                UserDefaults.standard.set(false, forKey: kSpecialOffers)
                UserDefaults.standard.set(false, forKey: kNewsletter)
                isLoggedOut = true
            }
            .buttonStyle(ButtonStyleYellowColorWide())
            Spacer(minLength: 20)
            HStack {
                Button("Discard Changes") {
                    discardChanges()
                }
                    .buttonStyle(ButtonStylePrimaryColorReverse())
                Button("Save changes") {
                    saveChanges()
                }
                    .buttonStyle(ButtonStylePrimaryColor1())
            }
            if viewModel.errorMessageShow {
                withAnimation() {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                }
            }
            
        }
        .onAppear {
            initFields()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentation.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .padding(10)
                .border(Color.init(red: 0.286, green: 0.368, blue: 0.341), width: 1)
                .background(Color.init(red: 0.286, green: 0.368, blue: 0.341))
                .foregroundColor(.white)
                .clipShape(Circle())
        })
        .navigationBarTitle("Personal information", displayMode: .inline)
    }
    
    private func initFields() {
        firstName = viewModel.firstName
        lastName = viewModel.lastName
        email = viewModel.email
        phoneNumber = viewModel.phoneNumber

        orderStatuses = viewModel.orderStatuses
        passwordChanges = viewModel.passwordChanges
        specialOffers = viewModel.specialOffers
        newsletter = viewModel.newsletter
    }

    private func discardChanges() {
        initFields()
        self.presentation.wrappedValue.dismiss()
    }

    private func saveChanges() {
        let validUserInput: Bool = viewModel.validateUserInput(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber)
        if !validUserInput {
            return
        }
        UserDefaults.standard.set(firstName, forKey: kFirstName)
        UserDefaults.standard.set(lastName, forKey: kLastName)
        UserDefaults.standard.set(email, forKey: kEmail)
        UserDefaults.standard.set(phoneNumber, forKey: kPhoneNumber)
        UserDefaults.standard.set(orderStatuses, forKey: kOrderStatuses)
        UserDefaults.standard.set(passwordChanges, forKey: kPasswordChanges)
        UserDefaults.standard.set(specialOffers, forKey: kSpecialOffers)
        UserDefaults.standard.set(newsletter, forKey: kNewsletter)
        self.presentation.wrappedValue.dismiss()
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
