CREATE TABLE company (
    id serial,
    name text,
    country text,
    city text,
    founded_year int
);

CREATE TABLE game (
    id serial,
    title text,
    users_score int,
    age_rating text,
    first_release_date date
    game_engine_id int REFERENCES game_engine(id)

);

CREATE TABLE platform (
    id serial,
    name text,
    short_name text,
    type text,
    generation int,
    release_date date
);

CREATE TABLE genre (
    id serial,
    name text,
    parent_id int
);

CREATE TABLE game_engine (
    id serial,
    name text,
    version text,
    company_id int,
    release_date date,
    is_active boolean
);

CREATE TABLE game_genre (
    game_id int REFERENCES game(id),
    genre_id int REFERENCES genre(id)
);

CREATE TABLE game_release (
    game_id int REFERENCES game(id),
    platform_id int REFERENCES platform(id),
    company_id int REFERENCES company(id),
    release_date date,
    region text,
    role text
);


