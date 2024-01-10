//
//  Error.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import Foundation

enum ClientError: Error {
	case Unauthorized
	case InvalidResponse
	case InvalidUrl
	case InvalidInput
}

extension ClientError: LocalizedError {
	public var errorDescription: String? {
		switch self {
			case .Unauthorized:
				return NSLocalizedString("Unauthorized", comment: "ClientError")
			case .InvalidResponse:
				return NSLocalizedString("Invalid response", comment: "ClientError")
			case .InvalidUrl:
				return NSLocalizedString("Invalid URL", comment: "ClientError")
			case .InvalidInput:
				return NSLocalizedString("Invalid input", comment: "ClientError")
		}
	}
}
