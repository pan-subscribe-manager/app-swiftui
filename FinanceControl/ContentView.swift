//
//  ContentView.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	@EnvironmentObject var clientService: ClientService
	
	var body: some View {
		if clientService.isLoggedIn {
			SubscriptionView()
		} else {
			LoginView()
				.environmentObject(clientService)
		}
	}
}

#Preview {
	ContentView()
		.modelContainer(for: Item.self, inMemory: true)
}
