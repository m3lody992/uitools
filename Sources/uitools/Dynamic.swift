public class Dynamic<T> {

    public var bind: (_ oldValue: T, _ newValue: T) -> Void = { _, _ in }

    public var value: T {
        didSet {
            bind(oldValue, value)
        }
    }

    public init(_ value: T) {
        self.value = value
    }

    public func bindAndFire(bind: @escaping ((_ oldValue: T, _ newValue: T) -> Void)) {
        self.bind = bind
        bind(value, value)
    }

}
