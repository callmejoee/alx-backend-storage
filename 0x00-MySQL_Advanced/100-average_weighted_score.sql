-- computes and stores the average weighted score for a student.
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUser;
DELIMITER $$
CREATE PROCEDURE ComputeAverageWeightedScoreForUser (user_id INT)
BEGIN
    DECLARE total_weighted_score FLOAT DEFAULT 0;
    DECLARE total_weight INT DEFAULT 0;

    SELECT SUM(score * weight), SUM(weight)
        INTO total_weighted_score, total_weight
        FROM corrections
        JOIN projects ON corrections.project_id = projects.id
        WHERE corrections.user_id = user_id;

    UPDATE users
        SET users.average_score = IF(total_weight = 0, 0, total_weighted_score / total_weight)
        WHERE users.id = user_id;
END $$
DELIMITER ;
