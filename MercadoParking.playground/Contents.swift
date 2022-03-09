import UIKit

protocol Parkable {
    var plate: String { get }
}

struct Parking {
    var vehicles: Set<Vehicle> = []
}

struct Vehicle: Parkable, Hashable {
    let plate: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}
