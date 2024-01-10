//
//  UserClient.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import Foundation

extension Client {
	func getMe() async throws -> UserInformationResponseDto {
		return try await requestForJson("/users/me", method: "GET")
	}
}

struct UserInformationResponseDto: Codable {
	var username: String
	var full_name: String?
	var email: String?
}
