import UIKit

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
    var plate: String { get }
    var type: VehicleType { get }
    var checkInTime: Date { get }
    var parkedTime: Int { get }
}

// MARK: - Structs
struct Parking {
    var vehicles: Set<Vehicle> = []
}

struct Vehicle: Parkable, Hashable {
    let plate: String
    let type: VehicleType
    let checkInTime: Date
    
    var parkedTime: Int {
        Calendar.current.dateComponents([.minute], from: checkInTime, to: Date()).minute ?? 0
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}

// MARK: - Actions
var mercadoParking = Parking()

// Register vehicles
let car = Vehicle(plate: "AA111AA", type: .car, checkInTime: Date())
let moto = Vehicle(plate: "B222BBB", type: .moto, checkInTime: Date())
let miniBus = Vehicle(plate: "CC333CC", type: .miniBus, checkInTime: Date())
let bus = Vehicle( plate: "DD444DD", type: .bus, checkInTime: Date())
print(mercadoParking.vehicles.insert(car).inserted)
print(mercadoParking.vehicles.insert(moto).inserted)
print(mercadoParking.vehicles.insert(miniBus).inserted)
print(mercadoParking.vehicles.insert(bus).inserted)

// Register vehicle with repetead plate
let car2 = Vehicle(plate: "AA111AA", type: VehicleType.car, checkInTime: Date())
print(mercadoParking.vehicles.insert(car2).inserted)

// Remove vehicle
mercadoParking.vehicles.remove(moto)
