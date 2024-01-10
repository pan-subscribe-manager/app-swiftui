//
//  LoginDto.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import Foundation

struct LoginRequestDto: Codable {
	var username: String
	var password: String
	
	var queryString: String {
		get {
			return "username=\(username)&password=\(password)"
		}
	}
	
	func encodeToData() throws -> Data {
		guard let queryString = queryString.data(using: .utf8) else {
			throw ClientError.InvalidResponse
		}
		
		return queryString
	}
}

struct TokenResponseDto: Codable {
	var accessToken: String
	var tokenType: String
}
