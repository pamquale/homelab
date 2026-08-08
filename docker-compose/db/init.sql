CREATE TABLE IF NOT EXISTS test_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO test_records (message) VALUES ('docker-compose demo record');
