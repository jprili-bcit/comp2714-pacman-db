
CREATE TABLE documentation{
	language CHAR[255],
	country CHAR[255],
	author_id INT,
	CONSTRAINT doc_pk PRIMARY KEY (language, country),
	CONSTRAINT doc_fk FOREIGN KEY (author_id) REFERENCES docu_author(author_id)
}

CREATE TABLE docu_author{
	author_id INT,
	name CHAR[255],
	language CHAR[255],
	country CHAR[255],
	CONSTRAINT da_pk PRIMARY KEY(author_id)
	CONSTRAINT da_fk FOREIGN KEY(language, country) REFERENCES documentation(language, country)
}

CREATE TABLE author_writes_doc{
	file_id INT,
	author_id INT,
	CONTRAINT awd_pk PRIMARY KEY (file_id, author_id),
	CONTRAINT awd_fk FOREIGN KEY (author_id) REFERENCES docu_author(author_id)
}

CREATE TABLE localisation {
	language CHAR[255],
	country CHAR[255],
	CONTRAINT loc_pk PRIMARY KEY (language, country)
}

CREATE TABLE version_has_loc_doc{
	package_id INT,
	version_no INT,
	loc_country CHAR[255],
	loc_language CHAR[255],
	file_id	INT,
	CONSTRAINT vhld_pk PRIMARY KEY (verison_no, package_id, loc_country, loc_language),
	CONSTRAINT vhld_loc_fk FOREIGN KEY(loc_country, loc_language) REFFERENCES localisation(loc_country, loc_language),
	CONSTRAINT vhld_version_fk FOREIGN KEY(version_no) REFERENCES version(version_no),
	CONSTRAINT vhld_package_fk FOREIGN KEY(package_id) REFERENCES package(package_id)
}

CREATE TABLE vendor{
	package_id INT,
	name CHAR[255],
	website CHAR[255],
	CONSTRAINT ven_pk PRIMARY KEY (name, website, package_id)
	CONSTRAINT ven_fk FOREIGN KEY (package_id) REFERENCES package(package_id)
}

CREATE TABLE category{
	category_id INT,
	package_id INT,
	name CHAR[255].
	CONSTRAINT cat_pk PRIMARY KEY (category_id, package_id)
	CONSTRAINT cat_fk FOREIGN KEY (package_id) REFERENCES package(package_id)
}

CREATE TABLE repository{
	repo_name CHAR[255],
	public_key CHAR[255],
	mirror_url CHAR[255],
	package_id CHAR[255],
	CONSTRAINT repo_pk PRIMARY KEY (repo_name, public_key, package_id),
	CONSTRAINT repo_fk FOREIGN KEY (package_id) REFERENCES package(package_id)
}

CREATE TABLE mirror{
	mirror_url CHAR[255],
	repo_name CHAR[255],
	public_key CHAR[255],
	mirror_country CHAR[255],
	mirror_city CHAR[255],
	throughput INT,
	CONSTRAINT m_pk PRIMARY KEY (mirror_url, repo_name, public_key)
	CONSTRAINT m_fk FOREIGN KEY (repo_name, public_key) REFERENCES repository(repo_name, public_key)	
}