
    -- -------------------------------------------------------------------
    -- -------------------------------------------------------------------
CREATE TABLE country (
    country_name TEXT PRIMARY KEY,
    country_code TEXT UNIQUE NOT NULL,
    phone_code TEXT UNIQUE NOT NULL,
    currency TEXT NOT NULL,
    official_language TEXT NOT NULL,
    continent TEXT NOT NULL,
    flag_url TEXT CHECK (
        flag_url IS NULL OR 
        flag_url ~* '^https?://[a-z0-9.-]+\.[a-z]{2,}(/.*)?$'
    ),
    plug_type TEXT NOT NULL,
    climate_info TEXT NOT NULL,
    description TEXT NOT NULL
);
    -- -------------------------------------------------------------------
    -- -------------------------------------------------------------------
-- Sequence for ID
CREATE SEQUENCE country_photo_seq START 101;

CREATE TABLE country_photo (
    country_photo_id TEXT PRIMARY KEY DEFAULT 
        ('CP' || nextval('country_photo_seq')),

    country_photo_url TEXT NOT NULL CHECK (
        country_photo_url ~* '^https?://[a-z0-9.-]+\.[a-z]{2,}(/.*)?$'
    ),

    description_country_photo TEXT NOT NULL,

    cover_or_not BOOLEAN NOT NULL DEFAULT false,

    -- FK --> country
    country_name TEXT NOT NULL,

    CONSTRAINT fk_country
        FOREIGN KEY (country_name)
        REFERENCES country(country_name)
        ON DELETE CASCADE
);

-- for faster searching of photos by country use index on country_name in country_photo
CREATE INDEX idx_country_photo_country 
ON country_photo(country_name);
    -- -------------------------------------------------------------------
    -- -------------------------------------------------------------------
-- Sequence for ID
CREATE SEQUENCE country_tourism_type_seq START 101;

CREATE TABLE country_tourism_type (

    country_tourism_type_id TEXT PRIMARY KEY DEFAULT 
        ('CT' || nextval('country_tourism_type_seq')),

    tourism_type_name TEXT NOT NULL,

    description_tourism_type TEXT NOT NULL,


    -- FK --> country

    country_name TEXT NOT NULL,
    CONSTRAINT fk_country
        FOREIGN KEY (country_name)
        REFERENCES country(country_name)
        ON DELETE CASCADE


);   
    -- -------------------------------------------------------------------
    -- -------------------------------------------------------------------
CREATE SEQUENCE country_tourism_type_photo_seq START 101;

CREATE TABLE country_tourism_type_photo (

    country_tourism_type_photo_id TEXT PRIMARY KEY DEFAULT
        ('CTP' || nextval('country_tourism_type_photo_seq')),


    country_tourism_type_photo_url TEXT NOT NULL CHECK (
        country_tourism_type_photo_url ~* '^https?://[a-z0-9.-]+\.[a-z]{2,}(/.*)?$'
    ),

    description_country_tourism_type_photo TEXT NOT NULL,
    cover_or_not BOOLEAN NOT NULL DEFAULT false,
    -- FK --> country_tourism_type
    country_tourism_type_id TEXT NOT NULL,
    CONSTRAINT fk_country_tourism_type
        FOREIGN KEY (country_tourism_type_id)
        REFERENCES country_tourism_type(country_tourism_type_id)
        ON DELETE CASCADE

);
CREATE INDEX idx_country_tourism_type_photo_country_tourism_type 
ON country_tourism_type_photo(country_tourism_type_id);

