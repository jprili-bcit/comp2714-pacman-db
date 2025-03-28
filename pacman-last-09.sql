use pacman_db;

-- PACKAGE_HAS_VERSION

CREATE TABLE package_has_version (
    package_id INT,
    version_no INT,  
    CONSTRAINT phv_pk PRIMARY KEY (package_id, version_no),
    CONSTRAINT phv_fk FOREIGN KEY (package_id) 
        REFERENCES package(package_id)
);

-- DEPENDS_ON

CREATE TABLE depends_on (
    host_package_id INT,
    dependency_id   INT,
    mandatory       BOOLEAN DEFAULT TRUE,
    CONSTRAINT do_pk PRIMARY KEY (host_package_id, dependency_id),
    CONSTRAINT do_fk FOREIGN KEY (host_package_id, dependency_id)
        REFERENCES package(package_id)
);

-- VENDOR_OWNS_PACKAGE

CREATE TABLE vendor_owns_package (
    vendor_website VARCHAR(256),
    vendor_name    VARCHAR(256),
    package_id     INT,
    CONSTRAINT vop_pk PRIMARY KEY (vendor_website),
    CONSTRAINT vop_fk FOREIGN KEY (package_id)
        REFERENCES (package.package_id)
);

-- DEVELOPER_WORKS_ON_PACKAGE

CREATE TABLE developer_works_on_package (
    user_id    INT,
    package_id INT
    CONSTRAINT dwop_pk PRIMARY KEY (user_id, package_id),
    CONSTRAINT dwop_u_id_fk FOREIGN KEY (user_id)
        REFERENCES `user`(user_id),
    CONSTRAINT dwop_p_id_fk FOREIGN KEY (package_id)
        REFERENCES package(package_id)
);

-- PACKAGE_HAS_REVIEW

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

-- PACKAGE_BELONGS_TO_CATEGORY

CREATE TABLE package_belongs_to_category (
    package_id  INT,
    category_id INT,
    CONSTRAINT pbtc_pk PRIMARY KEY (package_id, category_id),
    CONSTRAINT pbtc_p_id_fk FOREIGN KEY (package_id)
        REFERENCES package(package_id),
    CONSTRAINT pbtc_c_id_fk FOREIGN KEY (package_id)
        REFERENCES category(category_id)
);

-- PACKAGE_PROVIDED_BY_REPOSITORY

CREATE TABLE package_provided_by_repository (
    package_id    INT,
    repository_id INT,
    CONSTRAINT ppbr_pk PRIMARY KEY (package_id),
    CONSTRAINT ppbr_p_id_fk FOREIGN KEY (package_id)
        REFERENCES package(package_id),
    CONSTRAINT ppbr_r_id_fk FOREIGN KEY (repository_id)
        REFERENCES package(repository_id)
);

-- REPOSITORY_SERVES_MIRROR

CREATE TABLE repository_serves_mirror (
    repository_id INT,
    mirror_url    VARCHAR(100),
    CONSTRAINT rsm_pk PRIMARY KEY (repository_id),
    CONSTRAINT rsm_fk FOREIGN KEY (repository_id)
        REFERENCES repository(repository_id)
);

-- PROVIDER_HOSTS_MIRROR 

CREATE TABLE provider_hosts_mirror (
    provider_id INT,
    mirror_url  VARCHAR(100),
    CONSTRAINT phm_pk PRIMARY KEY (provider_id),
    CONSTRAINT phm_fg FOREIGN KEY (provider_id)
        REFERENCES provider(provider_id)
);

