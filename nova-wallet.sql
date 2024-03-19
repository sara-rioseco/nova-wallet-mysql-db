START transaction;
SET SQL_SAFE_UPDATES = 0;

CREATE SCHEMA nova_wallet;
USE nova_wallet;

CREATE TABLE currencies(
c_id INT PRIMARY KEY AUTO_INCREMENT,
c_name VARCHAR(50) NOT NULL,
c_symbol VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE users(
u_id INT PRIMARY KEY AUTO_INCREMENT,
u_name VARCHAR(50) NOT NULL,
u_lastname VARCHAR(50) NOT NULL,
u_email VARCHAR(50) NOT NULL,
u_password VARCHAR(100) NOT NULL,
u_balance INT NOT NULL DEFAULT 0,
u_currency_id INT NOT NULL DEFAULT 1,
u_role VARCHAR(10) NOT NULL DEFAULT 'user',
u_creation_date DATETIME NOT NULL,
FOREIGN KEY (u_currency_id) REFERENCES currencies(c_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Create unique index on users' id and email
CREATE UNIQUE INDEX user_email ON users(u_id ASC, u_email);

-- Delete index
-- DROP INDEX user_email ON users;

CREATE TABLE transactions(
t_id INT PRIMARY KEY AUTO_INCREMENT,
t_sender_id INT NOT NULL,
t_receiver_id INT NOT NULL,
t_currency_id INT NOT NULL,
t_amount INT NOT NULL,
t_type VARCHAR(10),
t_date DATETIME NOT NULL,
FOREIGN KEY(t_sender_id) REFERENCES users(u_id),
FOREIGN KEY(t_receiver_id) REFERENCES users(u_id),
FOREIGN KEY(t_currency_id) REFERENCES currencies(c_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DELIMITER //
CREATE TRIGGER same_currency_constraint
BEFORE INSERT ON transactions 
FOR EACH ROW 
BEGIN
    DECLARE sender_currency INT;
    DECLARE receiver_currency INT;

    SELECT u_currency_id INTO sender_currency 
    FROM users 
    WHERE u_id = NEW.t_sender_id;

    SELECT u_currency_id INTO receiver_currency 
    FROM users 
    WHERE u_id = NEW.t_receiver_id;

    IF sender_currency <> NEW.t_currency_id OR receiver_currency <> NEW.t_currency_id THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Currency mismatch between sender, receiver, and transaction currency';
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER process_transaction
AFTER INSERT ON transactions 
FOR EACH ROW 
BEGIN
    DECLARE sender_balance INT;

    SELECT u_balance INTO sender_balance 
    FROM users 
    WHERE u_id = NEW.t_sender_id;

    IF NEW.t_type = 'transfer' THEN
        IF sender_balance >= NEW.t_amount THEN
            UPDATE users 
		SET u_balance = u_balance - NEW.t_amount 
		WHERE u_id = NEW.t_sender_id;
            UPDATE users 
		SET u_balance = u_balance + NEW.t_amount 
		WHERE u_id = NEW.t_receiver_id;
        ELSE
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Insufficient balance for the transfer';
        END IF;
    ELSEIF NEW.t_type = 'deposit' AND NEW.t_sender_id = NEW.t_receiver_id THEN
        UPDATE users 
	    SET u_balance = u_balance + NEW.t_amount 
	    WHERE u_id = NEW.t_receiver_id;
    END IF;
END//
DELIMITER ;

INSERT INTO nova_wallet.currencies
(c_name,
c_symbol)
VALUES
('US Dollars', 'USD'),
('Chilean Pesos', 'CLP'),
('Euros', 'EUR');

INSERT INTO nova_wallet.users
(u_name,
u_lastname,
u_email,
u_password,
u_currency_id,
u_role,
u_creation_date)
VALUES 
('Pepito', 'Perez', 'pepito@mail.com', 'password', 1, 'user', NOW()),
('Fulanito', 'Perez', 'fulano@mail.com', 'contraseñaSuperSegura', 1, 'user', NOW()),
('Natalia', 'Rojas', 'naty@mail.com', 'password', 1, 'user', NOW()),
('Juan', 'Durán', 'jduran@mail.com', 'password', 1, 'user', NOW()),
('María', 'Perez', 'mperez@mail.com', 'password', 2, 'user', NOW()),
('Carla', 'Lagos', 'carla@mail.com', 'password', 1, 'user', NOW()),
('Diego', 'Gonzalez', 'diego@mail.com', 'password', 2, 'user', NOW()),
('Matías', 'Lillo', 'mlillo@mail.com', 'password', 1, 'user', NOW()),
('Carlos', 'Gomez', 'carlos@mail.com', 'password', 2, 'user', NOW()),
('Andrea', 'Perez', 'aperez@mail.com', 'password', 3, 'user', NOW()),
('Rodrigo', 'Martinez', 'rmartinez@mail.com', 'password', 3, 'user', NOW()),
('Marta', 'Gajardo', 'mgajardo@mail.com', 'password', 3, 'user', NOW()),
('Pedro', 'Perez', 'pperez@mail.com', 'password', 1, 'user', NOW());

INSERT INTO nova_wallet.transactions
(t_sender_id,
t_receiver_id,
t_currency_id,
t_amount,
t_type,
t_date) 
VALUES 
(1, 1, 1, 1600, 'deposit', NOW()),
(2, 2, 1, 2000, 'deposit', NOW()),
(3, 3, 1, 800, 'deposit', NOW()),
(4, 4, 1, 600, 'deposit', NOW()),
(5, 5, 2, 200000, 'deposit', NOW()),
(6, 6, 1, 700, 'deposit', NOW()),
(7, 7, 2, 150000, 'deposit', NOW()),
(8, 8, 1, 1500, 'deposit', NOW()),
(1, 2, 1, 200, 'transfer', NOW()),
(1, 3, 1, 300, 'transfer', NOW()),
(3, 2, 1, 700, 'transfer', NOW()),
(10, 10, 3, 3700, 'deposit', NOW()),
(4, 1, 1, 300, 'transfer', NOW()),
(6, 2, 1, 200, 'transfer', NOW()),
(12, 12, 3, 5000, 'deposit', NOW()),
(4, 6, 1, 200, 'transfer', NOW()),
(13, 13, 1, 600, 'deposit', NOW()),
(7, 5, 2, 20000, 'transfer', NOW()),
(8, 3, 1, 500, 'transfer', NOW()),
(7, 9, 2, 40000, 'transfer', NOW()),
(11, 11, 3, 2000, 'deposit', NOW()),
(13, 2, 1, 300, 'transfer', NOW()),
(2, 4, 1, 400, 'transfer', NOW()),
(5, 7, 2, 75000, 'transfer', NOW()),
(8, 6, 1, 200, 'transfer', NOW()),
(2, 1, 1, 1000, 'transfer', NOW()),
(5, 5, 2, 100000, 'deposit', NOW()),
(11, 10, 3, 800, 'transfer', NOW()),
(1, 6, 1, 300, 'transfer', NOW()),
(6, 8, 1, 400, 'transfer', NOW()),
(10, 12, 3, 500, 'transfer', NOW()),
(8, 4, 1, 300, 'transfer', NOW()),
(12, 11, 3, 100, 'transfer', NOW());

-- Trying to insert an invalid transaction (receiver currency doesn't match)
-- INSERT INTO nova_wallet.transactions (t_sender_id, t_receiver_id, t_currency_id, t_amount, t_type, t_date) VALUES (1, 12, 1, 200, 'transfer', NOW());

-- Get all users
SELECT * FROM users;

-- Update user email
UPDATE users SET u_email = 'newEmail@mail.com' WHERE u_id = 1;

-- Delete user's transactions by user id
DELETE FROM transactions WHERE (t_sender_id = 13 OR t_receiver_id = 13);

-- Delete user by id
DELETE FROM users WHERE u_id = 13;

-- Delete users
-- DROP TABLE users;

-- Get all transactions
SELECT * FROM transactions;

-- Get trasactions by user id (as sender or receiver)
SELECT * FROM transactions WHERE (t_sender_id = 1 OR t_receiver_id = 1);

-- Get trasactions by currency id
SELECT * FROM transactions WHERE t_currency_id = 2;

-- Get transactions with the same currency as user id
SELECT * FROM transactions WHERE t_currency_id = (SELECT u_currency_id FROM users WHERE u_id = 12);

-- Delete transactions by user id (as sender or receiver)
DELETE FROM transactions WHERE (t_sender_id = 6 OR t_receiver_id = 6);

-- Delete transaction by transaction id
DELETE FROM transactions WHERE t_id = 18;

-- Delete transactions table
-- DROP TABLE transactions;

-- Get currencies
SELECT * FROM currencies;

-- Get currency name by user id
SELECT c_name FROM currencies WHERE c_id = (SELECT u_currency_id FROM users WHERE u_id = 12);

-- Delete currencies table
-- DROP TABLE currencies; 

-- Delete nova_wallet SCHEMA
-- DROP SCHEMA nova_wallet;

COMMIT;
