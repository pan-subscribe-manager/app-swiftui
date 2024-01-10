//
//  LoginViewModel.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import Foundation

class LoginViewModel: ObservableObject {
	var client: Client
	
	@Published var username: String
	@Published var password: String
	
	init(client: Client, username: String = "", password: String = "") {
		self.client = client
		self.username = username
		self.password = password
	}
	
	func login() async throws {
		if username.isEmpty {
			throw LoginViewModelError.emptyUsername
		}
		
		if password.isEmpty {
			throw LoginViewModelError.emptyPassword
		}
		
		do {
			try await client.login(username: username, password: password)
		} catch ClientError.Unauthorized {
			throw LoginViewModelError.invalidCredential
		} catch {
			guard let error = error as? ClientError else {
				throw error
			}
			
			throw LoginViewModelError.otherClientError(error)
		}
	}
}


enum LoginViewModelError: Error {
	case emptyUsername
	case emptyPassword
	case invalidCredential
	case otherClientError(ClientError)
}

extension LoginViewModelError: LocalizedError {
	public var errorDescription: String? {
		switch (self) {
			case .emptyUsername:
				return NSLocalizedString("Username is required.", comment: "LoginViewModelError")
			case .emptyPassword:
				return NSLocalizedString("Password is required.", comment: "LoginViewModelError")
			case .invalidCredential:
				return NSLocalizedString("Invalid username or password pair.", comment: "LoginViewModelError")
			case .otherClientError(let clientError):
				return String(
					format: NSLocalizedString("Client error: %@", comment: "LoginViewModelError"),
					clientError.errorDescription ?? "(no description)"
				)
		}
	}
}
