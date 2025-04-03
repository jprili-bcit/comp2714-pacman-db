-- Insert Users
INSERT INTO `user` (user_id, name, email) VALUES
(1, 'Alice Johnson', 'alice@example.com'),
(2, 'Bob Smith', 'bob@example.com'),
(3, 'Charlie Brown', 'charlie@example.com');

-- Insert Categories
INSERT INTO `category` (category_id, name) VALUES
(101, 'Development Tools'),
(102, 'Security'),
(103, 'Database');

-- Insert Packages
INSERT INTO `package` (package_id, category_id) VALUES
(1001, 101),
(1002, 102),
(1003, 103);

-- Insert Clients
INSERT INTO `client` (user_id) VALUES
(1),
(2);

-- Insert Developers
INSERT INTO `developer` (user_id) VALUES
(3);

-- Insert Open Source Packages
INSERT INTO `open_source` (package_id, license) VALUES
(1001, 'MIT'),
(1003, 'Apache-2.0');

-- Insert Proprietary Packages
INSERT INTO `proprietary` (package_id, license, price) VALUES
(1002, 'Commercial', 299);

-- Insert Providers
INSERT INTO `provider` (provider_id, name) VALUES
(501, 'CloudHost Inc.'),
(502, 'SecureData Corp.');

-- Insert Repositories
INSERT INTO `repository` (repository_id, repo_name, public_key, package_id) VALUES
(201, 'DevToolsRepo', 'pubkey123', 1001),
(202, 'SecureRepo', 'pubkey456', 1002);

-- Insert Mirrors
INSERT INTO `mirror` (mirror_url, repository_id, mirror_country, mirror_city, throughput) VALUES
('http://mirror1.example.com', 201, 'USA', 'New York', 1000),
('http://mirror2.example.com', 202, 'Germany', 'Berlin', 2000);

-- Insert Reviews
INSERT INTO `review` (review_id, package_id, user_id, rating, description, timestamp) VALUES
(301, 1001, 1, 5, 'Excellent tool!', '2023-10-01 10:00:00'),
(302, 1002, 2, 4, 'Good but pricey', '2023-10-02 11:00:00');

-- Insert Issues
INSERT INTO `issue` (issue_id, user_id, timestamp, issue_type) VALUES
(401, 1, '2023-10-03 12:00:00', 'bug_report'),
(402, 3, '2023-10-04 13:00:00', 'feature_request');

-- Insert Feature Requests
INSERT INTO `feature_request` (issue_id) VALUES
(402);

-- Insert Bug Reports
INSERT INTO `bug_report` (issue_id, stack_trace) VALUES
(401, 'NullPointerException at line 45');

-- Insert Replies to Issues
INSERT INTO `replies_to` (reply_id, user_id, issue_id, content, timestamp) VALUES
(501, 3, 401, 'We are investigating this.', '2023-10-03 14:00:00'),
(502, 1, 402, 'Great suggestion!', '2023-10-04 15:00:00');

-- Insert Versions
INSERT INTO `version` (version_id, package_id, version_no, architecture, platform, date) VALUES
(601, 1001, 1, 'x86_64', 'gnu-linux', '2023-09-01'),
(602, 1002, 2, 'aarch64', 'windows-nt', '2023-09-15');

-- Link Packages to Versions
INSERT INTO `package_has_version` (package_id, version_id) VALUES
(1001, 601),
(1002, 602);

-- Insert Dependencies
INSERT INTO `depends_on` (host_package_id, dependency_id, mandatory) VALUES
(1001, 1002, TRUE);

-- Link Versions to Issues
INSERT INTO `version_contains_issue` (version_id, issue_id) VALUES
(601, 401);

-- Insert Vendors
INSERT INTO vendor (vendor_id, name, website) VALUES
(701, 'TechVendor Corp', 'https://techvendor.com'),
(702, 'SecureSoft Ltd', 'https://securesoft.net');

-- Link Vendors to Packages
INSERT INTO vendor_owns_package (vendor_id, package_id) VALUES
(701, 1001),
(702, 1002);

-- Link Developers to Packages
INSERT INTO developer_works_on_package (user_id, package_id) VALUES
(3, 1001),  -- Charlie works on DevTools
(3, 1002);  -- Charlie also works on Security pkg

-- Link Packages to Reviews
INSERT INTO package_has_review (package_id, review_id) VALUES
(1001, 301),  -- DevTools has review 301
(1002, 302);  -- Security pkg has review 302

-- Link Repositories to Mirrors
INSERT INTO repository_serves_mirror (repository_id, mirror_url) VALUES
(201, 'http://mirror1.example.com'),
(202, 'http://mirror2.example.com');

-- Documentation Authors
INSERT INTO docu_author (author_id, name) VALUES
(801, 'David Techwriter'),
(802, 'Emma Docspecialist');

-- Documentation Entries (with author links)
INSERT INTO documentation (doc_id, language, country, content, author_id) VALUES
(901, 'EN', 'US', 'Installation Guide for DevTools', 801),
(902, 'DE', 'DE', 'Sicherheitshandbuch', 802);

-- Update Authors with Doc References
UPDATE docu_author SET doc_id = 901 WHERE author_id = 801;
UPDATE docu_author SET doc_id = 902 WHERE author_id = 802;

-- Localizations
INSERT INTO localisation (loc_id, language, country) VALUES
(1001, 'EN', 'US'),
(1002, 'DE', 'DE');

-- Link Versions to Localized Docs
INSERT INTO version_has_loc_doc (version_id, loc_id) VALUES
(601, 1001),  -- Version 601 has EN-US docs
(602, 1002);  -- Version 602 has DE-DE docs

-- User Replies to Issues
INSERT INTO user_replies_to_issue (user_id, issue_id, reply_timestamp) VALUES
(3, 401, '2023-10-03 14:30:00'),  -- Charlie replies to bug 401
(1, 402, '2023-10-04 15:15:00');   -- Alice replies to feature 402

-- Link Providers to Mirrors
INSERT INTO provider_hosts_mirror (provider_id, mirror_url) VALUES
(501, 'http://mirror1.example.com'),  -- CloudHost hosts mirror1
(502, 'http://mirror2.example.com');  -- SecureData hosts mirror2
