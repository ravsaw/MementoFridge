import Fluent
import Vapor

final class Product: Model, Content {
    static let schema = "products"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "barcode")
    var barcode: String?

    init() { }

    init(id: UUID? = nil, name: String, barcode:String? = nil) {
        self.id = id
        self.name = name
        self.barcode = barcode
    }
}