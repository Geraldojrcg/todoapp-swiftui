import SwiftUI


struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var showErrorAlert: Bool = false
    
    func disabled() -> Bool {
        let emailValid = EmailValidator.validate(email: email)
        return !emailValid || password.count < 6
    }
    
    func handleLogin() {
        isLoading = true
        AuthService.login(email: email, password: password){(success) in
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
                HStack {
                    Text("ToDo")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color("PrimaryColor"))
                        .bold()
                    Text("App")
                        .font(.system(size: 32))
                        .bold()
                        .foregroundColor(.white)
                        .bold()
                        
                }.padding(.bottom, 10)
                
                Text("please login or create a new account")
                    .font(.system(size: 18))
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                
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
                    label: "Login",
                    isLoading: isLoading,
                    disabled: self.disabled(),
                    action: {
                        self.handleLogin()
                    }
                )
                    .padding(.top, 40)
                
                NavigationLink(destination: RegisterView()) {
                    Text("Don't have account? register now!")
                        .foregroundColor(Color("PrimaryColor"))
                        .padding(.top, 40)
                }
                
            }
            .padding(.horizontal, 40)
            .alert(
                "Error!",
                isPresented: $showErrorAlert,
                actions: {
                    Button("Ok", role: nil, action: {})
                },
                message: {
                    Text("Email or password is wrong")
                }
            )
        }
    }
}


struct Previews_loginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
