CREATE DATABASE pacman_db;

use pacman_db;

-- USER[UserID, name, email]
CREATE TABLE `user` (
    `user_id` INT NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    CONSTRAINT usr_pk PRIMARY KEY (user_id)
);

CREATE TABLE category (
	category_id INT,
	package_id INT,
	name VARCHAR(255),
	CONSTRAINT cat_pk PRIMARY KEY (category_id)
);

-- PACKAGE[PackageID, CategoryID, name, description, website]
CREATE TABLE `package` (
    package_id INT NOT NULL,
    category_id INT NOT NULL,
    CONSTRAINT pkg_pk PRIMARY KEY (package_id),
    CONSTRAINT pkg_fk FOREIGN KEY (category_id)
        REFERENCES category(category_id)
);

ALTER TABLE category 
ADD CONSTRAINT cat_fk FOREIGN KEY (package_id) REFERENCES package(package_id);

CREATE TABLE client (
    user_id INT PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES `user`(user_id)
);

CREATE TABLE developer (
    user_id INT PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES `user`(user_id)
);

CREATE TABLE open_source (
    package_id INT PRIMARY KEY,
    license VARCHAR(50) NOT NULL,
    FOREIGN KEY (package_id) REFERENCES package(package_id)
);

CREATE TABLE proprietary (
    package_id INT PRIMARY KEY,
    license VARCHAR(50) NOT NULL,
    price int NOT NULL,
    FOREIGN KEY (package_id) REFERENCES package(package_id)
);

CREATE TABLE provider (
    id INT,
    mirror_url VARCHAR(255),
    name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id, mirror_url), 
    FOREIGN KEY (mirror_url) REFERENCES mirror(mirror_url)
);
-- REVIEW[ReviewID, PackageID, UserID, rating, description, timestamp]
CREATE TABLE review (
    review_id INT NOT NULL,
    package_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    `description` LONGTEXT NOT NULL,
    `timestamp` TIMESTAMP NOT NULL,
    CONSTRAINT re_pk PRIMARY KEY (review_id),
    CONSTRAINT re_p_id_fk FOREIGN KEY (package_id) REFERENCES `package` (package_id),
    CONSTRAINT re_u_id_fk FOREIGN KEY (user_id) REFERENCES `user` (user_id)
);

-- ISSUE[IssueID, UserID, timestamp, title]
CREATE TABLE issue (
    issue_id INT NOT NULL,
    user_id INT NOT NULL,
    `timestamp` TIMESTAMP NOT NULL,
    issue_type ENUM( 'bug_report', 'feature_request' ) NOT NULL,
    CONSTRAINT iss_pk PRIMARY KEY (issue_id),
    CONSTRAINT iss_fk FOREIGN KEY (user_id) REFERENCES `user`(user_id)
);

-- FEATURE_REQUEST[IssueID]
CREATE TABLE feature_request (
    issue_id INT NOT NULL,
    CONSTRAINT fr_pk PRIMARY KEY (issue_id),
    CONSTRAINT fr_fk FOREIGN KEY (issue_id) REFERENCES issue(issue_id)
);

-- BUG_REPORT[IssueID, stackTrace]
CREATE TABLE bug_report (
    issue_id INT NOT NULL,
    stack_trace LONGTEXT NOT NULL,
    CONSTRAINT br_pk PRIMARY KEY (issue_id),
    CONSTRAINT br_fk FOREIGN KEY (issue_id) REFERENCES issue(issue_id)
);

-- REPLIES_TO[ReplyID, UserID, IssueID, content, timestamp]

CREATE TABLE replies_to (
    reply_id INT NOT NULL,
    user_id INT NOT NULL,
    issue_id INT NOT NULL,
    `content` LONGTEXT NOT NULL,
    `timestamp` TIMESTAMP NOT NULL,
    CONSTRAINT rt_pk PRIMARY KEY (reply_id),
    CONSTRAINT rt_u_id_fk FOREIGN KEY (user_id) REFERENCES `user`(user_id),
    CONSTRAINT rt_i_id_fk FOREIGN KEY (issue_id) REFERENCES issue(issue_id)
);


