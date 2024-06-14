-- computes and stores the average weighted score for all students.
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers;
DELIMITER $$
CREATE PROCEDURE ComputeAverageWeightedScoreForUsers ()
BEGIN
    DECLARE user_id INT;
    DECLARE total_weighted_score FLOAT;
    DECLARE total_weight FLOAT;

    DECLARE cur CURSOR FOR
        SELECT id
        FROM users;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO user_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET total_weighted_score = 0;
        SET total_weight = 0;

        SELECT SUM(score * weight), SUM(weight)
            INTO total_weighted_score, total_weight
            FROM corrections
            JOIN projects ON corrections.project_id = projects.id
            WHERE corrections.user_id = user_id;

        UPDATE users
            SET users.average_score = IF(total_weight = 0, 0, total_weighted_score / total_weight)
            WHERE users.id = user_id;

    END LOOP;
    CLOSE cur;
END $$
DELIMITER ;

