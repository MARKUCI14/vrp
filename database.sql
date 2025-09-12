CREATE EXTENSION IF NOT EXISTS postgis;

-- Users
CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    username TEXT NOT NULL,
    last_name TEXT,
    first_name TEXT,
    password TEXT NOT NULL
);

-- Depots
CREATE TABLE Depots (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES Users(id),
    address TEXT,
    location GEOGRAPHY(POINT, 4326) NOT NULL,
    name TEXT NOT NULL
);

-- Cars
CREATE TABLE Cars (
    id SERIAL PRIMARY KEY,
    depot_id INTEGER REFERENCES Depots(id),
    vin TEXT,
    make TEXT,
    model TEXT,
    year INTEGER,
    consumption REAL, -- L/100km
    max_weight REAL
);

-- Packages
CREATE TABLE Packages (
    id SERIAL PRIMARY KEY,
    depot_id INTEGER REFERENCES Depots(id),
    address TEXT,
    location GEOGRAPHY(POINT, 4326) NOT NULL,
    weight REAL NOT NULL,
    name TEXT NOT NULL,
    phone_number TEXT,
    delivery_date DATE
);

-- Listings (One per depot per day)
CREATE TABLE Listings (
    id SERIAL PRIMARY KEY,
    depot_id INTEGER REFERENCES Depots(id),
    date DATE NOT NULL,
    UNIQUE (depot_id, date)
);

-- Delivery Assignments
-- Links a listing to packages, the car delivering them, and the delivery order
CREATE TABLE Delivery (
    id SERIAL PRIMARY KEY,
    listing_id INTEGER REFERENCES Listings(id) ON DELETE CASCADE,
    package_id INTEGER REFERENCES Packages(id) ON DELETE CASCADE,
    car_id INTEGER REFERENCES Cars(id),
    delivery_order INTEGER NOT NULL,
    UNIQUE (listing_id, package_id)
);

-- Users
INSERT INTO Users (email, username, last_name, first_name, password) VALUES
('john.doe@example.com', 'johndoe', 'Doe', 'John', '$2a$12$5eW37SyfZO3XsK3MwvuWCOENlt64kxSeYHvQmOxokVQR9nFSE3xbC'),
('jane.smith@example.com', 'janesmith', 'Smith', 'Jane', '$2a$12$JaIvQSUy9fJuuE4X4OPTfu6LY6eYcSqzmKToN2H0k2Xt9VByC4Ft2');

-- Depots
INSERT INTO Depots (user_id, address, location, name) VALUES
(1, '123 Main St, Cluj-Napoca, Romania', ST_GeogFromText('SRID=4326;POINT(23.6665 46.7800)'), 'Cluj Depot'),
(1, '45 Central Blvd, Bucharest, Romania', ST_GeogFromText('SRID=4326;POINT(26.1025 44.4268)'), 'Bucharest Depot'),
(1, '12 Union Sq, Timisoara, Romania', ST_GeogFromText('SRID=4326;POINT(21.2290 45.7489)'), 'Timisoara Depot');

-- Cars for Depots
-- Depot 1: Cluj Depot
INSERT INTO Cars (depot_id, vin, make, model, year, consumption, max_weight) VALUES
(1, 'CLJ001', 'Ford', 'Transit', 2018, 10.5, 1200),
(1, 'CLJ002', 'Renault', 'Master', 2020, 11.0, 1000);

-- Depot 2: Bucharest Depot
INSERT INTO Cars (depot_id, vin, make, model, year, consumption, max_weight) VALUES
(2, 'BUC001', 'Mercedes', 'Sprinter', 2019, 12.0, 1500),
(2, 'BUC002', 'VW', 'Crafter', 2021, 10.0, 1200),
(2, 'BUC003', 'Fiat', 'Ducato', 2020, 11.0, 1000),
(2, 'BUC004', 'Iveco', 'Daily', 2018, 12.5, 1400),
(2, 'BUC005', 'Opel', 'Movano', 2019, 11.5, 1300);

