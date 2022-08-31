CREATE DATABASE big_data_cluster;

\connect big_data_cluster;

CREATE TABLE IF NOT EXISTS public.countries (
    alpha_2 varchar NOT NULL,
    alpha_3 varchar NOT NULL,
    area double precision NOT NULL,
    capital varchar,
    continent varchar NOT NULL,
    currency_code varchar,
    currency_name varchar,
    equivalent_fips_code varchar,
    fips varchar,
    geoname_id bigint NOT NULL,
    languages varchar,
    country varchar NOT NULL,
    neighbours varchar,
    numer bigint NOT NULL,
    phone varchar,
    population bigint NOT NULL,
    postal_code_format varchar,
    postal_code_regex varchar,
    tld varchar
);

COPY public.countries
FROM '/init/countries.csv'
DELIMITER ';'
CSV HEADER;
