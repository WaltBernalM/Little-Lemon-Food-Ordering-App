//
//  HeaderBar.swift
//  LittleLemonApp
//
//  Created by Walter Bernal on 27.08.2024.
//

import SwiftUI

struct Header: View {
    @State var isLoggedIn = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("logo")
                HStack {
                    Spacer()
                    if isLoggedIn {
                        NavigationLink(destination: UserProfile()) {
                            Image("profile-image-placeholder")
                                .resizable()
                                .aspectRatio( contentMode: .fit)
                                .frame(maxHeight: 50)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                    }
                }
            }
        }
        .frame(maxHeight: 60)
        .padding(.bottom)
        .onAppear() {
            if UserDefaults.standard.bool(forKey: kIsLoggedIn) {
                isLoggedIn = true
            } else {
                isLoggedIn = false
            }
        }
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header()
    }
}
