
import Combine
import CoreLocation
import HealthKit

extension HKHealthStore {

    public func publisher<Query: HKQuery, Output, Failure: Error>(
        for query: @escaping (@escaping (Query, Output?, Failure?) -> ()) -> Query
    ) -> QueryPublisher<Query, Output, Failure> {
        QueryPublisher(store: self, query: query)
    }
}

extension HKHealthStore {

    public func activitySummaryPublisher(
        predicate: NSPredicate?
    ) -> QueryPublisher<HKActivitySummaryQuery, [HKActivitySummary], Error> {

        publisher(for: {

            HKActivitySummaryQuery(predicate: predicate,
                                   resultsHandler: $0)
        })
    }
}

extension HKHealthStore {

    public func correlationPublisher(
        type: HKCorrelationType,
        predicate: NSPredicate?,
        samplePredicates: [HKSampleType : NSPredicate]?
    ) -> QueryPublisher<HKCorrelationQuery, [HKCorrelation], Error> {

        publisher(for: {

            HKCorrelationQuery(type: type,
                               predicate: predicate,
                               samplePredicates: samplePredicates,
                               completion: $0)
        })
    }
}

extension HKHealthStore {

    public func samplePublisher(
        sampleType: HKSampleType,
        predicate: NSPredicate?,
        limit: Int,
        sortDescriptors: [NSSortDescriptor]?
    ) -> QueryPublisher<HKSampleQuery, [HKSample], Error> {

        publisher(for: {

            HKSampleQuery(sampleType: sampleType,
                          predicate: predicate,
                          limit: limit,
                          sortDescriptors: sortDescriptors,
                          resultsHandler: $0)
        })
    }
}

extension HKHealthStore {

    public func sourcePublisher(
        sampleType: HKSampleType,
        samplePredicate: NSPredicate?
    ) -> QueryPublisher<HKSourceQuery, Set<HKSource>, Error> {

        publisher(for: {

            HKSourceQuery(sampleType: sampleType,
                          samplePredicate: samplePredicate,
                          completionHandler: $0)
        })
    }
}

extension HKHealthStore {

    public func statisticsPublisher(
        quantityType: HKQuantityType,
        quantitySamplePredicate: NSPredicate?,
        options: HKStatisticsOptions
    ) -> QueryPublisher<HKStatisticsQuery, HKStatistics, Error> {

        publisher(for: {

            HKStatisticsQuery(quantityType: quantityType,
                              quantitySamplePredicate: quantitySamplePredicate,
                              options: options,
                              completionHandler: $0)
        })
    }
}
