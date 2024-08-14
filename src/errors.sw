library;

pub enum BookingError {
    PropertyBooked: (),
    BookingNotFound: (),
    PropertyNotAvailable: (),
    PropertyNotFound: (),
}

pub enum CreationError {

    BookingDateMustBeInFuture: (),
}

pub enum UserError {

    InvalidID: (),

    UnauthorizedUser: (),

    PropertyNotAvailable: (),

}