library;

use ::data_structures::property_state::PropertyState;
use ::data_structures::booking_state::BookingState;


pub struct PropertyInfo {
   
    pub owner: Identity,
    pub pincode: u64,
    pub listed: PropertyState,
    pub available: BookingState,    
}

impl PropertyInfo {

    pub fn new(
        owner: Identity,
        pincode: u64,
    ) -> Self {
        Self {
            owner,
            pincode,
            listed: PropertyState::Listed,
            available: BookingState::Available,
        }
    }
}