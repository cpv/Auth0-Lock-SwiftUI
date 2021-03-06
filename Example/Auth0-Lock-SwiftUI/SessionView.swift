import SwiftUI
import Auth0
import Auth0_Lock_SwiftUI

struct SessionView: View {
    
    @ObservedObject var session = SessionPublisher()
    @State var showingLogin = false
    
    var body: some View {
        switch session.viewModel {
        case .loading:
            return makeLoadingView()
        case .error(let error):
            return VStack {
                makeErrorView(error)
                
                Button(action: {
                    self.showingLogin.toggle()
                }) {
                    Text("Please try log in again")
                }.sheet(isPresented: $showingLogin) {
                    AuthView(session: self.session)
                }.padding()
            }.anyView
        case .guest:
            return Button(action: {
                self.showingLogin.toggle()
            }) {
                Text("Please log in")
            }.sheet(isPresented: $showingLogin) {
                AuthView(session: self.session)
            }.padding().anyView
        case .hasSession(user: let userName, let credentials):
            return VStack(alignment: .center, spacing: 32) {
                Text("Welcome \(userName.name!)!")
                
                Text("Your token expires in \(credentials.expiresIn!)")
                
                Button.init("Logout") {
                    self.session.logout()
                }
            }.anyView
        }
    }
}
