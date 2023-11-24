//
//  LinkedList.swift -- Implemented based on java Linked List
//  https://developer.classpath.org/doc/java/util/LinkedList-source.html
//  DataStructure
//
//  Created by Iman Mosayyebi on 11/17/23.
//

/**
 Linked list implementation of the List interface. In addition to the
 methods of the List interface, this class provides access to the first
 and last list elements in O(1) time for easy stack, queue, or double-ended
 queue (deque) creation. The list is doubly-linked, with traversal to a
 given index starting from the end closest to the element.
 
 - Attention:  LinkedList is not synchronized, so if you need multi-threaded access, consider that.
 - Authors: Iman Mosayebi (iman.mosayyebi@gmail.com)
 */

public class LinkedList<T> {
    
    // The current length of the list.
    private var size: Int
    
    // The first element in the list.
    private var first: Entry<T>?
    
    //The last element in the list.
    private var last: Entry<T>?
    
    // Class to represent an entry in the list. Holds a single element.
    private final class Entry<S> {
        
        // Entry uniq id
        private var id: UUID
        
        // The element in the list.
        var data: S
        
        // The next list entry, nil if this is last.
        var next: Entry<S>?
        
        // The previous list entry, nil if this is first.
        var previous: Entry<S>?
        
        /**
         Construct an entry.
         - Parameter data: data the list element
         */
        init(data: S) {
            self.data = data
            self.next = nil
            self.previous = nil
            self.id = UUID()
        }
        
        public static func==(lhs: Entry, rhs: Entry) -> Bool {
            return (lhs.id == rhs.id)
        }
    } // class Entry
    
    private struct IndexOutOfBoundsException : Error {
        
        private let message = "LinkedList out of range"
        private var reason: String
        
        public init(reason: String) {
            self.reason = reason
        }
        
        public var localizedDescription:  String {
            return "\(message), \(reason)"
        }
    } // struct IndexOutOfBoundsException
    
    /**
     Obtain the Entry at a given position in a list. This method of course
     takes linear time, but it is intelligent enough to take the shorter of the
     paths to get to the Entry required. This implies that the first or last
     entry in the list is obtained in constant time, which is a very desirable
     property.
     For speed and flexibility, range checking is not done in this method:
     Incorrect values will be returned if (n &lt; 0) or (n &gt;= size).
     
     - Parameter n: the number of the entry to get
     - Returns: the entry at position n
     */
    private func getEntry(_ n: Int) -> Entry<T>? {
        if n < self.size / 2 {
            var e = self.first
            // n less than size/2, iterate from start
            for _ in 0..<n {
                e = e?.next
            }
            return e
        } else {
            var e = self.last
            // n greater than size/2, iterate from end
            for _ in n+1..<self.size {
                e =  e?.previous
            }
            return e
        }
    }
    
    /**
     Remove an entry from the list. This will adjust size and deal
     with 'first' and 'last' appropriatly.
     
     - Parameter e: the entry to remove
     */
    private func removeEntry(_ e: Entry<T>) {
        self.size -= 1
        if self.size == 0 {
            self.first = nil
            self.last = nil
        } else {
            if let first = self.first, e == first {
                self.first = e.next
                e.next?.previous = nil
            } else if let last = self.last, e == last {
                self.last = e.previous
                e.previous?.next = nil
            } else {
                e.next?.previous = e.previous
                e.previous?.next = e.next
            }
        }
    }
    
    /**
     Inserts an element at the end of the list.
     
     - Parameter e: the entry to add
     */
    private func addLastEntry(_ e: Entry<T>) {
        if self.size == 0 {
            self.first = e
            self.last = e
        } else {
            e.previous = self.last
            self.last?.next = e
            self.last = e
        }
        self.size += 1
    }
    
    /**
     Checks that the index is in the range of possible elements (inclusive).
     
     - Parameter index: the index to check
     - Throws: IndexOutOfBoundsException if index &lt; 0 || index &gt; size
     */
    private func checkBoundsInclusive(_ index: Int) throws {
        if index < 0 || index > self.size {
            throw IndexOutOfBoundsException(reason: "Index: \(index), Size: \(self.size)")
        }
    }
    
    /**
     Checks that the index is in the range of existing elements (exclusive).
     
     - Parameter index: the index to check
     - Throws: IndexOutOfBoundsException if index &lt; 0 || index &gt;= size
     */
    private func checkBoundsExclusive(_ index: Int) throws {
        if index < 0 || index >= self.size {
            throw IndexOutOfBoundsException(reason: "Index: \(index), Size: \(self.size)")
        }
    }
    
