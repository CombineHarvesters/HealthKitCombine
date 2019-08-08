
import Combine
import HealthKit

extension HKHealthStore {

    public func samplePublisher(
        sampleType: HKSampleType,
        predicate: NSPredicate?,
        limit: Int,
        sortDescriptors: [NSSortDescriptor]?
    ) -> QueryPublisher {

        QueryPublisher(store: self) { completion in

            HKSampleQuery(sampleType: sampleType,
                          predicate: predicate,
                          limit: limit,
                          sortDescriptors: sortDescriptors,
                          resultsHandler: completion)
        }
    }
}
