ALTER TABLE company 
    ADD CONSTRAINT pk_company PRIMARY KEY (id);
    ADD CONSTRAINT uq_company_name UNIQUE (name);
    ALTER COLUMN name SET NOT NULL,
                 country SET NOT NULL,
                 founded_year SET NOT NULL;

 
ALTER TABLE game
    ADD CONSTRAINT pk_game PRIMARY KEY (id);
    ADD CONSTRAINT chk_user_score CHECK (user_score BETWEEN 0 AND 100),
                   chk_first_release_date CHECK (first_release_date >= "1958-10-01");
    ALTER COLUMN title SET NOT NULL;


ALTER TABLE platform
    ADD CONSTRAINT pk_platform PRIMARY KEY (id);
    ALTER COLUMN name SET NOT NULL,
                 short_name SET NOT NULL,
                 type SET NOT NULL,
                 release_date SET NOT NULL;
    
    

ALTER TABLE game_engine
    ADD CONSTRAINT pk_game_engine PRIMARY KEY (id);
    ALTER COLUMN name SET NOT NULL,
                 version SET NOT NULL,
                 release_date SET NOT NULL,
                 is_active SET NOT NULL;
    ADD CONSTRAINT chk_release_date CHECK (release_date <= now());


ALTER TABLE game_release
    ADD CONSTRAINT fk_release_game FOREIGN KEY (game_id),
                   fk_release_platform FOREIGN KEY (platform_id),
                   fk_release_company FOREIGN KEY (company_id);
    ALTER COLUMN release_date SET NOT NULL,
                 region SET NOT NULL,
                 role SET NOT NULL;


ALTER TABLE genre
    ADD CONSTRAINT pk_genre PRIMARY KEY (id);
    ALTER COLUMN name SET NOT NULL;


ALTER TABLE game_genre
    ADD CONSTRAINT fk_game FOREIGN KEY (game_id),
                   fk_genre FOREIGN KEY (genre_id);

