-- Modify the CREATE TABLE statements as needed to add constraints.
-- Do not otherwise change the columns or their types.

CREATE TABLE RegisteredUser
(id INTEGER NOT NULL PRIMARY KEY,
 name VARCHAR(256) NOT NULL,
 email VARCHAR(256) NOT NULL UNIQUE
);

CREATE TABLE Seller
(id INTEGER NOT NULL PRIMARY KEY REFERENCES RegisteredUser(id) ON DELETE CASCADE,
 phone CHAR(10) NOT NULL);

CREATE TABLE Dealer
(id INTEGER NOT NULL PRIMARY KEY REFERENCES Seller(id) ON DELETE CASCADE,
 address VARCHAR(256) NOT NULL);

CREATE TABLE Automobile
(vin CHAR(17) NOT NULL PRIMARY KEY,
 make VARCHAR(32) NOT NULL,
 model VARCHAR(32) NOT NULL,
 year INTEGER NOT NULL,
 color VARCHAR(32) NOT NULL,
 mileage INTEGER NOT NULL,
 body_style VARCHAR(16) NOT NULL CHECK ((body_style = 'convertible') OR (body_style = 'coupe') OR (body_style = 'sedan') OR (body_style = 'suv') OR (body_style = 'van') OR (body_style = 'other')),
 sellerid INTEGER NOT NULL REFERENCES Dealer(id),
 price DECIMAL(10, 2) NOT NULL);

CREATE TABLE Review
(reviewid INTEGER NOT NULL PRIMARY KEY,
 make VARCHAR(32) NOT NULL,
 model VARCHAR(32) NOT NULL,
 year INTEGER NOT NULL,
 authorid INTEGER NOT NULL REFERENCES RegisteredUser(id),
 text VARCHAR(400) NOT NULL,
 date DATE NOT NULL,
 UNIQUE (make, model, year, authorid),
 CHECK (date >= DATE(CAST(year-1 AS VARCHAR) || '-01-01')));

-- Using triggers, enforce that we cannot have a user selling an
-- automobile and simultaneously writing a review for the same make,
-- model, and year.

CREATE FUNCTION TF_Review_no_selfie() RETURNS TRIGGER AS $$
BEGIN

IF (EXISTS (SELECT * FROM
    (SELECT Automobile.sellerid as authorid, Automobile.model, Automobile.make, Automobile.year FROM Automobile) as rvw
    WHERE rvw.authorid = NEW.authorid AND rvw.model = NEW.model AND rvw.make = NEW.make AND rvw.year = NEW.year ))
    THEN
    RAISE EXCEPTION 'Cannot review own selling';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TG_Review_no_selfie
  BEFORE INSERT OR UPDATE ON Review
  FOR EACH ROW
  EXECUTE PROCEDURE TF_Review_no_selfie();

CREATE FUNCTION TF_Automobile_no_selfie() RETURNS TRIGGER AS $$
BEGIN
  IF (EXISTS (SELECT * FROM
      (SELECT Review.authorid as sellerid, Review.model, Review.make, Review.year FROM Review) as rvw
      WHERE rvw.sellerid = NEW.sellerid AND rvw.model = NEW.model AND rvw.make = NEW.make AND rvw.year = NEW.year ))
      THEN
      RAISE EXCEPTION 'Cannot sell when already reviewed';
  END IF;
  RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TG_Automobile_no_selfie
  BEFORE INSERT OR UPDATE ON Automobile
  FOR EACH ROW
  EXECUTE PROCEDURE TF_Automobile_no_selfie();

-- Define a view that lists, for each make-model-year triple, the
-- total number of reviews, the total number of automobiles for sale,
-- and the average price.

CREATE VIEW ModelSummary(make, model, year,
                       num_reviews, num_forsale, avg_price) AS

                    SELECT Coalesce(rev.make, auto.make) as make, Coalesce(rev.model, auto.model) as model, Coalesce(rev.year, auto.year) as year, Coalesce(rev.num_reviews, 0) as num_reviews, Coalesce (auto.num_forsale, 0) as num_forsale, auto.avg_price
                    FROM
                        (SELECT Automobile.make, Automobile.model, Automobile.year, COUNT(*) as num_forsale, AVG(Automobile.price) as avg_price
                        FROM Automobile
                        GROUP BY Automobile.make, Automobile.model, Automobile.year) as auto
                    FULL OUTER JOIN
                        (SELECT Review.make, Review.model, Review.year, COUNT(*) as num_reviews
                       FROM Review
                        GROUP BY Review.make, Review.model, Review.year) as rev
                    ON rev.make = auto.make AND rev.model = auto.model AND rev.year = auto.year;
