
-- sequence for city_id
CREATE SEQUENCE city_id_seq START 1001;

CREATE TABLE city (
    city_id TEXT PRIMARY KEY DEFAULT ('CO' || nextval('city_id_seq')),
    city_name_en TEXT NOT NULL,
    city_name_ar TEXT NOT NULL,
    city_region_province TEXT NOT NULL,
    local_time_zone TEXT NOT NULL,
    about_the_city TEXT NOT NULL,

    latitude NUMERIC(9,6) NOT NULL CHECK (latitude >= -90 AND latitude <= 90),
    longitude NUMERIC(9,6) NOT NULL CHECK (longitude >= -180 AND longitude <= 180),
    is_capital BOOLEAN NOT NULL DEFAULT false,

    -- recording the time when the coordinates were last updated
    time_recorded TIMESTAMP WITH TIME ZONE,
    -- initially set to the current time when the city is created
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- FK --> country
    country_name TEXT NOT NULL,
    CONSTRAINT fk_country
        FOREIGN KEY (country_name)
        REFERENCES country(country_name)
        ON DELETE CASCADE
);

-- Trigger function to update time recorded when coordinates are inserted or modified
CREATE OR REPLACE FUNCTION update_time_on_coords()
RETURNS TRIGGER AS $$
BEGIN
-- If the listing is new or the latitude/longitude line has been modified
    IF TG_OP = 'INSERT' OR NEW.latitude IS DISTINCT FROM OLD.latitude OR NEW.longitude IS DISTINCT FROM OLD.longitude THEN
        NEW.time_recorded = CURRENT_TIMESTAMP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--  create trigger to call the function on insert or update of city
CREATE TRIGGER city_coords_time_trigger
BEFORE INSERT OR UPDATE ON city
FOR EACH ROW
EXECUTE FUNCTION update_time_on_coords();

-- Index for faster searching of cities by English name
CREATE INDEX idx_city_name_en ON city(city_name_en);

-- Index for faster searching of cities by Arabic name
CREATE INDEX idx_city_name_ar ON city(city_name_ar);

-- Index on FK for faster searching by country
CREATE INDEX idx_city_country ON city(country_name);

-- GIN index for faster partial searching using LIKE/ILIKE
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX idx_city_name_en_trgm ON city USING gin (city_name_en gin_trgm_ops);
CREATE INDEX idx_city_name_ar_trgm ON city USING gin (city_name_ar gin_trgm_ops);


    -- -------------------------------------------------------------------
    -- -------------------------------------------------------------------

CREATE SEQUENCE city_photo_seq START 1001;
CREATE TABLE city_photo (
    city_photo_id TEXT PRIMARY KEY DEFAULT
        ('COP' || nextval('city_photo_seq')),
    city_photo_url TEXT NOT NULL CHECK (
        city_photo_url ~* '^https?://[a-z0-9.-]+\.[a-z]{2,}(/.*)?$'
    ),
    description_city_photo TEXT NOT NULL,
    cover_or_not BOOLEAN NOT NULL DEFAULT false,
    -- FK --> city
    city_id TEXT NOT NULL,
    CONSTRAINT fk_city
        FOREIGN KEY (city_id)
        REFERENCES city(city_id)
        ON DELETE CASCADE
);
-- for faster searching of photos by city use index on city_id in city_photo
CREATE INDEX idx_city_photo_city
ON city_photo(city_id);


    -- -------------------------------------------------------------------
    -- -------------------------------------------------------------------

CREATE SEQUENCE city_tourism_type_seq START 1001;
CREATE TABLE city_tourism_type (
    city_tourism_type_id TEXT PRIMARY KEY DEFAULT
        ('COT' || nextval('city_tourism_type_seq')),

    tourism_type_name TEXT NOT NULL,
    description_tourism_type TEXT NOT NULL,
    -- FK --> city
    city_id TEXT NOT NULL,
    CONSTRAINT fk_city
        FOREIGN KEY (city_id)
        REFERENCES city(city_id)
        ON DELETE CASCADE
);
CREATE INDEX idx_city_tourism_type_city
ON city_tourism_type(city_id);

    -- -------------------------------------------------------------------
    -- -------------------------------------------------------------------

CREATE SEQUENCE city_tourism_type_photo_seq START 1001;
CREATE TABLE city_tourism_type_photo (
    city_tourism_type_photo_id TEXT PRIMARY KEY DEFAULT
        ('COTP' || nextval('city_tourism_type_photo_seq')),
    city_tourism_type_photo_url TEXT NOT NULL CHECK (
        city_tourism_type_photo_url ~* '^https?://[a-z0-9.-]+\.[a-z]{2,}(/.*)?$'
    ),
    description_city_tourism_type_photo TEXT NOT NULL,
    cover_or_not BOOLEAN NOT NULL DEFAULT false,
    -- FK --> city_tourism_type
    city_tourism_type_id TEXT NOT NULL,
    CONSTRAINT fk_city_tourism_type
        FOREIGN KEY (city_tourism_type_id)
        REFERENCES city_tourism_type(city_tourism_type_id)
        ON DELETE CASCADE
);
-- for faster searching of photos by city tourism type use index on city_tourism_type_id
CREATE INDEX idx_city_tourism_type_photo_city_tourism_type
ON city_tourism_type_photo(city_tourism_type_id);


    --------------------------------------------------------------------
    ---------------------------------------------------------------------
CREATE SEQUENCE city_service_cat_seq START 1001;
CREATE TABLE city_service_category (
    category_id TEXT PRIMARY KEY DEFAULT ('CSC' || nextval('city_service_cat_seq')),
    category_name_en TEXT NOT NULL, -- (Hospital, Bank, Police, Pharmacy, Gas Station)
    category_name_ar TEXT NOT NULL,
    icon_url TEXT -- أيقونة تميز الخدمة على الخريطة
);

    --------------------------------------------------------------------
    ---------------------------------------------------------------------
CREATE SEQUENCE city_service_seq START 1001;
CREATE TABLE city_service (
    service_id TEXT PRIMARY KEY DEFAULT ('CS' || nextval('city_service_seq')),
    service_name_en TEXT NOT NULL,
    service_name_ar TEXT NOT NULL,
    
    address_en TEXT NOT NULL,
    address_ar TEXT NOT NULL,
    
    latitude NUMERIC(9,6) NOT NULL CHECK (latitude BETWEEN -90 AND 90),
    longitude NUMERIC(9,6) NOT NULL CHECK (longitude BETWEEN -180 AND 180),
    
    phone_number TEXT CHECK (phone_number ~ '^\+?[0-9\s-]{7,15}$'),
    is_open_24h BOOLEAN DEFAULT false,
    
    -- الروابط الأساسية
    city_id TEXT NOT NULL,
    category_id TEXT NOT NULL,

    CONSTRAINT fk_service_city 
        FOREIGN KEY (city_id) REFERENCES city(city_id) ON DELETE CASCADE,
    CONSTRAINT fk_service_category 
        FOREIGN KEY (category_id) REFERENCES city_service_category(category_id) ON DELETE CASCADE
);

CREATE INDEX idx_city_service_city ON city_service(city_id);
CREATE INDEX idx_city_service_category ON city_service(category_id);