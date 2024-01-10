//
//  ClientService.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import Foundation

class ClientService: ObservableObject {
	var client: Client
	@Published var isLoggedIn: Bool = false
	
	init(client: Client = Client.shared) {
		self.client = client
	}
	
	func login(username: String, password: String) async throws {
		try await client.login(username: username, password: password)
		DispatchQueue.main.async { [unowned self] in
			self.isLoggedIn = true
		}
	}
	
	/// run is the wrapper of Client, which accepts a closure that calls the Client methods,
	/// and *logout* for Unauthorized errors.
	func run<T>(_ op: (Client) async throws -> T) async throws -> T {
		do {
			return try await op(client)
		} catch ClientError.unauthorized {
			DispatchQueue.main.async { [unowned self] in
				self.isLoggedIn = false
			}
			client.logout()
			throw ClientError.unauthorized
		}
	}
}
