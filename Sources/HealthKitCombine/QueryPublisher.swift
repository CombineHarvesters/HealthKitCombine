
import Combine
import HealthKit

extension HKHealthStore {

    public func publisher<Query: HKQuery, Output, Failure: Error>(
        for query: @escaping (@escaping (Query, Output?, Failure?) -> ()) -> Query
    ) -> QueryPublisher<Query, Output, Failure> {
        QueryPublisher(store: self, query: query)
    }
}

public struct QueryPublisher<Query: HKQuery, Output, Failure: Error> {

    typealias Completion = (Query, Output?, Failure?) -> ()

    fileprivate let store: HKHealthStore
    fileprivate let query: (@escaping Completion) -> Query
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

    fileprivate final class Subscription<Subscriber>
        where
        Subscriber: Combine.Subscriber,
        Subscriber.Failure == Failure,
        Subscriber.Input == Output
    {
        private let store: HKHealthStore
        private let query: Query
        private var hasExecuted = false
        fileprivate init(subscriber: Subscriber,
                         store: HKHealthStore,
                         query: (@escaping Completion) -> Query) {

            self.store = store
            self.query = query { _, output, failure in

                if let output = output {
                    _ = subscriber.receive(output)
                    subscriber.receive(completion: .finished)
                } else {
                    subscriber.receive(completion: .failure(failure!))
                }
            }
        }
    }
}

extension QueryPublisher.Subscription: Subscription {

    func request(_ demand: Subscribers.Demand) {
        // If the store is asked to execute the same query more than once an
        // exception will be thrown. This can happen when this publisher is in
        // a flatMap – for example to flatMap after an AuthorizationRequest
        // publisher.
        guard !hasExecuted else { return }
        hasExecuted = true
        store.execute(query)
    }

    func cancel() {
        store.stop(query)
    }
}