    //Create an empty linked list.
    public init() {
        self.size = 0
        self.first = nil
        self.last = nil
    }
    
    /**
     Create a linked list containing the elements, in order, of a given
     collection.
     
     @param c the collection to populate this list from
     @throws NullPointerException if c is null
     */
    public convenience init(_ c: some Collection<T>) {
        self.init()
        self.addAll(c)
    }
    
    /**
     Returns the first element in the list.
     
     - Returns: the first list element, nil if empty
     */
    public func getFirst() -> T? {
        return first?.data
    }
    
    /**
     Returns the last element in the list.
     
     - Returns: the last list element, nil if empty
     */
    public func getLast() -> T? {
        return last?.data
    }
    
    /**
     Remove and return the first element in the list.
     
     - Returns: the former first element in the list, nil if empty
     */
    @discardableResult
    public func removeFirst() -> T? {
        guard let first = self.first else {
            return nil
        }
        self.size -= 1
        let r = first.data
        
        if first.next != nil {
            self.first?.next?.previous = nil
        }  else {
            last = nil
        }
        
        self.first = self.first?.next
        
        return r
    }
    
    /**
     Remove and return the last element in the list.
     
     - Returns: the former last element in the list, nil if empty
     */
    @discardableResult
    public func removeLast() -> T? {
        guard let last = self.last else {
            return nil
        }
        self.size -= 1
        let r = last.data
        
        if last.previous != nil {
            self.last?.previous?.next = nil
        } else {
            first = nil
        }
        
        self.last = self.last?.previous
        
        return r
    }
    
    /**
     Insert an element at the first of the list.
     
     - Parameter o: the element to insert
     */
    public func addFirst(_ o: T) {
        let e = Entry(data: o)
        
        if self.size == 0 {
            self.first = e
            self.last = e
        } else {
            e.next = self.first
            self.first?.previous = e
            self.first = e
        }
        self.size += 1
    }
    
    /**
     Insert an element at the last of the list.
     
     - Parameter o: the element to insert
     */
    public func addLast(_ o: T) {
        self.addLastEntry(Entry(data: o))
    }
    
    /**
     Adds an element to the end of the list.
     
     - Parameter o: the entry to add
     - Returns: true, as it always succeeds
     */
    @discardableResult
    public func add(_ o: T) -> Bool {
        self.addLastEntry(Entry(data: o))
        return true
    }
    
    /**
     Append the elements of the collection in iteration order to the end of
     this list. If this list is modified externally (for example, if this
     list is the collection), behavior is unspecified.
     
     @param c the collection to append
     @return true if the list was modified
     @throws NullPointerException if c is null
     */
    @discardableResult
    public func addAll(_ c: some Collection<T>) -> Bool {
        return addAll(index: self.size, c)
    }
    
    /**
     Insert the elements of the collection in iteration order at the given
     index of this list. If this list is modified externally (for example,
      if this list is the collection), behavior is unspecified.
     
     @param c the collection to append
     @return true if the list was modified
     @throws NullPointerException if c is null
     @throws IndexOutOfBoundsException if index &lt; 0 || index &gt; size()
     */
    @discardableResult
    public func addAll(index: Int, _ c: some Collection<T>) -> Bool {
        do {
            try checkBoundsInclusive(index)
            let cSize = c.count
            
            if cSize == 0 { return false }
            var itr = c.makeIterator()
            
            // Get the entries just before and after index. If index is at the start
            // of the list, BEFORE is null. If index is at the end of the list, AFTER
            // is null. If the list is empty, both are null.
            var after: Entry<T>? = nil
            var before: Entry<T>? = nil
            if index != self.size {
                after = getEntry(index)
                before = after?.previous
            } else {
                before = self.last
            }
            
            // Create the first new entry. We do not yet set the link from `before'
            // to the first entry, in order to deal with the case where (c == this).
            // [Actually, we don't have to handle this case to fufill the
            // contract for addAll(), but Sun's implementation appears to.]
            guard let data = itr.next() else { return false }
            var e = Entry(data: data)
            e.previous = before
            var prev = e
            let firstNew = e
            
            // Create and link all the remaining entries.
            for _ in 1..<cSize {
                guard let data = itr.next() else { return false }
                e = Entry(data: data)
                e.previous = prev
                prev.next = e
                prev = e
            }
            
            self.size += cSize
            prev.next = after
            if after != nil {
                after?.previous = e
            } else {
                last = e
            }
            
            if before != nil {
                before?.next = firstNew
            } else {
                self.first = firstNew
            }
            
        } catch {
            return false
        }
        return true
    }
    
