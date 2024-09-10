contract;

mod data_structures;
mod errors;
mod events;
mod interface;

use ::data_structures::{
    property::Property,
    property_info::PropertyInfo,
    booking_state::BookingState,
    booking_info::BookingInfo,
    property_state::PropertyState,
    property_image::PropertyImage,
    booking::Booking,
};
use ::errors::{BookingError, CreationError, UserError};
use ::events::{
    PropertyListed,
    PropertyUnlisted,
    BookingSuccessful,
};
use std::{
    auth::msg_sender,
    block::height,
    context::msg_amount,
    hash::Hash,
};
use ::interface::{HotelBooking, Info};

storage {
    booking_history: StorageMap<(Identity, u64), u64> = StorageMap {},

    property_availability: StorageMap<(u64, u64, u64), bool> = StorageMap {},

    property_info: StorageMap<u64, PropertyInfo> = StorageMap {},

    property_images: StorageMap<u64, PropertyImage> = StorageMap {},

    booking_info: StorageMap<u64, BookingInfo> = StorageMap {},

    total_property_listed: u64 = 0,

    total_booking: u64 = 0,
}

impl HotelBooking for Contract {

    #[storage(read, write)]
    fn list_property(pincode: u64, image1: b256, image2: b256) {
        let owner = msg_sender().unwrap();

        let property_info = PropertyInfo::new(owner, pincode);
        let property_images = PropertyImage::new(image1, image2);

        storage.total_property_listed.write(storage.total_property_listed.read() + 1);
        storage.property_info.insert(storage.total_property_listed.read(), property_info);

        storage.property_images.insert(storage.total_property_listed.read(), property_images);

        log(PropertyListed {
            owner,
            property_info,
            property_id: storage.total_property_listed.read(),
        });
    }

    #[storage(read, write)]
    fn unlist_property(property_id: u64) {

        let mut property_info = storage.property_info.get(property_id).try_read().unwrap();

        require(property_info.owner == msg_sender().unwrap(), UserError::UnauthorizedUser);

        property_info.listed = PropertyState::Unlisted;

        storage.property_info.insert(property_id, property_info);
 
        log(PropertyUnlisted { property_id });
    }

    #[storage(read, write)]
    fn book(property_id: u64, bookingFrom: u64, bookingTo: u64) {
 
        require(bookingFrom >= height().as_u64(), CreationError::BookingDateMustBeInFuture );
        require(bookingTo >= height().as_u64(), CreationError::BookingDateMustBeInFuture );

        let mut property_info = storage.property_info.get(property_id).try_read().unwrap();
        let mut bookedBy = msg_sender().unwrap();

 
        require(property_info.listed != PropertyState::Unlisted, BookingError::PropertyNotFound);
        require(property_info.available != BookingState::Booked, UserError::PropertyNotAvailable);
        
        let booking_info = BookingInfo::new(bookedBy, bookingFrom, bookingTo, property_id);

        storage.total_booking.write(storage.total_booking.read() + 1);
        storage.booking_info.insert(storage.total_booking.read(), booking_info);
        storage.booking_history.insert((bookedBy, property_id), storage.total_booking.read());
        storage.property_availability.insert((property_id, bookingFrom, bookingTo), false);

        property_info.available = BookingState::Booked;

        storage.property_info.insert(property_id, property_info);

        log(BookingSuccessful { 
            booking_id: storage.total_booking.read(), 
            bookedBy, 
            bookingFrom, 
            bookingTo });
    }

}

impl Info for Contract {

    #[storage(read)]
    fn booking_info(booking_id: u64) -> Option<BookingInfo> {
        storage.booking_info.get(booking_id).try_read()
    }

    #[storage(read)]
    fn property_info(property_id: u64) -> Option<PropertyInfo> {
        storage.property_info.get(property_id).try_read()
    }

    #[storage(read)]
    fn get_property_images(property_id: u64) -> Option<PropertyImage> {
        storage.property_images.get(property_id).try_read()
    }

    #[storage(read)]
    fn total_property_listed() -> u64 {
        storage.total_property_listed.read()
    }

    #[storage(read)]
    fn total_booking() -> u64 {
        storage.total_booking.read()
    }
}
