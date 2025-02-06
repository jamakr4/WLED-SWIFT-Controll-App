//Implementation of looking for devices on local network via broadcast or MDNS

import Foundation
import Network

class DeviceDiscovery: ObservableObject {
    @Published var devices: [WLEDDevice] = []
    var onDevicesDiscovered: (([WLEDDevice]) -> Void)? // Closure für gefundene Geräte
    
    private var browser: NWBrowser?
    
    func startDiscovery() {
        let serviceType = "_wled._tcp"
        let parameters = NWParameters()
        parameters.includePeerToPeer = true
        
        let browser = NWBrowser(for: .bonjour(type: serviceType, domain: nil), using: parameters)
        self.browser = browser
        
        browser.browseResultsChangedHandler = { [weak self] results, _ in
            self?.handleBrowseResultsChanged(results: results)
        }
        
        browser.start(queue: .main)
    }
    
    func stopDiscovery() {
        browser?.cancel()
        browser = nil
    }
    
    private func handleBrowseResultsChanged(results: Set<NWBrowser.Result>) {
        DispatchQueue.main.async { [weak self] in
            let foundDevices = results.compactMap { result -> WLEDDevice? in
                switch result.endpoint {
                case let .service(name, _, _, _):
                    // NWEndpoint.service liefert den Servicenamen, aber keine direkte IP-Adresse.
                    // Hier wird ein Platzhalter verwendet. Möchtest du die IP-Adresse ermitteln,
                    // musst du den entsprechenden Resolver verwenden.
                    let ipAddress = "unknown" // Platzhalter
                    return WLEDDevice(ipAddress: ipAddress, name: name)
                default:
                    return nil
                }
            }
            self?.devices = foundDevices
            self?.onDevicesDiscovered?(foundDevices)
        }
    }
    
    
   /* extension NWEndpoint {
        var ipAddress: String? {
            switch self {
            case .hostPort(let host, _):
                switch host {
                case .ipv4(let ipv4):
                    return ipv4.debugDescription
                case .ipv6(let ipv6):
                    return ipv6.debugDescription
                default:
                    return nil
                }
            default:
                return nil
            }
    }
      */  }
