import Foundation

// MARK: - Enums
// Global settings for MercadoParking
enum ParkingSettings: Int {
    case maxVehicles = 20
    case initialHoursInMinutes = 120
    case additionalTimeBlockInMinutes = 15
}

// Settings for discount card
enum DiscountCardSettings: Int {
    case discountPercentage = 15
}

// Fee for each vehicle type
enum Fee: Int {
    // First 2 hours fee
    case car = 20
    case moto = 15
    case miniBus = 25
    case bus = 30
    // Additional fee every 15 minutes after first 2 hours
    case additionalTimeBlock = 5
}

enum VehicleType {
    case car, moto, miniBus, bus
    
    var hourFee: Int {
        switch self {
        case .car: return Fee.car.rawValue
        case .moto: return Fee.moto.rawValue
        case .miniBus: return Fee.miniBus.rawValue
        case .bus: return Fee.bus.rawValue
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
    
    // MARK: Parking Properties
    var vehicles: Set<Vehicle> = []
    let maxVehicles: Int = ParkingSettings.maxVehicles.rawValue
    var totalEarnings = (vehiclesCheckedOut: 0, cummulativeEarnings: 0)
}

// MARK: Parking Methods
extension Parking {
    mutating func checkInVehicle(_ vehicle: Vehicle, onFinish: (Bool) -> Void) {
        // Check if there's space available in the Parking.
        guard vehicles.count <= maxVehicles else {
            onFinish(false)
            return
        }
        
        // Check that the vehicle is not already inside the Parking.
        guard !vehicles.contains(vehicle) else {
            onFinish(false)
            return
        }
        
        // If the vehicle is correctly checked-in, insert vehicle and call the completion handler.
        vehicles.insert(vehicle)
        onFinish(true)
    }
    
    // Method has to be declared as mutating in order to be able to modify the vehicles Set.
    mutating func checkOutVehicle(_ plate: String, onSuccess: (Int) -> Void, onError: () -> Void) {
        
        // Check if there is a vehicle parked with the received plate
        guard let vehicle = vehicles.first(where: { $0.plate == plate }) else {
            onError()
            return
        }
        
        // Calculate fee for check out
        let totalFee = calculateFee(
            type: vehicle.type,
            parkedTime: vehicle.parkedTime,
            hasDiscountCard: vehicle.discountCard != nil
        )
        
        // If the vehicle exists, remove the vehicle from Parking, and call the onSuccess handler.
        vehicles.remove(vehicle)
        onSuccess(totalFee)
        // Add a vehicle to the checked out vehicles count and the earnings to the total earnings count.
        totalEarnings.vehiclesCheckedOut += 1
        totalEarnings.cummulativeEarnings += totalFee
    }
    
    func calculateFee(type: VehicleType, parkedTime: Int, hasDiscountCard: Bool) -> Int {
        var totalFee: Int = type.hourFee
        let initialHoursInMinutes: Int = ParkingSettings.initialHoursInMinutes.rawValue
        let additionalTimeBlockInMinutes: Int = ParkingSettings.additionalTimeBlockInMinutes.rawValue
        let additionalTimeBlockFee = Fee.additionalTimeBlock.rawValue
        let discountCardPercentage = DiscountCardSettings.discountPercentage.rawValue
        
        // If parked time is grater than initial hours, calculate additional time block
        if parkedTime > initialHoursInMinutes {
            // Get remaining minutes without initial hours
            let remainingMinutes = parkedTime - initialHoursInMinutes
            
            // Get additional time blocks
            let additionalTimeBlock = Double(remainingMinutes) / Double(additionalTimeBlockInMinutes)
            
            // Get additional time blocks rounded up
            let additionalTimeBlockRounded = Int(additionalTimeBlock.rounded(.up))
            
            // Calculate total fee plus total fee for additional time blocks
            totalFee += additionalTimeBlockRounded * additionalTimeBlockFee
        }

        // If the vehicle has a Discount Card, apply discount
        if hasDiscountCard {
            let discountAmount = (totalFee * discountCardPercentage) / 100
            totalFee -= discountAmount
        }

        return totalFee
    }
    
    func showTotalEarnings() {
        print("\(totalEarnings.vehiclesCheckedOut) vehicles have checked out and have earnings of $\(totalEarnings.cummulativeEarnings)")
    }
    
    func listVehicles(completion: ([String]) -> ()) {
        let parkedVehiclePlates: [String] = vehicles.map { vehicle in vehicle.plate }
        completion(parkedVehiclePlates)
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

// MARK: Vehicle Computed properties
extension Vehicle {
    // Computed property that calculates the time elapsed since check-in
    var parkedTime: Int {
        Calendar.current.dateComponents([.minute], from: checkInTime, to: Date()).minute ?? 0
    }
}

// MARK: - Actions
var mercadoParking = Parking()

let vehicles: [Vehicle] = [
    // Register 20 vehicles to parking
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
    Vehicle(plate: "TG498KS", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil),
    // Register extra vehicles for full parking lot
    Vehicle(plate: "SC439FF", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "GB448KR", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil)
]

// MARK: CHECK IN - Check that vehicles have been correctly inserted
vehicles.forEach { vehicle in
    mercadoParking.checkInVehicle(vehicle) { isInserted in
        print(isInserted ? "Welcome to MercadoParking!" : "Sorry, the check-in failed")
    }
}

// MARK: CHECK OUT - Check out vehicle and get total fee
// Checkout vehicle without discount card
mercadoParking.checkOutVehicle(vehicles[1].plate) { totalFee in
    print("Your fee is $\(totalFee). Come back soon")
} onError: {
    print("Sorry, the check-out failed")
}

// Checkout vehicle with discount card
mercadoParking.checkOutVehicle(vehicles[5].plate) { totalFee in
    print("Your fee is $\(totalFee). Come back soon")
} onError: {
    print("Sorry, the check-out failed")
}

// MARK: TOTAL EARNINGS - Get total earnings from check out vehicles
mercadoParking.showTotalEarnings()

// MARK: LIST VEHICLES - List parked vehicle plates
mercadoParking.listVehicles { parkedVehiclePlates in
    if parkedVehiclePlates.count > 0 {
        parkedVehiclePlates.forEach { vehiclePlate in
            print("Parked vehicle plate: \(vehiclePlate)")
        }
    } else {
        print("There are still no vehicles parked in MercadoParking")
    }
}
