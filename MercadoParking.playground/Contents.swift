import UIKit
import Foundation

protocol Parkable {
    
    // MARK: Properties
    var plate: String { get }
    
    var checkInTime: Date { get }
    // discountCard it's an optional property, since a vehicle may or may not have a discount card.
    var discountCard: String? { get }
    
}

struct Parking {
    
    // Vehicles it's defined as a Set because a set cannot contain duplicates,
    // just like Parking can not have duplicate vehicles.
    
    // MARK: Properties
    var vehicles: Set<Vehicle> = []
}

struct Vehicle: Parkable, Hashable {

    // Properties must be added both in the protocol and the structure that implements it,
    // so that the structure conforms to the protocol.
    
    // MARK: Properties
    let plate: String
    
    var checkInTime: Date
    var discountCard: String?
    
    // MARK: Methods
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}


