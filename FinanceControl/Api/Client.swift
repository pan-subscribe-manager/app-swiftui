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
	
	func request<T: Decodable>(_ url: String, method: String, body: Data? = nil) async throws -> T {
		guard let url = URL(string: url, relativeTo: Client.BASE_URL) else {
			throw ClientError.invalidUrl
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
			throw ClientError.invalidResponse
		}
		
		if response.statusCode == 401 {
			throw ClientError.unauthorized
		}
		
		// deserialize given data to JSON
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return try decoder.decode(T.self, from: data)
	}
	
	func requestWithJson<Req: Encodable, Resp: Decodable>(_ url: String, method: String, body: Req) async throws -> Resp {
		let encoder = JSONEncoder()
		let data = try encoder.encode(body)
		
		return try await request(url, method: method, body: data)
	}
	
	func login(username: String, password: String) async throws {
		let requestDto = LoginRequestDto(username: username, password: password)
		guard let requestBody = requestDto.queryString.data(using: .utf8) else {
			throw ClientError.invalidResponse
		}
		let response: TokenResponseDto = try await request("/token", method: "POST", body: requestBody)
		
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
}

struct TokenResponseDto: Codable {
	var accessToken: String
	var tokenType: String
}
