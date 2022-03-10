import UIKit
import Foundation

// MARK: - Enums
// Hour fee for each vehicle type
enum HourFee: Int {
    case car = 20
    case moto = 15
    case miniBus = 25
    case bus = 30
}

enum VehicleType {
    case car, moto, miniBus, bus
    
    var hourFee: Int {
        switch self {
        case .car: return HourFee.car.rawValue
        case .moto: return HourFee.moto.rawValue
        case .miniBus: return HourFee.miniBus.rawValue
        case .bus: return HourFee.bus.rawValue
        }
    }
}

// MARK: - Protocols
protocol Parkable {
    
    // MARK: Properties
    var plate: String { get }
    var type: VehicleType { get }
    var checkInTime: Date { get }
    // discountCard it's an optional property, since a vehicle may or may not have a discount card.
    var discountCard: String? { get }
    var parkedTime: Int { get }
}

// MARK: - Structs
struct Parking {
    
    // Vehicles is defined as a Set because a set cannot contain duplicates,
    // just like Parking can not have duplicate vehicles.
    
    // MARK: Properties
    var vehicles: Set<Vehicle> = []
}

struct Vehicle: Parkable, Hashable {

    // Properties must be added both in the protocol and the structure that implements it,
    // so that the structure conforms to the protocol.
    
    // MARK: Properties
    let plate: String
    let type: VehicleType
    let checkInTime: Date
    var discountCard: String?
    
    // MARK: Methods
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}

extension Vehicle {
    var parkedTime: Int {
        Calendar.current.dateComponents([.minute], from: checkInTime, to: Date()).minute ?? 0
    }
}

// MARK: - Actions
var mercadoParking = Parking()

// Register vehicles
let car = Vehicle(plate: "AA111AA", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001")
let moto = Vehicle(plate: "B222BBB", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let miniBus = Vehicle(plate: "CC333CC", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil)
let bus = Vehicle(plate: "DD444DD", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_002")
print(mercadoParking.vehicles.insert(car).inserted)
print(mercadoParking.vehicles.insert(moto).inserted)
print(mercadoParking.vehicles.insert(miniBus).inserted)
print(mercadoParking.vehicles.insert(bus).inserted)

// Register vehicle with repetead plate
let car2 = Vehicle(plate: "AA111AA", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_003")
print(mercadoParking.vehicles.insert(car2).inserted)

// Remove vehicle
mercadoParking.vehicles.remove(moto)
