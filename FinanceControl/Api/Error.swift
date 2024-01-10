//
//  Error.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import Foundation

enum ClientError: Error {
	case unauthorized
	case invalidResponse
	case invalidUrl
	case invalidInput
	
	case apiError(statusCode: Int, details: String)
}

extension ClientError: LocalizedError {
	public var errorDescription: String? {
		switch self {
			case .unauthorized:
				return NSLocalizedString("Unauthorized", comment: "ClientError")
			case .invalidResponse:
				return NSLocalizedString("Invalid response", comment: "ClientError")
			case .invalidUrl:
				return NSLocalizedString("Invalid URL", comment: "ClientError")
			case .invalidInput:
				return NSLocalizedString("Invalid input", comment: "ClientError")
			case .apiError(let statusCode, let details):
				return String(
					format: NSLocalizedString("Operation failed (HTTP $d, $@)", comment: "ClientError"),
					statusCode, details
				)
		}
	}
}