-- Depot 3: Timisoara Depot
INSERT INTO Cars (depot_id, vin, make, model, year, consumption, max_weight) VALUES
(3, 'TIM001', 'Mercedes', 'Sprinter', 2021, 11.5, 1500),
(3, 'TIM002', 'VW', 'Crafter', 2020, 10.5, 1200),
(3, 'TIM003', 'Fiat', 'Ducato', 2019, 1100, 10.0),
(3, 'TIM004', 'Iveco', 'Daily', 2018, 12.0, 1400),
(3, 'TIM005', 'Opel', 'Movano', 2020, 11.0, 1300),
(3, 'TIM006', 'Renault', 'Master', 2021, 10.0, 1200),
(3, 'TIM007', 'Ford', 'Transit', 2019, 11.0, 1100),
(3, 'TIM008', 'Mercedes', 'Sprinter', 2021, 12.0, 1500),
(3, 'TIM009', 'VW', 'Crafter', 2020, 11.0, 1200),
(3, 'TIM010', 'Fiat', 'Ducato', 2019, 10.5, 1000);

-- Packages for Depots
-- Depot 1: Cluj Depot (5 packages, total weight ~2000kg)
INSERT INTO Packages (depot_id, address, location, weight, name, phone_number, delivery_date) VALUES
(1, 'Str. Regele Ferdinand 15, Cluj-Napoca', ST_GeogFromText('SRID=4326;POINT(23.5907 46.7660)'), 400, 'Package 1', '0721000001', '2025-09-01'),
(1, 'Str. Memorandumului 10, Cluj-Napoca', ST_GeogFromText('SRID=4326;POINT(23.5835 46.7702)'), 350, 'Package 2', '0721000002', '2025-09-01'),
(1, 'Str. Napoca 25, Cluj-Napoca', ST_GeogFromText('SRID=4326;POINT(23.6012 46.7755)'), 450, 'Package 3', '0721000003', '2025-09-01'),
(1, 'Str. Horea 12, Cluj-Napoca', ST_GeogFromText('SRID=4326;POINT(23.5980 46.7790)'), 400, 'Package 4', '0721000004', '2025-09-01'),
(1, 'Str. Eroilor 8, Cluj-Napoca', ST_GeogFromText('SRID=4326;POINT(23.5950 46.7810)'), 350, 'Package 5', '0721000005', '2025-09-01');

-- Depot 2: Bucharest Depot (10 packages, total weight ~5000kg)
INSERT INTO Packages (depot_id, address, location, weight, name, phone_number, delivery_date) VALUES
(2, 'Calea Victoriei 12, Bucharest', ST_GeogFromText('SRID=4326;POINT(26.1020 44.4320)'), 500, 'Package 1', '0722000001', '2025-09-01'),
(2, 'Str. Lipscani 20, Bucharest', ST_GeogFromText('SRID=4326;POINT(26.1035 44.4350)'), 450, 'Package 2', '0722000002', '2025-09-01'),
(2, 'Bd. Unirii 30, Bucharest', ST_GeogFromText('SRID=4326;POINT(26.1060 44.4285)'), 550, 'Package 3', '0722000003', '2025-09-01'),
(2, 'Str. Academiei 15, Bucharest', ST_GeogFromText('SRID=4326;POINT(26.1025 44.4325)'), 600, 'Package 4', '0722000004', '2025-09-01'),
(2, 'Str. Stirbei Voda 8, Bucharest', ST_GeogFromText('SRID=4326;POINT(26.1050 44.4250)'), 500, 'Package 5', '0722000005', '2025-09-01'),
(2, 'Str. Magheru 5, Bucharest', ST_GeogFromText('SRID=4326;POINT(26.1070 44.4310)'), 450, 'Package 6', '0722000006', '2025-09-01'),
(2, 'Str. Calea Mosilor 40, Bucharest', ST_GeogFromText('SRID=4326;POINT(26.1110 44.4290)'), 550, 'Package 7', '0722000007', '2025-09-01'),
(2, 'Str. Mihail Kogalniceanu 10, Bucharest', ST_GeogFromText('SRID=4326;POINT(26.1045 44.4340)'), 500, 'Package 8', '0722000008', '2025-09-01'),
(2, 'Str. Brezoianu 6, Bucharest', ST_GeogFromText('SRID=4326;POINT(26.1020 44.4305)'), 500, 'Package 9', '0722000009', '2025-09-01'),
(2, 'Str. Eroilor 18, Bucharest', ST_GeogFromText('SRID=4326;POINT(26.1080 44.4275)'), 450, 'Package 10', '0722000010', '2025-09-01');

