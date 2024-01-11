//
//  ContentView.swift
//  FinanceControl
//
//  Created by Yi-Jyun Pan on 2024/1/10.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var clientService: ClientService
	@StateObject var viewModel: ContentViewModel = ContentViewModel()
	
	var body: some View {
		NavigationSplitView {
			if viewModel.loading {
				ProgressView()
			} else {
				List {
					ForEach(viewModel.methods) { method in
						NavigationLink {
							VStack {
								Text(method.name).font(.title)
								Text(method.kind.description + "$$")
							}
						} label: {
							VStack(alignment: .leading) {
								Text(method.name).font(.headline).multilineTextAlignment(.leading)
								Text((method.description ?? "")).multilineTextAlignment(.leading)
							}
						}
					}
					.onDelete(perform: {_ in})
				}
#if os(macOS)
				.navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
				.toolbar {
#if os(iOS)
					ToolbarItem(placement: .navigationBarTrailing) {
						EditButton()
					}
#endif
					ToolbarItem {
						Button(action: {}) {
							Label("Add Item", systemImage: "plus")
						}
					}
					
					ToolbarItem {
						Button(action: {
							Task {
								await viewModel.loadMethods(clientService: clientService)
							}
						}) {
							Label("Refresh", systemImage: "refresh")
						}
					}
				}
			}
		} detail: {
			Text("Select an item")
		}.alert(isPresented: $viewModel.shouldPresentErrorAlert) {
			Alert(title: Text("Error"), message: Text(viewModel.errorMessage!), dismissButton: .default(Text("OK")))
		}.task(priority: .background) {
			// wait until logged in
			while !clientService.isLoggedIn {
				print("wait for logged in…")
				try! await Task.sleep(for: .milliseconds(300))
			}
			
			await viewModel.loadMethods(clientService: clientService)
		}
	}
}

struct AddMethodModel: View {
	@EnvironmentObject var client: ClientService
	@State var name: String = ""
	@State var description: String = ""
	@State var kind: MethodKind = .bankAccount
	@State var loading: Bool = false
	@State var error: Error?
	
	var shouldPresentErrorAlert: Bool {
		get { return error != nil }
		set(shouldOpen) {
			if (shouldOpen == false) {
				error = nil
			}
		}
	}
	
	var body: some View {
		Form {
			TextField("Name", text: $name)
			TextField("Description", text: $description)
			Picker("Kind", selection: $kind) {
				ForEach([
					MethodKind.bankAccount,
					.cash,
					.creditCard,
					.debitCard,
					.other
				], id: \.self) { kind in
					Text(kind.rawValue)
				}
			}
			Button("Send") {
				Task {
					await addMethod()
				}
			}
		}
	}
	
	func addMethod() async {
		do {
			let resp = try await client.run { client in
				try await client.createMethod(request: MethodCreateRequest(name: name, description: description, kind: kind))
			}
			print("\(resp.id): \(resp.name) is inserted.")
		} catch {
			self.error = error
		}
	}
}

#Preview {
	let clientService = ClientService(client: Client.shared)
	
	return ContentView()
		.environmentObject(clientService)
		.task {
			do {
				try await clientService.login(username: "admin", password: "admin")
			} catch {
				print(error)
			}
		}
}
