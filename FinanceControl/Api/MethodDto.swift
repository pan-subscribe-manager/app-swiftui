//
//  MethodDto.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import Foundation

struct MethodResponseDto: Codable {
	var id: String
	var name: String
	var description: String?
	var kind: Kind
	var color: String?
	
	enum Kind: String, Codable {
		case Cash = "cash"
		case CreditCard = "credit_card"
		case DebitCard = "debit_card"
		case BankAccount = "bank_account"
		case Other = "other"
	}
}
