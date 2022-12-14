import Fluent
import FluentMySQLDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    var tls = TLSConfiguration.makeClientConfiguration()
    tls.certificateVerification = .none

    app.databases.use(.mysql(
        hostname: "localhost",
        port: 3306,
        username: "mementofridge",
        password: "testowe",
        database: "mementofridgeDB"
    ), as: .mysql)

    app.migrations.add(CreateProduct())

    app.views.use(.leaf)

    // register routes
    try routes(app)
}
