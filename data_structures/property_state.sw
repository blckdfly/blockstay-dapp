library;

use core::ops::Eq;

pub enum PropertyState {
    pub Listed: (),
    pub Unlisted: (),
}

impl Eq for PropertyState {
    fn eq(self, other: PropertyState) -> bool {
        match (self, other) {
            (PropertyState::Listed, PropertyState::Listed) => true,
            (PropertyState::Unlisted, PropertyState::Unlisted) => true,
            _ => false,
        }
    }
}