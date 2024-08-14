library;

use ::data_structures::booking_state::BookingState;

pub struct BookingInfo {
    pub bookedBy: Identity,
    pub bookingFrom: u64,
    pub bookingTo: u64,
    pub status: BookingState,
    pub property_id: u64,
}

impl BookingInfo {

    pub fn new(
        bookedBy: Identity,
        bookingFrom: u64,
        bookingTo: u64,
        property_id: u64,
    ) -> Self {
        Self {
            bookedBy,
            bookingFrom,
            bookingTo,
            status: BookingState::Booked,
            property_id,
        }
    }
}