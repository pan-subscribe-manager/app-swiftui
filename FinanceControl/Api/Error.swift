//
//  Error.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import Foundation

enum ClientError: Error {
	case unauthorized(details: String)
	case invalidResponse
	case invalidUrl
	case invalidInput
	
	case apiError(statusCode: Int, details: String)
}

extension ClientError: LocalizedError {
	public var errorDescription: String? {
		switch self {
			case .unauthorized(let details):
				return String(
					format: NSLocalizedString("Unauthorized ($@)", comment: "ClientError"),
					details
				)
			case .invalidResponse:
				return NSLocalizedString("Invalid response", comment: "ClientError")
			case .invalidUrl:
				return NSLocalizedString("Invalid URL", comment: "ClientError")
			case .invalidInput:
				return NSLocalizedString("Invalid input", comment: "ClientError")
			case .apiError(let statusCode, let details):
				let commonErrorTemplate = NSLocalizedString("$@ (HTTP $d, $@)", comment: "ClientError. $1 = error kind (User error / Server error), $2 = error code, $3 = error details")
				
				switch (statusCode) {
					case 400...499:
						return String(
							format: commonErrorTemplate,
							NSLocalizedString("User error", comment: "ClientError > commonErrorTemplate"),
							statusCode, details
						)
					case 500...599:
						return String(
							format: commonErrorTemplate,
							NSLocalizedString("Server error", comment: "ClientError > commonErrorTemplate"),
							statusCode, details
						)
					default:
						return String(
							format: commonErrorTemplate,
							NSLocalizedString("API error", comment: "ClientError > commonErrorTemplate"),
							statusCode, details
						)
				}
		}
	}
}
