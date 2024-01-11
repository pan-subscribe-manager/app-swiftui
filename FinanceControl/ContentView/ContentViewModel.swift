//
//  ContentViewModel.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/11.
//

import Foundation

final class ContentViewModel: ObservableObject {
	@Published var methods: Array<Method> = []
	@Published var loading: Bool = false
	@Published var error: Error?
	
	var shouldPresentErrorAlert: Bool {
		get { return error != nil }
		set(shouldOpen) {
			if (shouldOpen == false) {
				error = nil
			}
		}
	}
	var errorMessage: String? {
		get { return error?.localizedDescription }
	}
	
	func loadMethods(clientService: ClientService) async {
		await MainActor.run { [unowned self] in
			loading = true
		}
		defer {
			DispatchQueue.main.async { [unowned self] in
				loading = false
			}
		}
		
		do {
			let pagination = await MainActor.run {
				Pagination(offset: self.methods.count)
			}
			
			let fetchedMethods = try await clientService.run { client in
				try await client.listMethods(of: pagination)
			}
			
			await MainActor.run {
				self.methods.append(contentsOf: fetchedMethods)
			}
		} catch {
			await MainActor.run {
				self.error = error
			}
		}
	}
}
