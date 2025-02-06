//Datamodel for WLED device

import Foundation

struct WLEDDevice: Identifiable {
    let id = UUID()
    let ipAddress: String
    let name: String
}
