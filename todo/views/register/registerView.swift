import SwiftUI

struct RegisterView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var showErrorAlert: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    func disabled() -> Bool {
        let emailValid = EmailValidator.validate(email: email)
        return !emailValid || password.count < 6 || name.isEmpty
    }
    
    func handleRegister() {
        isLoading = true
        let model = RegisterModel(name: name, email: email, password: password)
        AuthService.register(model: model) {(success) in
            if success {
                NotificationCenter.default.post(name: Notification.Name("goToHome"), object: nil)
            } else {
                showErrorAlert = true
            }
            isLoading = false
        }
    }
    
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            
            VStack {
                Text("Register")
                    .font(.system(size: 32))
                    .bold()
                    .foregroundColor(Color("PrimaryColor"))
                    .bold()
                    .padding(.bottom, 10)
                
                Text("Please fill all informattions to complete the registration")
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                
                PrimaryTextField(
                    placeholder:"Name",
                    text: $name,
                    showPlaceHolder: name.isEmpty
                )
                
                PrimaryTextField(
                    placeholder:"Email",
                    text: $email,
                    showPlaceHolder: email.isEmpty
                )
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                PrimaryTextField(
                    placeholder:"Password",
                    text: $password,
                    showPlaceHolder: password.isEmpty,
                    secured: true
                )
                    .autocapitalization(.none)
                
                PrimaryButton(
                    label: "Register",
                    isLoading: isLoading,
                    disabled: self.disabled(),
                    action: {
                        self.handleRegister()
                    }
                )
                    .padding(.top, 40)

                Button("Cancel")
                {
                    self.presentationMode.wrappedValue.dismiss()
                }
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
            }
            .padding(.horizontal, 20)
            .alert(
                "Error!",
                isPresented: $showErrorAlert,
                actions: {
                    Button("Ok", role: nil, action: {})
                },
                message: {
                    Text("Error while registering your account")
                }
            )
        }
    }
}

struct Previews_registerView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
