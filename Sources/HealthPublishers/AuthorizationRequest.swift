
import Combine
import HealthKit

extension HKHealthStore {

    public func requestAuthorization(
        share: Set<HKSampleType>? = nil,
        read: Set<HKSampleType>? = nil
    ) -> AuthorizationRequest {
        AuthorizationRequest(store: self, share: share, read: read)
    }
}

public struct AuthorizationRequest {
    fileprivate let store: HKHealthStore
    fileprivate let share: Set<HKSampleType>?
    fileprivate let read: Set<HKSampleType>?
}

extension AuthorizationRequest: Publisher {

    public typealias Output = Void
    public typealias Failure = Error

    public func receive<Subscriber>(subscriber: Subscriber)
        where
        Subscriber: Combine.Subscriber,
        Subscriber.Failure == Failure,
        Subscriber.Input == Output
    {
        let subscription = Subscription(subscriber: subscriber,
                                        store: store,
                                        share: share,
                                        read: read)
        subscriber.receive(subscription: subscription)
    }
}

extension AuthorizationRequest {

    fileprivate final class Subscription<Subscriber>
        where
        Subscriber: Combine.Subscriber,
        Subscriber.Failure == Failure,
        Subscriber.Input == Output
    {
        private let subscriber: Subscriber
        private let store: HKHealthStore
        private let share: Set<HKSampleType>?
        private let read: Set<HKSampleType>?

        fileprivate init(subscriber: Subscriber,
                         store: HKHealthStore,
                         share: Set<HKSampleType>?,
                         read: Set<HKSampleType>?) {

            self.subscriber = subscriber
            self.store = store
            self.share = share
            self.read = read
        }
    }
}

extension AuthorizationRequest.Subscription: Subscription {

    func request(_ demand: Subscribers.Demand) {

        store.requestAuthorization(toShare: share, read: read) { success, error in

            if success {
                _ = self.subscriber.receive(())
                self.subscriber.receive(completion: .finished)
            } else {
                self.subscriber.receive(completion: .failure(error!))
            }
        }
    }

    func cancel() {}
}
