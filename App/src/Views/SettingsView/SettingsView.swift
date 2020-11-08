import SwiftUI

struct SettingsView: View {
    @Binding var isModalVisible: Bool
    @ObservedObject var settingsViewModel = SettingsViewModel()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            VStack {
                Image("Logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 100)
                    .padding(.top, 20)
                
                Text("Thanks for using")
                    .font(.title)
                
                Text("Make It So")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Form {
                    Section {
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text("App Icon")
                            Spacer()
                            Text("Plain")
                        }
                    }
                    
                    Section {
                        HStack {
                            Image("Siri")
                                .resizable()
                                .frame(width: 17, height: 17)
                            Text("Siri")
                        }
                    }
                    
                    Section {
                        HStack {
                            Image(systemName: "questionmark.circle")
                            Text("Help & Feedback")
                        }
                        NavigationLink(destination: Text("About!") ) {
                            HStack {
                                Image(systemName: "info.circle")
                                Text("About")
                            }
                        }
                    }
                    
                    AccountSection(isModalVisible: $isModalVisible, settingsViewModel: self.settingsViewModel)
                }
                .navigationBarTitle("Settings", displayMode: .inline)
                .navigationBarItems(trailing:
                                        Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                                            Text("Done")
                                        })
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isModalVisible: .constant(false))
    }
}

struct AccountSection: View {
    @Binding var isModalVisible: Bool

    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var authenticationService = AuthenticationService()
    
    @State private var showAuthView = false
 
    var body: some View {
        Section(footer: footer) {
            button
        }
    }
    
    var footer: some View {
        HStack {
            Spacer()
            if authenticationService.isAuth {
                VStack {
                    Text("Thanks for using Make It So, \(self.settingsViewModel.displayName)!")
                    Text("Logged in as \(self.settingsViewModel.email)")
                }
            }
            else {
                
                
                Text("You're not logged in.")
            }
            Spacer()
            
            
            
        }
    }
    
    var button: some View {
        VStack {
            if authenticationService.isAuth {
                Button(action: {  self.logout() }) {
                    HStack {
                        Spacer()
                        Text("Logout")
                        Spacer()
                    }
                }}
            
            else {
                Button(action: { self.login() }) {
                    HStack {
                        Spacer()
                        Text("Login")
                        Spacer()
                    }
                }
            }
            
        }
        
        .sheet(isPresented: self.$showAuthView) {
            AuthView()
        }
    }
    
    func login() {
        self.showAuthView.toggle()
    }
    
    func logout() {
        self.settingsViewModel.logout()
        self.isModalVisible = false
     }
    
}
