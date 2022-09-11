import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }

    try app.register(collection: TodoController())
    try app.register(collection: ProductController())

    app.get("product") { req async throws in 
        try await Product.query(on: req.db).all()
    }

    app.get("product", ":name") { req async throws -> String in 
        let name = req.parameters.get("name")!
        try await Product(name: name).create(on: req.db)
        return "Hello, \(name)!"
    }
}
