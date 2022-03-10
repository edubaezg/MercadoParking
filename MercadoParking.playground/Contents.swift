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
    // discountCard is an optional property, since a vehicle may or may not have a discount card.
    var discountCard: String? { get }
    var parkedTime: Int { get }
}

// MARK: - Structs
struct Parking {
    
    // Vehicles is defined as a Set because a set cannot contain duplicates,
    // just like Parking can not have duplicate vehicles.
    
    // MARK: Properties
    var vehicles: Set<Vehicle> = []
    let maxVehicles: Int = 20
    
    // MARK: Methods
    mutating func checkInVehicle(_ vehicle: Vehicle, onFinish: (Bool) -> Void) {
        
        //Check if there's space available in the Parking.
        guard vehicles.count < maxVehicles else {
            onFinish(false)
            return
        }
        // Check that the vehicle is not already inside the Parking.
        guard !vehicles.contains(vehicle) else {
            onFinish(false)
            return
        }
        // If the vehicle is correctly checked-in, call the completion handler.
        onFinish(true)
    }
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
    // Computed property that calculates the time elapsed since check-in
    var parkedTime: Int {
        Calendar.current.dateComponents([.minute], from: checkInTime, to: Date()).minute ?? 0
    }
}

// MARK: - Actions
var mercadoParking = Parking()

// Register vehicles
let vehicles: [Vehicle] = [
    Vehicle(plate: "AA111AA", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001"),
    Vehicle(plate: "B222BBB", type: VehicleType.moto, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "CC333CC", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "DD444DD", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_002"),
    Vehicle(plate: "AA111BB", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_003"),
    Vehicle(plate: "B222CCC", type: VehicleType.moto, checkInTime: Date(), discountCard: "DISCOUNT_CARD_004"),
    Vehicle(plate: "CC333DD", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "DD444EE", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_005"),
    Vehicle(plate: "AA111CC", type: VehicleType.car, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "B222DDD", type: VehicleType.moto, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "CC333EE", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "DD444GG", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_006"),
    Vehicle(plate: "AA111DD", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_007"),
    Vehicle(plate: "B222EEE", type: VehicleType.moto, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "CC333FF", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "FF666FF", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "GG354JK", type: VehicleType.miniBus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_008"),
    Vehicle(plate: "BB495JK", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "OO453US", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "TG498KS", type: VehicleType.miniBus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_010"),
    // Register vehicle with repeated plate
    Vehicle(plate: "TG498KS", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil)
]

// Check that vehicles have been correctly inserted
vehicles.forEach { vehicle in
    print(mercadoParking.vehicles.insert(vehicle).inserted)
}

// Remove vehicle
mercadoParking.vehicles.remove(vehicles[0])
print(!mercadoParking.vehicles.contains(vehicles[1]))

print(mercadoParking.vehicles.contains(vehicles[0]))
