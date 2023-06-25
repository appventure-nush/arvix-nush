DROP DATABASE IF EXISTS arxivnush;
CREATE DATABASE arxivnush;
USE arxivnush;

CREATE TABLE organisation(
    oid VARCHAR(200),
    address VARCHAR(200),
    name VARCHAR(200),
    PRIMARY KEY (oid)
);

CREATE TABLE user(
    uid VARCHAR(200),
    email VARCHAR(200) UNIQUE,
    username VARCHAR(200) UNIQUE,
    name VARCHAR(200),
    institution VARCHAR(200),
    gradYear INT,
    admin BIT,
    emergencyContact VARCHAR(200),
    student BIT,
    teacher BIT,
    mentor BIT,
    PRIMARY KEY (uid),
    FOREIGN KEY (emergencyContact) REFERENCES user (uid)
);

CREATE TABLE fromOrganisation(
    uid VARCHAR(200),
    oid VARCHAR(200),
    department VARCHAR(200),
    PRIMARY KEY(oid, uid)
);

CREATE TABLE project(
    pcode VARCHAR(200),
    title VARCHAR(200),
    abstract TEXT,
    year INT,
    reportPDF VARCHAR(200),
    abstractPDF VARCHAR(200),
    nextProject VARCHAR(200),
    prevProject VARCHAR(200),
    PRIMARY KEY (pcode),
    FOREIGN KEY (prevProject) REFERENCES project (pcode),
    FOREIGN KEY (nextProject) REFERENCES project (pcode)
);

CREATE TABLE worksOn(
    uid VARCHAR(200),
    pcode VARCHAR(200),
    PRIMARY KEY (uid, pcode),
    FOREIGN KEY (uid) REFERENCES user (uid),
    FOREIGN KEY (pcode) REFERENCES project (pcode)
);

CREATE TABLE mentors(
    uid VARCHAR(200),
    pcode VARCHAR(200),
    PRIMARY KEY (uid, pcode),
    FOREIGN KEY (uid) REFERENCES user (uid),
    FOREIGN KEY (pcode) REFERENCES project (pcode)
);

CREATE TABLE annoucement(
    pcode VARCHAR(200),
    annoucement TEXT,
    time DATETIME,
    PRIMARY KEY (pcode, annoucement(100), time),
    FOREIGN KEY (pcode) REFERENCES project (pcode) ON DELETE CASCADE
);

CREATE TABLE reference(
    rid VARCHAR(200),
    title VARCHAR(200),
    type VARCHAR(200),
    minPage INT,
    maxPage INT,
    publisher VARCHAR(200),
    bibtex TEXT,
    PRIMARY KEY (rid)
);

CREATE TABLE log(
    pcode VARCHAR(200),
    lnumber INT,
    uid VARCHAR(200),
    title VARCHAR(200),
    date DATETIME,
    text TEXT,
    PRIMARY KEY (pcode, lnumber),
    FOREIGN KEY (pcode) REFERENCES project (pcode) ON DELETE CASCADE,
    FOREIGN KEY (uid) REFERENCES user (uid) ON DELETE SET NULL
);

CREATE TABLE task(
    pcode VARCHAR(200),
    tnumber INT,
    title VARCHAR(200),
    description TEXT,
    deadline DATETIME,
    completed INT,
    PRIMARY KEY (pcode, tnumber),
    FOREIGN KEY (pcode) REFERENCES project (pcode) ON DELETE CASCADE
);

CREATE TABLE assigned(
    uid VARCHAR(200),
    pcode INT,
    tnumber INT,
    PRIMARY KEY (uid, pcode, tnumber),
    FOREIGN KEY (uid) REFERENCES user (uid) ON DELETE CASCADE,
    FOREIGN KEY (pcode, tnumber) REFERENCES task (pcode, tnumber) ON DELETE CASCADE
);

CREATE TABLE authors(
    rid VARCHAR(200),
    author VARCHAR(200),
    PRIMARY KEY (rid, author),
    FOREIGN KEY (rid) REFERENCES reference (rid) ON DELETE CASCADE
);

CREATE TABLE cited(
    rid VARCHAR(200),
    pcode VARCHAR(200),
    PRIMARY KEY (rid, pcode),
    FOREIGN KEY (rid) REFERENCES reference (rid) ON DELETE CASCADE,
    FOREIGN KEY (pcode) REFERENCES project (pcode) ON DELETE CASCADE
);

CREATE TABLE isRead(
    rid VARCHAR(200),
    uid VARCHAR(200),
    hasRead INT,
    PRIMARY KEY (uid, rid),
    FOREIGN KEY (uid) REFERENCES user (uid) ON DELETE CASCADE,
    FOREIGN KEY (rid) REFERENCES reference (rid) ON DELETE CASCADE
);

CREATE TABLE submissionPlace(
    placeId INT,
    about TEXT,
    name VARCHAR(200),
    PRIMARY KEY (placeId)
);

CREATE TABLE submission(
    pcode VARCHAR(200),
    submissionId INT,
    date DATETIME,
    reportPDF VARCHAR(200),
    posterPDF VARCHAR(200),
    placeId INT,
    PRIMARY KEY (pcode, submissionId),
    FOREIGN KEY (placeId) REFERENCES submissionPlace (placeId),
    FOREIGN KEY (pcode) REFERENCES project (pcode)
);

CREATE TABLE miscMaterials(
    pcode VARCHAR(200),
    submissionId INT,
    file VARCHAR(200),
    PRIMARY KEY (pcode, submissionId),
    FOREIGN KEY (pcode) REFERENCES submission (pcode),
    FOREIGN KEY (submissionId) REFERENCES submission (submissionId)
);

CREATE TABLE awards(
    pcode VARCHAR(200),
    submissionId INT,
    placeId INT,
    name VARCHAR(200),
    prize VARCHAR(200),
    PRIMARY KEY (pcode, submissionId, placeId),
    FOREIGN KEY (pcode) REFERENCES submission (pcode),
    FOREIGN KEY (submissionId) REFERENCES submission (submissionId),
    FOREIGN KEY (placeId) REFERENCES submissionPlace (placeId)
);

CREATE TABLE published(
    pcode VARCHAR(200),
    submissionId INT,
    placeId INT,
    doi VARCHAR(200),
    url VARCHAR(200),
    PRIMARY KEY (pcode, submissionId, placeId),
    FOREIGN KEY (pcode) REFERENCES submission (pcode),
    FOREIGN KEY (submissionId) REFERENCES submission (submissionId),
    FOREIGN KEY (placeId) REFERENCES submissionPlace (placeId)
);

CREATE TABLE awardTypes(
    placeId INT,
    award VARCHAR(200),
    PRIMARY KEY (placeId),
    FOREIGN KEY (placeId) REFERENCES submissionPlace (placeId)
);

CREATE TABLE publisher(
    placeId INT,
    website VARCHAR(200),
    isJournal BIT,
    PRIMARY KEY (placeId),
    FOREIGN KEY (placeId) REFERENCES submissionPlace (placeId)
);
