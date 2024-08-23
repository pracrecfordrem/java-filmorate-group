-- удаление всех таблиц перед запуском программы
DROP TABLE IF EXISTS REVIEWS_USERS_LIKES CASCADE;
DROP TABLE IF EXISTS LIKES CASCADE;
DROP TABLE IF EXISTS FILMS_GENRES CASCADE;
DROP TABLE IF EXISTS FILMS_DIRECTORS CASCADE;
DROP TABLE IF EXISTS REVIEWS CASCADE;
DROP TABLE IF EXISTS FILMS CASCADE;
DROP TABLE IF EXISTS FRIENDSHIP CASCADE;
DROP TABLE IF EXISTS HISTORY_ACTIONS CASCADE;
DROP TABLE IF EXISTS GENRES CASCADE;
DROP TABLE IF EXISTS MPA CASCADE;
DROP TABLE IF EXISTS DIRECTORS CASCADE;
DROP TABLE IF EXISTS USERS CASCADE;


-- PUBLIC.USERS определение

CREATE TABLE IF NOT EXISTS USERS
(
    USER_ID   BIGINT                 NOT NULL AUTO_INCREMENT,
    EMAIL     VARCHAR_IGNORECASE(40) NOT NULL,
    LOGIN     VARCHAR_IGNORECASE(40) NOT NULL,
    USER_NAME VARCHAR_IGNORECASE(40),
    BIRTHDAY  DATE,
    CONSTRAINT USERS_PK PRIMARY KEY (USER_ID)
--    ,
--    CONSTRAINT USERS_UNIQUE UNIQUE (EMAIL)
);

-- PUBLIC.FRIENDSHIP определение

CREATE TABLE IF NOT EXISTS FRIENDSHIP
(
    USER_ID   BIGINT,
    FRIEND_ID BIGINT,
    CONSTRAINT FRIENDSHIP_USERS_FK FOREIGN KEY (USER_ID) REFERENCES PUBLIC.USERS (USER_ID),
    CONSTRAINT FRIENDSHIP_USERS_FK_1 FOREIGN KEY (FRIEND_ID) REFERENCES PUBLIC.USERS (USER_ID)
);

-- PUBLIC.MPA определение

CREATE TABLE IF NOT EXISTS MPA
(
    MPA_ID   INTEGER               NOT NULL,
    MPA_NAME VARCHAR_IGNORECASE(5) NOT NULL,
    CONSTRAINT MPA_PK PRIMARY KEY (MPA_ID)
);

-- PUBLIC.GENRES определение

CREATE TABLE IF NOT EXISTS GENRES
(
    GENRE_ID   INTEGER                NOT NULL,
    GENRE_NAME VARCHAR_IGNORECASE(14) NOT NULL,
    CONSTRAINT GENRES_PK PRIMARY KEY (GENRE_ID)
);

-- PUBLIC.DIRECTORS определение

CREATE TABLE IF NOT EXISTS DIRECTORS (
    DIRECTOR_ID BIGINT NOT NULL AUTO_INCREMENT,
    DIRECTOR_NAME VARCHAR_IGNORECASE(200) NOT NULL,
    CONSTRAINT DIRECTORS_PK PRIMARY KEY (DIRECTOR_ID),
    CONSTRAINT DIRECTORS_UNIQUE UNIQUE (DIRECTOR_NAME)
);

-- PUBLIC.FILMS определение

CREATE TABLE IF NOT EXISTS FILMS
(
    FILM_ID      BIGINT                 NOT NULL AUTO_INCREMENT,
    FILM_NAME    VARCHAR_IGNORECASE(40) NOT NULL,
    DESCRIPTION  VARCHAR_IGNORECASE(200),
    RELEASE_DATE DATE,
    DURATION     BIGINT,
    MPA_ID       INTEGER,
    CONSTRAINT FILMS_PK PRIMARY KEY (FILM_ID),
    CONSTRAINT FILMS_MPA_FK FOREIGN KEY (MPA_ID) REFERENCES PUBLIC.MPA (MPA_ID)
);

-- PUBLIC.FILMS_DIRECTORS определение

CREATE TABLE IF NOT EXISTS FILMS_DIRECTORS (
	FILM_ID BIGINT NOT NULL,
	DIRECTOR_ID BIGINT NOT NULL,
	CONSTRAINT FILMS_DIRECTORS_FILMS_FK FOREIGN KEY (FILM_ID) REFERENCES PUBLIC.FILMS(FILM_ID),
	CONSTRAINT FILMS_DIRECTORS_DIRECTORS_FK FOREIGN KEY (DIRECTOR_ID) REFERENCES PUBLIC.DIRECTORS(DIRECTOR_ID)
	ON DELETE CASCADE
);

-- PUBLIC.FILMS_GENRES определение

CREATE TABLE IF NOT EXISTS FILMS_GENRES
(
    FILM_ID  BIGINT,
    GENRE_ID INTEGER,
    CONSTRAINT FILMS_GENRES_FILMS_FK FOREIGN KEY (FILM_ID) REFERENCES PUBLIC.FILMS (FILM_ID),
    CONSTRAINT FILMS_GENRES_GENRES_FK FOREIGN KEY (GENRE_ID) REFERENCES PUBLIC.GENRES (GENRE_ID)
);

-- PUBLIC.LIKES определение

CREATE TABLE IF NOT EXISTS LIKES
(
    FILM_ID BIGINT,
    USER_ID BIGINT,
    CONSTRAINT LIKES_FILMS_FK FOREIGN KEY (FILM_ID) REFERENCES PUBLIC.FILMS (FILM_ID),
    CONSTRAINT LIKES_USERS_FK FOREIGN KEY (USER_ID) REFERENCES PUBLIC.USERS (USER_ID)
);

-- PUBLIC.REVIEWS определение

CREATE TABLE IF NOT EXISTS REVIEWS
(
    REVIEW_ID   BIGINT PRIMARY KEY AUTO_INCREMENT,
    CONTENT     VARCHAR(200),
    IS_POSITIVE BOOLEAN,
    USER_ID     BIGINT REFERENCES USERS (USER_ID),
    FILM_ID     BIGINT REFERENCES FILMS (FILM_ID),
    USEFUL      INTEGER
);

-- PUBLIC.REVIEWS_USERS_LIKES определение

CREATE TABLE IF NOT EXISTS REVIEWS_USERS_LIKES
(
    REVIEW_ID       BIGINT REFERENCES REVIEWS (REVIEW_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    USER_ID         BIGINT REFERENCES USERS (USER_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    like_or_dislike ENUM ('like', 'dislike'),
    CONSTRAINT PK_REVIEWS_USERS_LIKES PRIMARY KEY (REVIEW_ID, USER_ID)
);
-- PUBLIC.HISTORY_ACTIONS определение

CREATE TABLE IF NOT EXISTS HISTORY_ACTIONS (
	EVENT_ID BIGINT NOT NULL AUTO_INCREMENT,
	USER_ID BIGINT,
	TIME_ACTION BIGINT,
	TYPE VARCHAR(20),
	OPERATION VARCHAR(20),
	ENTITY_ID BIGINT,
	CONSTRAINT HISTORY_PK PRIMARY KEY (EVENT_ID),
	CONSTRAINT USER_HISTORY_FK FOREIGN KEY (USER_ID) REFERENCES PUBLIC.USERS(USER_ID)
);
