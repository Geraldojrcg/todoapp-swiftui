import SwiftUI

struct PrimaryTextField: View {
    let placeholder: String
    @Binding var text: String
    var showPlaceHolder: Bool
    var secured: Bool = false
    
    func getModifier() -> TextFieldModifier {
        return TextFieldModifier(placeholder: placeholder, showPlaceHolder: showPlaceHolder)
    }
    
    @FocusState private var focused: Bool
    
    var body: some View {
        if secured {
            SecureField(placeholder, text: $text)
                .modifier(self.getModifier())
        }
        else {
            TextField(placeholder, text: $text)
                .modifier(self.getModifier())
        }
    }
}
