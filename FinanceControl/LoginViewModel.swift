//
//  LoginViewModel.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
	@Published var username: String = ""
	@Published var password: String = ""
	@Published var isBusy: Bool = false
	@Published var error: Error? = nil
	
	var shouldPresentErrorAlert: Bool {
		get { return error != nil }
		set(shouldOpen) {
			if (shouldOpen == false) {
				error = nil
			}
		}
	}
	
	var errorMessage: String? {
		get {
			return error?.localizedDescription
		}
	}
	
	@MainActor func login(clientService: ClientService) async {
		do {
			if username.isEmpty {
				throw LoginViewModelError.emptyUsername
			}
			
			if password.isEmpty {
				throw LoginViewModelError.emptyPassword
			}
			
			isBusy = true
			defer {
				isBusy = false
			}
			
			do {
				try await clientService.login(username: username, password: password)
			} catch ClientError.unauthorized {
				throw LoginViewModelError.invalidCredential
			} catch {
				throw error
			}
		} catch {
			self.error = error
		}
	}
}


enum LoginViewModelError: Error {
	case emptyUsername
	case emptyPassword
	case invalidCredential
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
		}
	}
}