-- Depot 3: Timisoara Depot (25 packages, total weight ~12000kg)
INSERT INTO Packages (depot_id, address, location, weight, name, phone_number, delivery_date) VALUES
-- We'll just generate weights between 400-600kg to keep total around 12000
(3, 'Bd. C. D. Loga 10, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2230 45.7510)'), 480, 'Package 1', '0723000001', '2025-09-01'),
(3, 'Str. Alba Iulia 5, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2245 45.7530)'), 500, 'Package 2', '0723000002', '2025-09-01'),
(3, 'Str. Marasesti 12, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2250 45.7545)'), 520, 'Package 3', '0723000003', '2025-09-01'),
(3, 'Str. Emanoil Ungureanu 20, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2260 45.7555)'), 480, 'Package 4', '0723000004', '2025-09-01'),
(3, 'Str. Piaristilor 8, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2270 45.7560)'), 500, 'Package 5', '0723000005', '2025-09-01'),
(3, 'Str. 16 Decembrie 1989 15, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2280 45.7570)'), 520, 'Package 6', '0723000006', '2025-09-01'),
(3, 'Str. Huniade 12, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2290 45.7580)'), 480, 'Package 7', '0723000007', '2025-09-01'),
(3, 'Str. Lucian Blaga 6, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2300 45.7590)'), 500, 'Package 8', '0723000008', '2025-09-01'),
(3, 'Str. Martirilor 10, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2310 45.7600)'), 520, 'Package 9', '0723000009', '2025-09-01'),
(3, 'Str. Traian Grozavescu 8, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2320 45.7610)'), 480, 'Package 10', '0723000010', '2025-09-01'),
-- 15 more packages (repeat pattern to reach 25)
(3, 'Str. Politehnicii 5, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2330 45.7620)'), 500, 'Package 11', '0723000011', '2025-09-01'),
(3, 'Str. C.D. Loga 7, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2340 45.7630)'), 520, 'Package 12', '0723000012', '2025-09-01'),
(3, 'Str. Cluj 10, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2350 45.7640)'), 480, 'Package 13', '0723000013', '2025-09-01'),
(3, 'Str. Fabricii 8, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2360 45.7650)'), 500, 'Package 14', '0723000014', '2025-09-01'),
(3, 'Str. Regele Ferdinand 15, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2370 45.7660)'), 520, 'Package 15', '0723000015', '2025-09-01'),
(3, 'Str. Blaga 5, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2380 45.7670)'), 480, 'Package 16', '0723000016', '2025-09-01'),
(3, 'Str. Fabric 12, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2390 45.7680)'), 500, 'Package 17', '0723000017', '2025-09-01'),
(3, 'Str. Punctelor 8, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2400 45.7690)'), 520, 'Package 18', '0723000018', '2025-09-01'),
(3, 'Str. Vasile Goldis 10, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2410 45.7700)'), 480, 'Package 19', '0723000019', '2025-09-01'),
(3, 'Str. Circumvalatiunii 6, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2420 45.7710)'), 500, 'Package 20', '0723000020', '2025-09-01'),
(3, 'Str. Calea Sagului 15, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2430 45.7720)'), 520, 'Package 21', '0723000021', '2025-09-01'),
(3, 'Str. Pestalozzi 7, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2440 45.7730)'), 480, 'Package 22', '0723000022', '2025-09-01'),
(3, 'Str. Mihai Viteazul 12, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2450 45.7740)'), 500, 'Package 23', '0723000023', '2025-09-01'),
(3, 'Str. Iuliu Maniu 9, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2460 45.7750)'), 520, 'Package 24', '0723000024', '2025-09-01'),
(3, 'Str. P-ta Unirii 1, Timisoara', ST_GeogFromText('SRID=4326;POINT(21.2470 45.7760)'), 480, 'Package 25', '0723000025', '2025-09-01');