-- VERSION[VersionNo, architecture, platform, PackageID, date]
CREATE TABLE version (
    package_id INT NOT NULL,
    version_no INT NOT NULL,
    architecture ENUM('i386', 'x86_64', 'aarch32', 'aarch64', 'ppc32', 'ppc64', 'mips32', 'mips64', 'riscv64') NOT NULL,
    platform ENUM('windows-nt', 'osx-darwin', 'gnu-linux', 'bsd', 'sel4', 'redox') NOT NULL,
    `date` DATE NOT NULL,
    CONSTRAINT ver_pk PRIMARY KEY (package_id, version_no, architecture, platform),
    CONSTRAINT ver_pkg_id_fk FOREIGN KEY (package_id) REFERENCES `package`(package_id)
);

-- PACKAGE_HAS_VERSION[PackageID, VersionNo]_HAS_VERSION

CREATE TABLE package_has_version (
    package_id INT,
    version_no INT,  
    CONSTRAINT phv_pk PRIMARY KEY (package_id, version_no),
    CONSTRAINT phv_fk FOREIGN KEY (package_id) 
        REFERENCES package(package_id)
);

-- DEPENDS_ON[HostPackageID, DependencyID, Mandatory]

CREATE TABLE depends_on (
    host_package_id INT,
    dependency_id   INT,
    mandatory       BOOLEAN DEFAULT TRUE,
    CONSTRAINT do_pk PRIMARY KEY (host_package_id, dependency_id),
    CONSTRAINT do_fk FOREIGN KEY (host_package_id, dependency_id)
        REFERENCES package(package_id)
);

-- VENDOR_OWNS_PACKAGE[VendorWebsite, VendorName, PackageID]

CREATE TABLE vendor_owns_package (
    vendor_website VARCHAR(256),
    vendor_name    VARCHAR(256),
    package_id     INT,
    CONSTRAINT vop_pk PRIMARY KEY (vendor_website),
    CONSTRAINT vop_fk FOREIGN KEY (package_id)
        REFERENCES package(package_id)
);

-- DEVELOPER_WORKS_ON_PACKAGE[UserID, PackageID]

CREATE TABLE developer_works_on_package (
    user_id    INT,
    package_id INT,
    CONSTRAINT dwop_pk PRIMARY KEY (user_id, package_id),
    CONSTRAINT dwop_u_id_fk FOREIGN KEY (user_id)
        REFERENCES `user`(user_id),
    CONSTRAINT dwop_p_id_fk FOREIGN KEY (package_id)
        REFERENCES package(package_id)
);

-- PACKAGE_HAS_REVIEW[PackageID, ReviewID, UserID]

CREATE TABLE package_has_review (
    package_id INT,
    review_id  INT,
    user_id    INT,
    CONSTRAINT phr_pk PRIMARY KEY (package_id, review_id, user_id),
    CONSTRAINT phr_p_id_fk FOREIGN KEY (package_id)
        REFERENCES package(package_id),
    CONSTRAINT phr_r_id_fk FOREIGN KEY (review_id)
        REFERENCES review(review_id),
    CONSTRAINT phr_u_id_fk FOREIGN KEY (user_id)
        REFERENCES `user`(user_id)
);

-- PACKAGE_BELONGS_TO_CATEGORY[PackageID, CategoryID]

CREATE TABLE package_belongs_to_category (
    package_id  INT,
    category_id INT,
    CONSTRAINT pbtc_pk PRIMARY KEY (package_id, category_id),
    CONSTRAINT pbtc_p_id_fk FOREIGN KEY (package_id)
        REFERENCES package(package_id),
    CONSTRAINT pbtc_c_id_fk FOREIGN KEY (category_id)
        REFERENCES category(category_id)
);

-- PACKAGE_PROVIDED_BY_REPOSITORY[PackageID, RepositoryID]

CREATE TABLE package_provided_by_repository (
    package_id    INT,
    repository_id INT,
    CONSTRAINT ppbr_pk PRIMARY KEY (package_id),
    CONSTRAINT ppbr_p_id_fk FOREIGN KEY (package_id)
        REFERENCES package(package_id),
    CONSTRAINT ppbr_r_id_fk FOREIGN KEY (repository_id)
        REFERENCES repository(repository_id)
);

-- eEPOSITORY_SERVES_MIRROR[RepositoryID, MirrorUrl]

CREATE TABLE repository_serves_mirror (
    repository_id INT,
    mirror_url    VARCHAR(100),
    CONSTRAINT rsm_pk PRIMARY KEY (repository_id),
    CONSTRAINT rsm_fk FOREIGN KEY (repository_id)
        REFERENCES repository(repository_id)
);

-- PROVIDER_HOSTS_MIRROR[ProviderID, MirrorUrl] 