    //Remove all elements from this list.
    public func clear() {
        if self.size > 0 {
            self.first = nil
            self.last = nil
            self.size = 0
        }
    }
    
    /**
     Return the element at index.
     
     @param index the place to look
     @return the element at index
     @throws IndexOutOfBoundsException if index &lt; 0 || index &gt;= size()
     */
    public func get(index: Int) -> T? {
        do {
            try checkBoundsExclusive(index)
            return getEntry(index)?.data
        } catch {
            return nil
        }
    }
    
    /**
     Replace the element at the given location in the list.
     
     @param index which index to change
     @param o the new element
     @return the prior element
     @throws IndexOutOfBoundsException if index &lt; 0 || index &gt;= size()
     */
    @discardableResult
    public func set(index: Int, _ o: T) -> T? {
        do {
            try checkBoundsExclusive(index)
            let e = getEntry(index)
            let old = e?.data
            e?.data = o
            return old
        } catch {
            return nil
        }
    }
    
    /**
     Inserts an element in the given position in the list.
     
     @param index where to insert the element
     @param o the element to insert
     @throws IndexOutOfBoundsException if index &lt; 0 || index &gt; size()
     */
    public func add(index: Int, _ o: T) {
        do {
            try checkBoundsInclusive(index)
            let e = Entry(data: o)
            
            if index < self.size {
                let after = getEntry(index)
                e.next = after
                e.previous = after?.previous
                if after?.previous == nil {
                    first = e
                } else {
                    after?.previous?.next = e
                }
                after?.previous = e
                size += 1
            } else {
                self.addLastEntry(e)
            }
        } catch {}
    }
    
    /**
     Removes the element at the given position from the list.
     
     @param index the location of the element to remove
     @return the removed element
     @throws IndexOutOfBoundsException if index &lt; 0 || index &gt; size()
     */
    @discardableResult
    public func remove(index: Int) -> T? {
        do {
            try checkBoundsExclusive(index)
            let e = getEntry(index)!
            removeEntry(e)
            return e.data
        } catch {
            return nil
        }
    }
    
    /**
     Returns an array which contains the elements of the list in order.
     
     @return an array containing the list elements
    */
    public var toArray: [T] {
        var array: [T] = []
        var e = self.first
        while e != nil {
            array.append(e!.data)
            e = e?.next
        }
        return array
    }
    
    /**
     Returns the size of the list.
     
     - Returns: the list size
     */
    public var count: Int {
        return self.size
    }
}

extension LinkedList where T : Equatable {
    
    /**
     Returns true if the list contains the given object. Comparison is done by
     <code>o == null ? e = null : o.equals(e)</code>.
     
     @param o the element to look for
     @return true if it is found
     */
    public func contains(_ o: T) -> Bool {
        var e = self.first
        while e != nil {
            if o == e!.data {
                return true
            }
            e = e?.next
        }
        return false
    }
    
    /**
     Removes the entry at the lowest index in the list that matches the given
     object, comparing by <code>o == null ? e = null : o.equals(e)</code>.
     
     @param o the object to remove
     @return true if an instance of the object was removed
     */
    @discardableResult
    public func remove(_ o: T) -> Bool {
        var e = first
        while e != nil {
            if o == e!.data {
                removeEntry(e!)
                return true
            }
            e = e?.next
        }
        return false
    }
    
    /**
     Returns the first index where the element is located in the list, or -1.
     
     @param o the element to look for
     @return its position, or -1 if not found
     */
    public func indexOf(_ o: T) -> Int? {
        var index = 0
        var e = self.first
        while e != nil {
            if o == e!.data {
                return index
            }
            index += 1
            e = e?.next
        }
        return nil
    }
    
    /**
     Returns the last index where the element is located in the list, or -1.
     
     @param o the element to look for
     @return its position, or -1 if not found
     */
    public func lastIndexOf(_ o: T) -> Int? {
        var index = self.size - 1
        var e = self.last
        while e != nil {
            if o == e!.data {
                return index
            }
            index -= 1
            e = e?.previous
        }
        return nil
    }
}
