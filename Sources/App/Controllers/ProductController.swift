import Fluent
import Vapor

struct ProductListContext: Encodable {
    var title: String
    var products: [[Product]]
}

struct ProductContext: Encodable {
    var title: String
    var product: Product?
}

struct ProductController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let products = routes.grouped("products")
        products.get(use: index)
        products.group("add") { product in
            product.get(use: add)
            product.post(use: create)
        }
        products.group(":productID") { product in
            product.get(use: getOne)
            product.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> View {
        let columns: Int = req.query["columns"] ?? 1
        let products: [Product] = try await Product.query(on: req.db).all()
        let slicedProducts = stride(from: 0, to: products.count, by: columns).map {
            Array(products[$0 ..< Swift.min($0 + columns, products.count)])
        }
        return try await req.view.render("productList", ProductListContext(title: "Products list", products: slicedProducts))
    }

    func getOne(req: Request) async throws -> Product {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return product
    }

    func add(req: Request) async throws -> View {
        return try await req.view.render("productAdd", ProductContext(title: "Products add", product: nil))
    }

    func create(req: Request) async throws -> Response {
        let product = try req.content.decode(Product.self)
        try await product.save(on: req.db) 
        return req.redirect(to: "/products")
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await product.delete(on: req.db)
        return .noContent
    }
}
