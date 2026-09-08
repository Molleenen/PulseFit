import Foundation
import SwiftData

/// Represents an individual weightlifting set executed within an exercise log.
///
/// `WorkoutSet` tracks key metrics such as resistance load, repetition count, completion status,
/// and the physiological set classification (e.g., warm-up vs. working set).
///
/// - Important: Enforces explicit relationship mapping back to its parent ``ExerciseLog``.
@Model
final class WorkoutSet {
    /// Unique persistent identifier for the set.
    @Attribute(.unique) var id: UUID

    /// Zero-based sequential position of the set within the exercise execution order.
    var index: Int

    /// Weight/load lifted in kilograms (or pounds based on user preference).
    var weight: Double

    /// Total completed repetitions performed in the set.
    var reps: Int

    /// Underlying raw string representation of ``SetType`` stored in SwiftData.
    ///
    /// - Note: Stored as a raw String rather than a native enum representation to support
    ///   decoupled schema migrations if additional enum cases are added in future releases.
    var setTypeRawValue: String

    /// Indicates whether the user successfully executed and checked off the set.
    var isCompleted: Bool

    /// Strong-typed accessor for the set classification.
    ///
    /// Wraps ``setTypeRawValue`` with fallback handling to `.working` for unknown or corrupted stored values.
    var setType: SetType {
        get { SetType(rawValue: setTypeRawValue) ?? .working }
        set { setTypeRawValue = newValue.rawValue }
    }

    /// The parent exercise log containing this set.
    var exerciseLog: ExerciseLog?

    /// Creates a new `WorkoutSet` instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier. Defaults to a new `UUID()`.
    ///   - index: Order index within the parent exercise log.
    ///   - weight: Resistance load value.
    ///   - reps: Repetition count.
    ///   - setType: Operational classification of the set. Defaults to `.working`.
    ///   - isCompleted: Completion flag. Defaults to `false`.
    init(
        id: UUID = UUID(),
        index: Int,
        weight: Double,
        reps: Int,
        setType: SetType = .working,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.index = index
        self.weight = weight
        self.reps = reps
        setTypeRawValue = setType.rawValue
        self.isCompleted = isCompleted
    }
}
