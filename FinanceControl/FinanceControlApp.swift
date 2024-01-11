//
//  FinanceControlApp.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import SwiftUI

@main
struct FinanceControlApp: App {
	@StateObject var clientService: ClientService = ClientService(client: Client.shared)
	
	var body: some Scene {
		WindowGroup {
			AuthRouteView()
				.environmentObject(clientService)
		}
	}
}
