//
//  LoginView.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import SwiftUI

struct LoginView: View {
	@StateObject private var viewModel = LoginViewModel();
	
	var body: some View {
		NavigationView {
			Form {
				TextField("Username", text: viewModel.username)
				TextField("Password", text: viewModel.password)
				Button("Login") {
					Task {
						do {
							try await viewModel.login()
						} catch {
							print(error)
						}
					}
				}
			}
		}
	}
}

#Preview {
	LoginView()
}
