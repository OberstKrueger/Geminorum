import SwiftUI

struct ContentView: View {
    @ObservedObject var manager = GeminiManager()
    @State var addressBar: String = "gemini://gemini.circumlunar.space"

    var body: some View {
        VStack {
            HStack {
                TextField("Address Bar", text: $addressBar, onCommit: ({
                    self.addressBar = self.addressBar.lowercased()
                    self.manager.geminiTransaction(input: addressBar)
                }))
                    .textCase(.lowercase)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    self.addressBar = self.addressBar.lowercased()
                    self.manager.geminiTransaction(input: addressBar)
                }, label: {
                    Image(systemName: "return")
                })
            }
            .padding()
            Divider()
            ScrollView {
                if let page = manager.page {
                    Text(page.body)
                        .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(manager: GeminiManager())
            ContentView(manager: GeminiManager())
                .preferredColorScheme(.dark)
        }
    }
}
