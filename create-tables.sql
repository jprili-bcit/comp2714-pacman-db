CREATE DATABASE pacman_db;

use pacman_db;

-- USER[UserID, name, email]
CREATE TABLE `user` (
    `user_id` INT NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    CONSTRAINT usr_pk PRIMARY KEY (user_id),
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

-- PACKAGE[PackageID, CategoryID, name, description, website]
CREATE TABLE `package` (
    package_id INT NOT NULL,
    category_id INT NOT NULL,
    CONSTRAINT pkg_pk PRIMARY KEY (package_id),
    CONSTRAINT pkg_fk FOREIGN KEY (category_id)
        REFERENCES category(category_id)
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
        REFERENCES (package.package_id)
);

-- DEVELOPER_WORKS_ON_PACKAGE[UserID, PackageID]

CREATE TABLE developer_works_on_package (
    user_id    INT,
    package_id INT
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
    user_id    INT
    CONSTRAINT phr_pk PRIMARY KEY (package_id, review_id, user_id),
    CONSTRAINT phr_p_id_fk FOREIGN KEY (package_id)
        REFERENCES package(package_id),
    CONSTRAINT phr_r_id_fk FOREIGN KEY (review_id)
        REFERENCES review(review_id),
    CONSTRAINT phr_u_id_fk FOREIGN KEY (user_id)
        REFERENCES `user`(package_id)
);

-- PACKAGE_BELONGS_TO_CATEGORY[PackageID, CategoryID]

CREATE TABLE package_belongs_to_category (
    package_id  INT,
    category_id INT,
    CONSTRAINT pbtc_pk PRIMARY KEY (package_id, category_id),
    CONSTRAINT pbtc_p_id_fk FOREIGN KEY (package_id)
        REFERENCES package(package_id),
    CONSTRAINT pbtc_c_id_fk FOREIGN KEY (package_id)
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
        REFERENCES package(repository_id)
);

-- REPOSITORY_SERVES_MIRROR[RepositoryID, MirrorUrl]

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
    CONSTRAINT phm_fg FOREIGN KEY (provider_id)
        REFERENCES provider(provider_id)
);

-- DEPENDS_ON[HostPackageID, DependencyID, mandatory]
CREATE TABLE depends_on (
    host_package_id INT NOT NULL,
    dependency_id INT NOT NULL,
    mandatory BOOLEAN NOT NULL,
    CONSTRAINT do_pk PRIMARY KEY (host_package_id, dependency_id),
    CONSTRAINT do_hp_id FOREIGN KEY (host_package_id) REFERENCES `package`(package_id),
    CONSTRAINT do_d_id FOREIGN KEY (dependency_id) REFERENCES `package`(package_id)
);

-- VERSION[VersionNo, architecture, platform, PackageID, date]
CREATE TABLE version (
    package_id INT NOT NULL,
    version_number TEXT NOT NULL,
    architecture ENUM('i386', 'x86_64', 'aarch32', 'aarch64', 'ppc32', 'ppc64', 'mips32', 'mips64', 'riscv64') NOT NULL,
    platform ENUM('windows-nt', 'osx-darwin', 'gnu-linux', 'bsd', 'sel4', 'redox') NOT NULL,
    `date` DATE NOT NULL,
    CONSTRAINT ver_pk PRIMARY KEY (package_id, version_number, architecture, platform),
    CONSTRAINT ver_pkg_id_fk FOREIGN KEY (package_id) REFERENCES `package`(package_id),
);

CREATE TABLE documentation (
	language CHAR[255],
	country CHAR[255],
	author_id INT,
	CONSTRAINT doc_pk PRIMARY KEY (language, country),
	CONSTRAINT doc_fk FOREIGN KEY (author_id) REFERENCES docu_author(author_id)
);

CREATE TABLE docu_author (
	author_id INT,
	name CHAR[255],
	language CHAR[255],
	country CHAR[255],
	CONSTRAINT da_pk PRIMARY KEY(author_id)
	CONSTRAINT da_fk FOREIGN KEY(language, country) REFERENCES documentation(language, country)
);

CREATE TABLE author_writes_doc (
	file_id INT,
	author_id INT,
	CONTRAINT awd_pk PRIMARY KEY (file_id, author_id),
	CONTRAINT awd_fk FOREIGN KEY (author_id) REFERENCES docu_author(author_id)
);

