CREATE TABLE user (
	user_id int(11) unsigned NOT NULL AUTO_INCREMENT,
	name varchar(30) DEFAULT NULL,
	PRIMARY KEY (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE addr (
  	id int(11) unsigned NOT NULL AUTO_INCREMENT,
  	addr varchar(30) DEFAULT NULL,
	user_id int(11) DEFAULT NULL,
  	PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO user(name)
VALUES ("jin"),
              ("po"),
              ("alice"),
              ("petter");
INSERT INTO addr(addr, user_id)
VALUES ("seoul", 1),
              ("pusan", 2),
              ("deajeon", 3),
              ("deagu", 5),
              ("seoul", 6); 
              
select *
from user;