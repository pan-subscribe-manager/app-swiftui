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
	
	init(client: Client = Client.shared, logout: Bool = false) {
		self.client = client
	}
	
	func login(username: String, password: String) async throws {
		try await client.login(username: username, password: password)
		await MainActor.run { [unowned self] in
			self.isLoggedIn = true
		}
	}
	
	/// run is the wrapper of Client, which accepts a closure that calls the Client methods,
	/// and *logout* for Unauthorized errors.
	func run<T>(_ op: (Client) async throws -> T) async rethrows -> T {
		do {
			return try await op(client)
		} catch ClientError.unauthorized(let detail) {
			await MainActor.run { [unowned self] in
				self.isLoggedIn = false
			}
			client.logout()
			throw ClientError.unauthorized(detail: detail)
		}
	}
}
