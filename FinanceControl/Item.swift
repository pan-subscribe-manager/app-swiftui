//
//  Item.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import Foundation
import SwiftData

@Model
final class Item {
	var timestamp: Date
	
	init(timestamp: Date) {
		self.timestamp = timestamp
	}
}
