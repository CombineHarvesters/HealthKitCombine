
import Combine
import CoreLocation
import HealthKit

extension HKHealthStore {

    public func activitySummaryPublisher(
        predicate: NSPredicate?
    ) -> QueryPublisher<HKActivitySummaryQuery, [HKActivitySummary], Error> {

        QueryPublisher(store: self) { completion in

            HKActivitySummaryQuery(predicate: predicate,
                                   resultsHandler: completion)
        }
    }
}

extension HKHealthStore {

    public func correlationPublisher(
        type: HKCorrelationType,
        predicate: NSPredicate?,
        samplePredicates: [HKSampleType : NSPredicate]?
    ) -> QueryPublisher<HKCorrelationQuery, [HKCorrelation], Error> {

        QueryPublisher(store: self) { completion in

            HKCorrelationQuery(type: type,
                               predicate: predicate,
                               samplePredicates: samplePredicates,
                               completion: completion)
        }
    }
}

extension HKHealthStore {

    public func samplePublisher(
        sampleType: HKSampleType,
        predicate: NSPredicate?,
        limit: Int,
        sortDescriptors: [NSSortDescriptor]?
    ) -> QueryPublisher<HKSampleQuery, [HKSample], Error> {

        QueryPublisher(store: self) { completion in

            HKSampleQuery(sampleType: sampleType,
                          predicate: predicate,
                          limit: limit,
                          sortDescriptors: sortDescriptors,
                          resultsHandler: completion)
        }
    }
}

extension HKHealthStore {

    public func sourcePublisher(
        sampleType: HKSampleType,
        samplePredicate: NSPredicate?
    ) -> QueryPublisher<HKSourceQuery, Set<HKSource>, Error> {

        QueryPublisher(store: self) { completion in

            HKSourceQuery(sampleType: sampleType,
                          samplePredicate: samplePredicate,
                          completionHandler: completion)
        }
    }
}

extension HKHealthStore {

    public func statisticsPublisher(
        quantityType: HKQuantityType,
        quantitySamplePredicate: NSPredicate?,
        options: HKStatisticsOptions
    ) -> QueryPublisher<HKStatisticsQuery, HKStatistics, Error> {

        QueryPublisher(store: self) { completion in

            HKStatisticsQuery(quantityType: quantityType,
                              quantitySamplePredicate: quantitySamplePredicate,
                              options: options,
                              completionHandler: completion)
        }
    }
}
