//
//  UserDto.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import Foundation

struct UserInformationResponseDto: Codable {
	var username: String
	var full_name: String?
	var email: String?
}
