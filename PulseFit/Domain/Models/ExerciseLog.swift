import Foundation
import SwiftData

/// Represents an exercise tracking entry within a workout session.
///
/// An `ExerciseLog` groups multiple ``WorkoutSet`` instances under a specific target movement or movement pattern.
///
/// - Important: Utilizes `.cascade` deletion rule to ensure all associated sets are purged upon exercise removal.
@Model
final class ExerciseLog {
    /// Unique persistent identifier for the exercise log.
    @Attribute(.unique) var id: UUID

    /// Display name of the exercise (e.g., "Barbell Bench Press").
    var exerciseName: String

    /// Target muscle group associated with the exercise (e.g., "Chest", "Quadriceps").
    var muscleGroup: String?

    /// Optional athlete notes or performance observations specific to this exercise execution.
    var notes: String?

    /// The parent workout session containing this exercise log.
    var workoutSession: WorkoutSession?

    /// Array of child sets performed during this exercise.
    ///
    /// - Note: Configured with `.cascade` deletion. Removing an `ExerciseLog` automatically
    ///   deletes all attached ``WorkoutSet`` instances from the persistent store.
    @Relationship(deleteRule: .cascade, inverse: \WorkoutSet.exerciseLog)
    var sets: [WorkoutSet]

    /// Creates a new `ExerciseLog` instance.
    ///
    /// - Parameters:
    ///   - id: Unique identifier. Defaults to a new `UUID()`.
    ///   - exerciseName: Display name of the movement.
    ///   - muscleGroup: Primary muscle targeted. Optional.
    ///   - notes: Custom observations or form notes. Optional.
    ///   - sets: Array of child sets. Defaults to an empty collection.
    init(
        id: UUID = UUID(),
        exerciseName: String,
        muscleGroup: String? = nil,
        notes: String? = nil,
        sets: [WorkoutSet] = []
    ) {
        self.id = id
        self.exerciseName = exerciseName
        self.muscleGroup = muscleGroup
        self.notes = notes
        self.sets = sets
    }
}
