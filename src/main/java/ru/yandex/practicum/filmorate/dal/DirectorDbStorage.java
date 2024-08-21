package ru.yandex.practicum.filmorate.dal;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import ru.yandex.practicum.filmorate.exceptions.NotFoundException;
import ru.yandex.practicum.filmorate.model.Director;
import ru.yandex.practicum.filmorate.model.Genre;

import java.util.List;

@Repository
@Qualifier("DirectorDbStorage")
public class DirectorDbStorage extends BaseRepository<Director> {

    private static final String FIND_ALL_DIRECTORS = "SELECT * FROM DIRECTORS ORDER BY DIRECTOR_ID";
    private static final String FIND_DIRECTOR_BY_ID = "SELECT * FROM DIRECTORS WHERE DIRECTOR_ID = ?";
    private static final String INSERT_DIRECTOR_QUERY = "INSERT INTO DIRECTORS(DIRECTOR_NAME) VALUES (?)";
    private static final String UPDATE_DIRECTOR_QUERY = "UPDATE DIRECTORS SET DIRECTOR_NAME = ? WHERE DIRECTOR_ID = ?";
    private static final String DELETE_DIRECTOR_QUERY = "DELETE FROM DIRECTORS WHERE DIRECTOR_ID = ?";
    private static final String FIND_DIRECTORS_BY_FILM_ID = "SELECT FILMS_DIRECTORS.DIRECTOR_ID AS DIRECTOR_ID, " +
            "DIRECTORS.DIRECTOR_NAME AS DIRECTOR_NAME FROM FILMS_DIRECTORS LEFT JOIN DIRECTORS ON DIRECTORS.DIRECTOR_ID = " +
            "FILMS_DIRECTORS.DIRECTOR_ID WHERE FILMS_DIRECTORS.FILM_ID = ? ORDER BY FILMS_DIRECTORS.DIRECTOR_ID;";

    public DirectorDbStorage(JdbcTemplate jdbc, RowMapper<Director> mapper) {
        super(jdbc, mapper);
    }

    public List<Director> findAll() {
        return findMany(FIND_ALL_DIRECTORS);
    }

    public Director findById(Long id) {
        return findOne(FIND_DIRECTOR_BY_ID, id)
                .orElseThrow(() -> new NotFoundException("Режиссер с id= " + id + " не найден"));
    }

    public Director createDirector(Director director) {
        long id = insertWithGenId(
                INSERT_DIRECTOR_QUERY,
                director.getName()
        );
        director.setId(id);
        return director;
    }

    public Director update(Director updatedDirector) {
        update(
                UPDATE_DIRECTOR_QUERY,
                updatedDirector.getName(), updatedDirector.getId()
        );
        return updatedDirector;
    }

    public void delete(Long id) {
        delete(DELETE_DIRECTOR_QUERY, id);
    }

    public List<Director> findDirectorsByFilmId(Long filmId) {
        return findMany(FIND_DIRECTORS_BY_FILM_ID, filmId);
    }
}

