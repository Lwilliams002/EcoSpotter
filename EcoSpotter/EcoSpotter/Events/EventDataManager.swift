import Foundation

class EventDataManager {
    static let shared = EventDataManager() // Singleton instance
    
    private var events: [Event] = [] // Store events here
    weak var delegate: EventDataManagerDelegate?
    private init() {
        // Load events from storage if needed
    }
    
    // Add a new event
    func addEvent(_ event: Event) {
        events.append(event)
        delegate?.didAddEvent(event)
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

protocol EventDataManagerDelegate: AnyObject {
    func didAddEvent(_ event: Event)
}
