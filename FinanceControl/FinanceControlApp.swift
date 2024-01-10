//
//  FinanceControlApp.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import SwiftUI
import SwiftData

@main
struct FinanceControlApp: App {
	@StateObject var clientService: ClientService = ClientService(client: Client.shared)
	@State var me = ""
	
	var sharedModelContainer: ModelContainer = {
		let schema = Schema([
			Item.self,
		])
		let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
		
		do {
			return try ModelContainer(for: schema, configurations: [modelConfiguration])
		} catch {
			fatalError("Could not create ModelContainer: \(error)")
		}
	}()
	
	var body: some Scene {
		WindowGroup {
			if clientService.isLoggedIn {
				Text("I am \(me)…").task {
					do {
						try await clientService.run({client in
							let me_ = try await client.getMe()
							me = me_.username
						})
					} catch {
						me = "(failure)"
					}
				}
			} else {
				LoginView()
					.environmentObject(clientService)
			}
		}
		.modelContainer(sharedModelContainer)
	}
}
