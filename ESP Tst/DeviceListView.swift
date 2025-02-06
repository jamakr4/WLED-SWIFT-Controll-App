// UI for found devices

import SwiftUI

struct DeviceListView: View {
    @State private var devices: [WLEDDevice] = []
    
    var body: some View {
        NavigationView {
            List(devices) { device in
                VStack(alignment: .leading) {
                    Text(device.name)
                        .font(.headline)
                    Text(device.ipAddress)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("WLED Geräte")
            .onAppear {
                startDeviceDiscovery()
            }
        }
    }

    func startDeviceDiscovery() {
            let discovery = DeviceDiscovery()
            discovery.onDevicesDiscovered = { foundDevices in
                DispatchQueue.main.async {
                    self.devices = foundDevices
                }
            }
            discovery.startDiscovery()
        }
    }
