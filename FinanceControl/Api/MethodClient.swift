//
//  MethodClient.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import Foundation

extension Client {
	func listMethods(of pagination: Pagination) async throws -> Array<Method> {
		return try await request("/methods/", method: "GET")
	}
	
	func getMethod(methodId: String) async throws -> Method {
		return try await request("/methods/\(methodId)/", method: "GET")
	}
	
	func createMethod(request: MethodCreateRequest) async throws -> Method {
		return try await requestWithJson("/methods/", method: "POST", body: request)
	}
	
	func patchMethod(methodId: String, request: MethodPatchRequest) async throws -> Method {
		return try await requestWithJson("/methods/\(methodId)/", method: "PATCH", body: request)
	}
	
	func deleteMethod(methodId: String) async throws {
		_ = try await requestRaw("/methods/\(methodId)/", method: "DELETE")
	}
}

enum MethodKind: String, Codable, CustomStringConvertible {
	case cash = "cash"
	case creditCard = "credit_card"
	case debitCard = "debit_card"
	case bankAccount = "bank_account"
	case other = "other"
	
	var description: String {
		get {
			switch self {
				case .cash: NSLocalizedString("Cash", comment: "MethodKind")
				case .creditCard: NSLocalizedString("Credit Card", comment: "MethodKind")
				case .debitCard: NSLocalizedString("Debit Card", comment: "MethodKind")
				case .bankAccount: NSLocalizedString("Bank Account", comment: "MethodKind")
				case .other: NSLocalizedString("Other", comment: "MethodKind")
			}
		}
	}
}

struct Method: Codable, Identifiable {
	var id: String
	var name: String
	var description: String?
	var kind: MethodKind
	var color: String?
}

struct MethodCreateRequest: Codable {
	var name: String
	var description: String?
	var kind: MethodKind
	var color: String?
}

struct MethodPatchRequest: Codable {
	var name: String?
	var description: String?
	var kind: MethodKind?
	var color: String?
}
