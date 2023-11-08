import Foundation

class EventDataManager {
    static let shared = EventDataManager() // Singleton instance
    
    private var events: [Event] = [] // Store events here
    
    private init() {
        // Load events from storage if needed
    }
    
    // Add a new event
    func addEvent(_ event: Event) {
        events.append(event)
        // You can also save events to persistent storage here
    }
    
    // Retrieve all events
    func getAllEvents() -> [Event] {
        return events
    }
    
    // Retrieve a specific event by index
    func getEvent(at index: Int) -> Event? {
        guard index >= 0, index < events.count else {
            return nil
        }
        return events[index]
    }
    
    // You can add more methods for managing events as needed
}