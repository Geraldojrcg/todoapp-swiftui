import SwiftUI

public struct PlaceholderStyle: ViewModifier {
    var placeholder: String
    var showPlaceHolder: Bool
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(placeholder)
                    .foregroundColor(.white.opacity(0.5)).bold()
                    .padding()
            }
            content
            .foregroundColor(Color.white)
            
        }
    }
}

struct TextFieldModifier: ViewModifier {
    var placeholder: String
    var showPlaceHolder: Bool
    
    @FocusState private var focused: Bool

    func body(content: Content) -> some View {
        content
            .focused($focused)
            .padding()
            .foregroundColor(.white)
            .accentColor(Color("PrimaryColor"))
            .background(.black.opacity(0.2))
            .shadow(color: .gray, radius: 6)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(
                focused ? Color("PrimaryColor") : .black.opacity(0.2)))
            .modifier(PlaceholderStyle(placeholder: placeholder, showPlaceHolder: showPlaceHolder))
            .cornerRadius(10)
    }
}
