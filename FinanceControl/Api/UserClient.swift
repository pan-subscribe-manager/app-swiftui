//
//  UserClient.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import Foundation

extension Client {
	func getMe() async throws -> UserInformationResponse {
		return try await request("/users/me/", method: "GET")
	}
}

struct UserInformationResponse: Codable, Identifiable {
	var username: String
	var full_name: String?
	var email: String?
	
	var id: String {
		get { return username }
	}
}
