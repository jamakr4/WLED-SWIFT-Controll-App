// Helper class to save devices

import Foundation

class DeviceStore: ObservableObject {
    @Published var savedDevices: [WLEDDevice] = [] {
        didSet {
            saveDevices() // Automatisches Speichern bei Änderungen
        }
    }
    
    private let storageKey = "savedWLEDDevices"
    
    init() {
        loadDevices()
    }
    
    func addDevice(_ device: WLEDDevice) {
        // Verhindere doppelte Einträge
        if !savedDevices.contains(where: { $0.ipAddress == device.ipAddress }) {
            savedDevices.append(device)
        }
    }
    
    func removeDevice(_ device: WLEDDevice) {
        savedDevices.removeAll { $0.id == device.id }
    }
    
    private func saveDevices() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(savedDevices)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Fehler beim Speichern der Geräte: \(error)")
        }
    }
    
    private func loadDevices() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            let decoder = JSONDecoder()
            savedDevices = try decoder.decode([WLEDDevice].self, from: data)
        } catch {
            print("Fehler beim Laden der Geräte: \(error)")
        }
    }
}


