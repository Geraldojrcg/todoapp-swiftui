//
//  PrimaryButton.swift
//  todo
//
//  Created by Geraldo Júnior on 05/12/22.
//

import SwiftUI

struct PrimaryButton: View {
    let label: String
    let isLoading: Bool
    let disabled: Bool
    
    let action: () -> Void
    
    var body: some View {
        Button { action() }
            label: {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                        .frame(maxWidth: .infinity, maxHeight: 42)
                } else {
                    Text(label)
                        .foregroundColor(disabled ? .white : Color("BackgroundColor"))
                        .bold()
                        .frame(maxWidth: .infinity, maxHeight: 42)
                }
            }
            .disabled(disabled)
            .foregroundColor(.white)
            .buttonStyle(.borderedProminent)
            .tint(Color("PrimaryColor"))
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(label: "Btn", isLoading: false, disabled: false, action: {print("clicked")})
    }
}
