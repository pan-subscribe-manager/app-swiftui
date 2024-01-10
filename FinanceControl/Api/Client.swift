//
//  Client.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import Foundation

class Client {
	static let BASE_URL = URL(string: "http://127.0.0.1:8000")!;
	
	static let shared: Client = Client();
	private var jwtToken: String?;
	
	private let urlSession: URLSession;
	
	init() {
		urlSession = URLSession(configuration: .default)
	}
	
	func requestForJson<T: Codable>(_ url: String, method: String, body: Data? = nil) async throws -> T {
		guard let url = URL(string: url, relativeTo: Client.BASE_URL) else {
			throw ClientError.InvalidUrl
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = method
		if let token = jwtToken {
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		if let body = body {
			request.httpBody = body
		}
		
		let (data, response) = try await urlSession.data(for: request)
		guard let response = response as? HTTPURLResponse else {
			throw ClientError.InvalidResponse
		}
		
		if response.statusCode == 401 {
			throw ClientError.Unauthorized
		}
		
		// deserialize given data to JSON
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return try decoder.decode(T.self, from: data)
	}
	
	func login(username: String, password: String) async throws {
		let requestBody = try LoginRequestDto(username: username, password: password).encodeToData()
		let response: TokenResponseDto = try await requestForJson("/token", method: "POST", body: requestBody)
		
		// write token to this client instance
		jwtToken = response.accessToken
	}
	
	func logout() {
		jwtToken = nil
	}
}

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