CREATE TABLE provider_hosts_mirror (
    provider_id INT,
    mirror_url  VARCHAR(100),
    CONSTRAINT phm_pk PRIMARY KEY (provider_id),
    CONSTRAINT phm_fk FOREIGN KEY (provider_id)
        REFERENCES provider(provider_id)
);

CREATE TABLE docu_author (
	author_id INT,
	name VARCHAR(255),
	language VARCHAR(255),
	country VARCHAR(255),
	CONSTRAINT da_pk PRIMARY KEY(author_id)
);

CREATE TABLE documentation (
	language VARCHAR(255),
	country VARCHAR(255),
	author_id INT,
	CONSTRAINT doc_pk PRIMARY KEY (language, country),
	CONSTRAINT doc_fk FOREIGN KEY (author_id) REFERENCES docu_author(author_id)
);

ALTER TABLE docu_author 
ADD CONSTRAINT da_fk FOREIGN KEY(language, country) REFERENCES documentation(language, country);

CREATE TABLE author_writes_doc (
	file_id INT,
	author_id INT,
	CONSTRAINT awd_pk PRIMARY KEY (file_id, author_id),
	CONSTRAINT awd_fk FOREIGN KEY (author_id) REFERENCES docu_author(author_id)
);

CREATE TABLE localisation  (
	language VARCHAR(255),
	country VARCHAR(255),
	CONSTRAINT loc_pk PRIMARY KEY (language, country)
);

CREATE TABLE version_has_loc_doc (
	package_id INT,
	version_no INT,
	loc_country VARCHAR(255),
	loc_language VARCHAR(255),
	file_id	INT,
	CONSTRAINT vhld_pk PRIMARY KEY (version_no, package_id, loc_country, loc_language),
	CONSTRAINT vhld_loc_fk FOREIGN KEY(loc_country, loc_language) REFERENCES localisation(loc_country, loc_language),
	CONSTRAINT vhld_version_fk FOREIGN KEY(version_no) REFERENCES version(version_no),
	CONSTRAINT vhld_package_fk FOREIGN KEY(package_id) REFERENCES package(package_id)
);

CREATE TABLE vendor (
	package_id INT,
	name VARCHAR(255),
	website VARCHAR(255),
	CONSTRAINT ven_pk PRIMARY KEY (name, website, package_id),
	CONSTRAINT ven_fk FOREIGN KEY (package_id) REFERENCES package(package_id)
);


CREATE TABLE repository (
    repository_id INT,
	repo_name VARCHAR(255),
	public_key VARCHAR(255),
	mirror_url VARCHAR(255),
	package_id INT,
	CONSTRAINT repo_pk PRIMARY KEY (repository_id, repo_name, public_key),
	CONSTRAINT repo_fk FOREIGN KEY (package_id) REFERENCES package(package_id)
);

CREATE TABLE mirror (
	mirror_url VARCHAR(255),
    repository_id INT,
	repo_name VARCHAR(255),
	public_key VARCHAR(255),
	mirror_country VARCHAR(255),
	mirror_city VARCHAR(255),
	throughput INT,
	CONSTRAINT m_pk PRIMARY KEY (mirror_url, repository_id),
	CONSTRAINT m_fk FOREIGN KEY (repository_id, repo_name, public_key) REFERENCES repository(repository_id, repo_name, public_key)	
);


CREATE TABLE user_replies_to_issue (
    user_id INT,
    issue_id INT,
    reply_date DATE,
    PRIMARY KEY (user_id, issue_id, reply_date),
    FOREIGN KEY (user_id) REFERENCES `user`(user_id),
    FOREIGN KEY (issue_id) REFERENCES issue(issue_id)
);

CREATE TABLE user_writes_issue (
    user_id INT,
    issue_id INT,
    PRIMARY KEY (user_id, issue_id),
    FOREIGN KEY (user_id) REFERENCES `user`(user_id),
    FOREIGN KEY (issue_id) REFERENCES issue(issue_id)
);

CREATE TABLE user_writes_review (
    user_id INT,
    review_id INT,
    PRIMARY KEY (user_id, review_id),
    FOREIGN KEY (user_id) REFERENCES `user`(user_id),
    FOREIGN KEY (review_id) REFERENCES review(id)
);

CREATE TABLE version_contains_issue (
    version_no INT,
    issue_id INT,
    PRIMARY KEY (version_no, issue_id),
    FOREIGN KEY (version_no) REFERENCES version(version_no),
    FOREIGN KEY (issue_id) REFERENCES issue(issue_id)
);

-- VENDOR table
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

-- DOCUMENTATION TABLES 
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

