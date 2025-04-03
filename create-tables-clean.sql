-- Create database
CREATE DATABASE pacman_db;
USE pacman_db;

-- USER table
CREATE TABLE `user` (
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    CONSTRAINT usr_pk PRIMARY KEY (user_id)
);

-- CATEGORY table (fixed circular dependency)
CREATE TABLE category (
    category_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    CONSTRAINT cat_pk PRIMARY KEY (category_id)
);

-- PACKAGE table
CREATE TABLE package (
    package_id INT NOT NULL,
    category_id INT NOT NULL,
    CONSTRAINT pkg_pk PRIMARY KEY (package_id),
    CONSTRAINT pkg_fk FOREIGN KEY (category_id)
        REFERENCES category(category_id)
);

-- CLIENT table
CREATE TABLE client (
    user_id INT PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES `user`(user_id)
);

-- DEVELOPER table
CREATE TABLE developer (
    user_id INT PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES `user`(user_id)
);

-- OPEN_SOURCE table
CREATE TABLE open_source (
    package_id INT PRIMARY KEY,
    license VARCHAR(50) NOT NULL,
    FOREIGN KEY (package_id) REFERENCES package(package_id)
);

-- PROPRIETARY table
CREATE TABLE proprietary (
    package_id INT PRIMARY KEY,
    license VARCHAR(50) NOT NULL,
    price INT NOT NULL,
    FOREIGN KEY (package_id) REFERENCES package(package_id)
);

-- PROVIDER table
CREATE TABLE provider (
    provider_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    PRIMARY KEY (provider_id)
);

-- REPOSITORY table (created earlier to avoid forward references)
CREATE TABLE repository (
    repository_id INT NOT NULL,
    repo_name VARCHAR(255) NOT NULL,
    public_key VARCHAR(255) NOT NULL,
    package_id INT NOT NULL,
    CONSTRAINT repo_pk PRIMARY KEY (repository_id),
    CONSTRAINT repo_fk FOREIGN KEY (package_id) REFERENCES package(package_id)
);

-- MIRROR table (fixed foreign key)
CREATE TABLE mirror (
    mirror_url VARCHAR(255) NOT NULL,
    repository_id INT NOT NULL,
    mirror_country VARCHAR(255),
    mirror_city VARCHAR(255),
    throughput INT,
    CONSTRAINT m_pk PRIMARY KEY (mirror_url),
    CONSTRAINT m_fk FOREIGN KEY (repository_id)
        REFERENCES repository(repository_id)
);

-- Updated PROVIDER_HOSTS_MIRROR table
CREATE TABLE provider_hosts_mirror (
    provider_id INT NOT NULL,
    mirror_url VARCHAR(255) NOT NULL,
    CONSTRAINT phm_pk PRIMARY KEY (provider_id, mirror_url),
    CONSTRAINT phm_provider_fk FOREIGN KEY (provider_id)
        REFERENCES provider(provider_id),
    CONSTRAINT phm_mirror_fk FOREIGN KEY (mirror_url)
        REFERENCES mirror(mirror_url)
);

-- REVIEW table
CREATE TABLE review (
    review_id INT NOT NULL,
    package_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    description LONGTEXT NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    CONSTRAINT re_pk PRIMARY KEY (review_id),
    CONSTRAINT re_pkg_fk FOREIGN KEY (package_id)
        REFERENCES package(package_id),
    CONSTRAINT re_user_fk FOREIGN KEY (user_id)
        REFERENCES `user`(user_id)
);

-- ISSUE table
CREATE TABLE issue (
    issue_id INT NOT NULL,
    user_id INT NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    issue_type ENUM('bug_report', 'feature_request') NOT NULL,
    CONSTRAINT iss_pk PRIMARY KEY (issue_id),
    CONSTRAINT iss_user_fk FOREIGN KEY (user_id)
        REFERENCES `user`(user_id)
);

-- FEATURE_REQUEST table
CREATE TABLE feature_request (
    issue_id INT NOT NULL,
    CONSTRAINT fr_pk PRIMARY KEY (issue_id),
    CONSTRAINT fr_issue_fk FOREIGN KEY (issue_id)
        REFERENCES issue(issue_id)
);

-- BUG_REPORT table
CREATE TABLE bug_report (
    issue_id INT NOT NULL,
    stack_trace LONGTEXT NOT NULL,
    CONSTRAINT br_pk PRIMARY KEY (issue_id),
    CONSTRAINT br_issue_fk FOREIGN KEY (issue_id)
        REFERENCES issue(issue_id)
);

-- REPLIES_TO table
CREATE TABLE replies_to (
    reply_id INT NOT NULL,
    user_id INT NOT NULL,
    issue_id INT NOT NULL,
    content LONGTEXT NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    CONSTRAINT rt_pk PRIMARY KEY (reply_id),
    CONSTRAINT rt_user_fk FOREIGN KEY (user_id)
        REFERENCES `user`(user_id),
    CONSTRAINT rt_issue_fk FOREIGN KEY (issue_id)
        REFERENCES issue(issue_id)
);

-- VERSION table (with surrogate key)
CREATE TABLE version (
    version_id INT NOT NULL AUTO_INCREMENT,
    package_id INT NOT NULL,
    version_no INT NOT NULL,
    architecture ENUM('i386', 'x86_64', 'aarch32', 'aarch64', 'ppc32', 
                     'ppc64', 'mips32', 'mips64', 'riscv64') NOT NULL,
    platform ENUM('windows-nt', 'osx-darwin', 'gnu-linux', 'bsd', 
                 'sel4', 'redox') NOT NULL,
    date DATE NOT NULL,
    CONSTRAINT ver_pk PRIMARY KEY (version_id),
    CONSTRAINT ver_pkg_fk FOREIGN KEY (package_id)
        REFERENCES package(package_id)
);

-- PACKAGE_HAS_VERSION table
CREATE TABLE package_has_version (
    package_id INT NOT NULL,
    version_id INT NOT NULL,
    CONSTRAINT phv_pk PRIMARY KEY (package_id, version_id),
    CONSTRAINT phv_pkg_fk FOREIGN KEY (package_id)
        REFERENCES package(package_id),
    CONSTRAINT phv_ver_fk FOREIGN KEY (version_id)
        REFERENCES version(version_id)
);

-- DEPENDS_ON table
CREATE TABLE depends_on (
    host_package_id INT NOT NULL,
    dependency_id INT NOT NULL,
    mandatory BOOLEAN DEFAULT TRUE,
    CONSTRAINT do_pk PRIMARY KEY (host_package_id, dependency_id),
    CONSTRAINT do_host_fk FOREIGN KEY (host_package_id)
        REFERENCES package(package_id),
    CONSTRAINT do_dep_fk FOREIGN KEY (dependency_id)
        REFERENCES package(package_id)
);

-- VERSION_CONTAINS_ISSUE table (using surrogate key)
CREATE TABLE version_contains_issue (
    version_id INT NOT NULL,
    issue_id INT NOT NULL,
    CONSTRAINT vci_pk PRIMARY KEY (version_id, issue_id),
    CONSTRAINT vci_ver_fk FOREIGN KEY (version_id)
        REFERENCES version(version_id),
    CONSTRAINT vci_issue_fk FOREIGN KEY (issue_id)
        REFERENCES issue(issue_id)
);
