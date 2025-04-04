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

CREATE TABLE vendor (
    vendor_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    website VARCHAR(255) NOT NULL,
    CONSTRAINT ven_pk PRIMARY KEY (vendor_id)
);

-- VENDOR_OWNS_PACKAGE table
CREATE TABLE vendor_owns_package (
    vendor_id INT NOT NULL,
    package_id INT NOT NULL,
    CONSTRAINT vop_pk PRIMARY KEY (vendor_id, package_id),
    CONSTRAINT vop_vendor_fk FOREIGN KEY (vendor_id)
        REFERENCES vendor(vendor_id),
    CONSTRAINT vop_package_fk FOREIGN KEY (package_id)
        REFERENCES package(package_id)
);

-- DEVELOPER_WORKS_ON_PACKAGE table
CREATE TABLE developer_works_on_package (
    user_id INT NOT NULL,
    package_id INT NOT NULL,
    CONSTRAINT dwop_pk PRIMARY KEY (user_id, package_id),
    CONSTRAINT dwop_user_fk FOREIGN KEY (user_id)
        REFERENCES developer(user_id),
    CONSTRAINT dwop_package_fk FOREIGN KEY (package_id)
        REFERENCES package(package_id)
);

-- PACKAGE_HAS_REVIEW table (junction table)
CREATE TABLE package_has_review (
    package_id INT NOT NULL,
    review_id INT NOT NULL,
    CONSTRAINT phr_pk PRIMARY KEY (package_id, review_id),
    CONSTRAINT phr_package_fk FOREIGN KEY (package_id)
        REFERENCES package(package_id),
    CONSTRAINT phr_review_fk FOREIGN KEY (review_id)
        REFERENCES review(review_id)
);

-- REPOSITORY_SERVES_MIRROR table
CREATE TABLE repository_serves_mirror (
    repository_id INT NOT NULL,
    mirror_url VARCHAR(255) NOT NULL,
    CONSTRAINT rsm_pk PRIMARY KEY (repository_id, mirror_url),
    CONSTRAINT rsm_repo_fk FOREIGN KEY (repository_id)
        REFERENCES repository(repository_id),
    CONSTRAINT rsm_mirror_fk FOREIGN KEY (mirror_url)
        REFERENCES mirror(mirror_url)
);

-- DOCUMENTATION TABLES (resolving circular dependency)
CREATE TABLE docu_author (
    author_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    CONSTRAINT da_pk PRIMARY KEY (author_id)
);

CREATE TABLE documentation (
    doc_id INT NOT NULL AUTO_INCREMENT,
    language VARCHAR(2) NOT NULL,
    country VARCHAR(2) NOT NULL,
    content LONGTEXT NOT NULL,
    author_id INT NOT NULL,
    CONSTRAINT doc_pk PRIMARY KEY (doc_id),
    CONSTRAINT doc_author_fk FOREIGN KEY (author_id)
        REFERENCES docu_author(author_id)
);

ALTER TABLE docu_author
ADD COLUMN doc_id INT,
ADD CONSTRAINT da_doc_fk FOREIGN KEY (doc_id)
    REFERENCES documentation(doc_id);

-- LOCALISATION table
CREATE TABLE localisation (
    loc_id INT NOT NULL AUTO_INCREMENT,
    language VARCHAR(2) NOT NULL,
    country VARCHAR(2) NOT NULL,
    CONSTRAINT loc_pk PRIMARY KEY (loc_id),
    CONSTRAINT loc_unique UNIQUE (language, country)
);

-- VERSION_HAS_LOC_DOC table
CREATE TABLE version_has_loc_doc (
    version_id INT NOT NULL,
    loc_id INT NOT NULL,
    CONSTRAINT vhld_pk PRIMARY KEY (version_id, loc_id),
    CONSTRAINT vhld_version_fk FOREIGN KEY (version_id)
        REFERENCES version(version_id),
    CONSTRAINT vhld_loc_fk FOREIGN KEY (loc_id)
        REFERENCES localisation(loc_id)
);

-- USER_REPLIES_TO_ISSUE table
CREATE TABLE user_replies_to_issue (
    user_id INT NOT NULL,
    issue_id INT NOT NULL,
    reply_timestamp TIMESTAMP NOT NULL,
    CONSTRAINT urti_pk PRIMARY KEY (user_id, issue_id, reply_timestamp),
    CONSTRAINT urti_user_fk FOREIGN KEY (user_id)
        REFERENCES user(user_id),
    CONSTRAINT urti_issue_fk FOREIGN KEY (issue_id)
        REFERENCES issue(issue_id)
);

-- PROVIDER_HOSTS_MIRROR table
CREATE TABLE provider_hosts_mirror (
    provider_id INT NOT NULL,
    mirror_url VARCHAR(255) NOT NULL,
    CONSTRAINT phm_pk PRIMARY KEY (provider_id, mirror_url),
    CONSTRAINT phm_provider_fk FOREIGN KEY (provider_id)
        REFERENCES provider(provider_id),
    CONSTRAINT phm_mirror_fk FOREIGN KEY (mirror_url)
        REFERENCES mirror(mirror_url)
);
