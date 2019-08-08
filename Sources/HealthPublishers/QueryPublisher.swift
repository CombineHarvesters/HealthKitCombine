
import Combine
import HealthKit

public struct QueryPublisher<Query: HKQuery, Output, Failure: Error> {

    typealias Completion = (Query, Output?, Failure?) -> ()

    private let store: HKHealthStore
    private let query: (@escaping Completion) -> Query
    init(store: HKHealthStore, query: @escaping (@escaping Completion) -> Query) {
        self.store = store
        self.query = query
    }
}

extension QueryPublisher: Publisher {

    public func receive<Subscriber>(subscriber: Subscriber)
        where
        Subscriber: Combine.Subscriber,
        Subscriber.Failure == Failure,
        Subscriber.Input == Output
    {
        let subscription = Subscription(subscriber: subscriber, store: store, query: query)
        subscriber.receive(subscription: subscription)
    }
}

extension QueryPublisher {

    private final class Subscription<Subscriber>: Combine.Subscription
        where
        Subscriber: Combine.Subscriber,
        Subscriber.Failure == Failure,
        Subscriber.Input == Output
    {
        fileprivate init(subscriber: Subscriber,
                         store: HKHealthStore,
                         query: (@escaping Completion) -> Query) {

            store.execute(query { _, output, failure in

                if let output = output {
                    _ = subscriber.receive(output)
                    subscriber.receive(completion: .finished)
                } else {
                    subscriber.receive(completion: .failure(failure!))
                }
            })
        }

        func request(_ demand: Subscribers.Demand) {}
        func cancel() {}
    }
}
