/// Represents the physiological purpose and intensity level of a workout set.
enum SetType: String, Codable, CaseIterable, Identifiable {
    /// Light preparatory set used to prime movement mechanics without causing fatigue.
    case warmup = "Warm-up"

    /// Standard prescribed training set driving primary strength and volume stimulus.
    case working = "Working"

    /// High-intensity set where weight is immediately reduced mid-set to extend rep count.
    case dropSet = "Drop Set"

    /// Set pushed until additional concentric repetitions are physically impossible with proper form.
    case failure = "Failure"

    var id: String {
        rawValue
    }
}
