//
//  AuthRouteView.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import SwiftUI

struct AuthRouteView: View {
	@EnvironmentObject var clientService: ClientService
	
	var body: some View {
		if clientService.isLoggedIn {
			ContentView()
				.environmentObject(clientService)
		} else {
			LoginView()
				.environmentObject(clientService)
		}
	}
}

#Preview {
	AuthRouteView().environmentObject(ClientService())
}
