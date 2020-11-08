import SwiftUI
import Firebase
import AuthenticationServices
import CryptoKit
import GoogleSignIn

struct AuthView: View {
    @Environment(\.window) var window: UIWindow?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var signInHandler: SignInWithAppleCoordinator?
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 100)
                .padding(.top, 100)
                .padding(.bottom, 50)
            
            HStack {
                Text("Welcome to")
                    .font(.title)
                
                Text("Make It So")
                    .font(.title)
                    .fontWeight(.semibold)
            }
            
            Text("Create an account to save your tasks and access them anywhere. It's free. \n Forever.")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            Spacer()
            
            SignInWithAppleButton(  onRequest: { (request) in
                self.signInWithAppleButtonTapped()
            }, onCompletion: { (response) in })
                .frame(width: 280, height: 45)
                
            
            Button(action: {
                GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
                GIDSignIn.sharedInstance()?.signIn()
            }, label: {
                Image("ic_google").frame(width: 20, height: 20)
            })
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(Color.white)
            .cornerRadius(8.0)
            .shadow(radius: 4.0)
            
            
            Divider()
                .padding(.horizontal, 15.0)
                .padding(.top, 20.0)
                .padding(.bottom, 15.0)
            
            
            Text("By using Make It So you agree to our Terms of Use and Service Policy")
                .multilineTextAlignment(.center)
        }
    }
    
    func signInWithAppleButtonTapped() {
        signInHandler = SignInWithAppleCoordinator(window: self.window)
        signInHandler?.link { (user) in
            print("User signed in. UID: \(user.uid), email: \(user.email ?? "(empty)")")
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
