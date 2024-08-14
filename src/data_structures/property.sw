library;

pub struct Property {
    pub id: u64,
}

impl Property {
    pub fn new(id: u64) -> Self {
        Self { id }
    }
}