import SwiftUI

struct ContentView: View {
    @StateObject private var deviceDiscovery = DeviceDiscovery()

    var body: some View {
        NavigationView {
            VStack {
                List(deviceDiscovery.devices) { device in
                    VStack(alignment: .leading) {
                        Text(device.name)
                            .font(.headline)
                        Text(device.ipAddress)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                HStack {
                    Button("Start Discovery") {
                        deviceDiscovery.startDiscovery()
                    }
                    Button("Stop Discovery") {
                        deviceDiscovery.stopDiscovery()
                    }
                }
                .padding()
            }
            .navigationTitle("WLED Devices")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
