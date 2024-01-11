//
//  LoginView.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import SwiftUI

struct LoginView: View {
	@EnvironmentObject private var clientService: ClientService
	@StateObject private var viewModel = LoginViewModel()
	
	var body: some View {
		NavigationStack {
			if viewModel.isBusy {
				ProgressView()
			} else {
				Form {
					TextField("Username", text: $viewModel.username)
					SecureField("Password", text: $viewModel.password)
					Button("Login") {
						Task {
							await viewModel.login(clientService: clientService)
						}
					}
				}
#if os(macOS)
				.padding()
#endif
				.alert(isPresented: $viewModel.shouldPresentErrorAlert) {
					Alert(title: Text("Login failed"), message: Text(viewModel.errorMessage!), dismissButton: .default(Text("OK")))
				}
				.navigationTitle("Login")
			}
		}
	}
}

#Preview {
	LoginView()
		.environmentObject(ClientService(client: Client.shared))
}