CREATE TABLE localisation  (
	language CHAR[255],
	country CHAR[255],
	CONTRAINT loc_pk PRIMARY KEY (language, country)
);

CREATE TABLE version_has_loc_doc (
	package_id INT,
	version_no INT,
	loc_country CHAR[255],
	loc_language CHAR[255],
	file_id	INT,
	CONSTRAINT vhld_pk PRIMARY KEY (verison_no, package_id, loc_country, loc_language),
	CONSTRAINT vhld_loc_fk FOREIGN KEY(loc_country, loc_language) REFFERENCES localisation(loc_country, loc_language),
	CONSTRAINT vhld_version_fk FOREIGN KEY(version_no) REFERENCES version(version_no),
	CONSTRAINT vhld_package_fk FOREIGN KEY(package_id) REFERENCES package(package_id)
);

CREATE TABLE vendor (
	package_id INT,
	name CHAR[255],
	website CHAR[255],
	CONSTRAINT ven_pk PRIMARY KEY (name, website, package_id)
	CONSTRAINT ven_fk FOREIGN KEY (package_id) REFERENCES package(package_id)
);

CREATE TABLE category (
	category_id INT,
	package_id INT,
	name CHAR[255].
	CONSTRAINT cat_pk PRIMARY KEY (category_id, package_id)
	CONSTRAINT cat_fk FOREIGN KEY (package_id) REFERENCES package(package_id)
);

CREATE TABLE repository (
	repo_name CHAR[255],
	public_key CHAR[255],
	mirror_url CHAR[255],
	package_id CHAR[255],
	CONSTRAINT repo_pk PRIMARY KEY (repo_name, public_key, package_id),
	CONSTRAINT repo_fk FOREIGN KEY (package_id) REFERENCES package(package_id)
);

CREATE TABLE mirror (
	mirror_url CHAR[255],
	repo_name CHAR[255],
	public_key CHAR[255],
	mirror_country CHAR[255],
	mirror_city CHAR[255],
	throughput INT,
	CONSTRAINT m_pk PRIMARY KEY (mirror_url, repo_name, public_key)
	CONSTRAINT m_fk FOREIGN KEY (repo_name, public_key) REFERENCES repository(repo_name, public_key)	
);

CREATE TABLE client (
    UserID INT PRIMARY KEY,
    FOREIGN KEY (UserID) REFERENCES User.ID
);

CREATE TABLE developer (
    UserID INT PRIMARY KEY,
    FOREIGN KEY (UserID) REFERENCES User.ID
);

CREATE TABLE open_source (
    package_id INT PRIMARY KEY,
    license VARCHAR(50) NOT NULL,
    FOREIGN KEY (package_id) REFERENCES package(id)
);

CREATE TABLE proprietary (
    package_id INT PRIMARY KEY,
    license VARCHAR(50) NOT NULL,
    price int NOT NULL,
    FOREIGN KEY (package_id) REFERENCES package(id)
);

CREATE TABLE provider (
    id INT,
    mirror_url VARCHAR(255),
    name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id, mirror_url), 
    FOREIGN KEY (mirror_url) REFERENCES mirror(url)
);

CREATE TABLE user_replies_to_issue (
    user_id INT,
    issue_id INT,
    PRIMARY KEY (user_id, issue_id, reply_date),
    FOREIGN KEY (user_id) REFERENCES `user`(id),
    FOREIGN KEY (issue_id) REFERENCES issue(id)
);

CREATE TABLE user_writes_issue (
    user_id INT,
    issue_id INT,
    PRIMARY KEY (user_id, issue_id),
    FOREIGN KEY (user_id) REFERENCES `user`(id),
    FOREIGN KEY (issue_id) REFERENCES issue(id)
);

CREATE TABLE user_writes_review (
    user_id INT,
    review_id INT,
    PRIMARY KEY (user_id, review_id),
    FOREIGN KEY (user_id) REFERENCES `user`(id),
    FOREIGN KEY (review_id) REFERENCES review(id)
);

CREATE TABLE version_contains_issue (
    version_no VARCHAR(20),
    issue_id INT,
    PRIMARY KEY (version_no, issue_id),
    FOREIGN KEY (version_no) REFERENCES version(version_no),
    FOREIGN KEY (issue_id) REFERENCES issue(issue_id)
);
