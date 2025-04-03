use pacman_db;

-- PACKAGE[PackageID, CategoryID, name, description, website]
CREATE TABLE `package` (
    package_id INT NOT NULL,
    category_id INT NOT NULL,
    `name` TEXT NOT NULL,
    `description` LONGTEXT NOT NULL,
    `website` TEXT NOT NULL,
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
