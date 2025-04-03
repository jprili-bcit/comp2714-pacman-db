USE pacman_db;

-- Users
INSERT INTO `user` (user_id, name, email) VALUES
(1, 'Alice Johnson', 'alice.j@example.com'),
(2, 'Bob Wilson', 'bob.w@example.com'),
(3, 'Charlie Chen', 'charlie.c@example.com'),
(4, 'Diana Miller', 'diana.m@example.com');

-- Categories
INSERT INTO category (category_id, name) VALUES
(101, 'Development Tools'),
(102, 'Security Solutions'),
(103, 'Database Systems'),
(104, 'Networking');

-- Packages
INSERT INTO package (package_id, category_id) VALUES
(1001, 101),  -- DevToolKit
(1002, 102),  -- SecureShield
(1003, 103),   -- DataMaster
(1004, 104);  -- NetOptimizer

-- Clients
INSERT INTO client (user_id) VALUES
(1), (2);

-- Developers
INSERT INTO developer (user_id) VALUES
(3), (4);

-- Package Types
INSERT INTO open_source (package_id, license) VALUES
(1001, 'GPL-3.0'),
(1003, 'Apache-2.0');

INSERT INTO proprietary (package_id, license, price) VALUES
(1002, 'Commercial', 499),
(1004, 'Enterprise', 899);

-- Providers
INSERT INTO provider (provider_id, name) VALUES
(501, 'CloudTech Inc.'),
(502, 'SafeHost Solutions');

-- Repositories
INSERT INTO repository (repository_id, repo_name, public_key, package_id) VALUES
(201, 'devtools-repo', 'pubkey-abc123', 1001),
(202, 'security-repo', 'pubkey-def456', 1002),
(203, 'database-repo', 'pubkey-ghi789', 1003);

-- Mirrors
INSERT INTO mirror (mirror_url, repository_id, mirror_country, mirror_city, throughput) VALUES
('https://mirror1.cloudtech.com', 201, 'USA', 'New York', 1000),
('https://mirror2.cloudtech.com', 202, 'Germany', 'Frankfurt', 1500),
('https://mirror3.safehost.net', 203, 'Singapore', 'Singapore', 2000);

-- Provider-Mirror Relationships
INSERT INTO provider_hosts_mirror (provider_id, mirror_url) VALUES
(501, 'https://mirror1.cloudtech.com'),
(501, 'https://mirror2.cloudtech.com'),
(502, 'https://mirror3.safehost.net');

-- Reviews
INSERT INTO review (review_id, package_id, user_id, rating, description, timestamp) VALUES
(301, 1001, 1, 5, 'Essential for modern development', '2023-10-01 09:00:00'),
(302, 1002, 2, 4, 'Robust security features', '2023-10-02 10:30:00'),
(303, 1003, 3, 5, 'Best database solution', '2023-10-03 11:45:00');

-- Issues
INSERT INTO issue (issue_id, user_id, timestamp, issue_type) VALUES
(401, 1, '2023-10-05 14:00:00', 'bug_report'),
(402, 3, '2023-10-06 15:30:00', 'feature_request'),
(403, 2, '2023-10-07 16:45:00', 'bug_report');

-- Feature Requests
INSERT INTO feature_request (issue_id) VALUES
(402);

-- Bug Reports
INSERT INTO bug_report (issue_id, stack_trace) VALUES
(401, 'NullPointerException at line 87:FileProcessor.java'),
(403, 'Memory leak detected in cache module');

-- Replies
INSERT INTO replies_to (reply_id, user_id, issue_id, content, timestamp) VALUES
(501, 3, 401, 'Fix scheduled for next patch', '2023-10-05 14:30:00'),
(502, 4, 402, 'Feature added to roadmap', '2023-10-06 16:00:00'),
(503, 3, 403, 'Investigating memory issues', '2023-10-07 17:00:00');

-- Versions
INSERT INTO version (version_id, package_id, version_no, architecture, platform, date) VALUES
(601, 1001, 1, 'x86_64', 'gnu-linux', '2023-09-15'),
(602, 1002, 2, 'aarch64', 'windows-nt', '2023-09-20'),
(603, 1003, 1, 'x86_64', 'osx-darwin', '2023-09-25');

-- Package-Version Relationships
INSERT INTO package_has_version (package_id, version_id) VALUES
(1001, 601),
(1002, 602),
(1003, 603);

-- Dependencies
INSERT INTO depends_on (host_package_id, dependency_id, mandatory) VALUES
(1001, 1002, TRUE),   -- DevToolKit requires SecureShield
(1003, 1001, FALSE);  -- DataMaster optionally uses DevToolKit

-- Version-Issue Relationships
INSERT INTO version_contains_issue (version_id, issue_id) VALUES
(601, 401),  -- Version 1 of DevToolKit has issue 401
(602, 403);  -- Version 2 of SecureShield has issue 403
