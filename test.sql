CREATE TABLE teams (
    team_id SERIAL PRIMARY KEY NOT NULL,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE games (
    game_id SERIAL PRIMARY KEY NOT NULL,
    year INT NOT NULL,
    round VARCHAR(100) NOT NULL,
    winner_id INT NOT NULL REFERENCES teams(team_id),
    opponent_id INT NOT NULL REFERENCES teams(team_id),
    winner_goals INT NOT NULL,
    opponent_goals INT NOT NULL
);

\copy games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) from 'games.csv' WITH (FORMAT CSV, HEADER true);
```