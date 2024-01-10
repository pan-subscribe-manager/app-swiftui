//
//  MethodClient.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import Foundation

extension Client {
	func listMethods() async throws -> Array<MethodDto> {
		return try await request("/methods", method: "GET")
	}
	
	func getMethod(methodId: String) async throws -> MethodDto {
		return try await request("/methods/\(methodId)", method: "GET")
	}
	
	func createMethod(request: MethodCreateRequestDto) async throws -> MethodDto {
		return try await requestWithJson("/methods", method: "POST", body: request)
	}
	
	func updateMethod(methodId: String, request: MethodCreateRequestDto) async throws -> MethodDto {
		return try await requestWithJson("/methods/\(methodId)", method: "PUT", body: request)
	}
}

enum MethodKind: String, Codable {
	case cash = "cash"
	case creditCard = "credit_card"
	case debitCard = "debit_card"
	case bankAccount = "bank_account"
	case other = "other"
}

struct MethodDto: Codable {
	var id: String
	var name: String
	var description: String?
	var kind: MethodKind
	var color: String?
}

struct MethodCreateRequestDto: Codable {
	var name: String
	var description: String?
	var kind: MethodKind
	var color: String?
}
