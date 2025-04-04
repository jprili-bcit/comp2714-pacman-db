SELECT open_source.*, package.name FROM open_source
JOIN package ON package.package_id = open_source.package_id;

SELECT review.*, package.name FROM review
JOIN package ON package.package_id = review.package_id
WHERE review.package_id = 1003;


SELECT depends_on.*, package.name
FROM depends_on
    JOIN `package` ON package.package_id = depends_on.host_package_id
WHERE
    host_package_id = 1003;

SELECT bug_report.*, package.name, version.version_no FROM bug_report
JOIN version_contains_issue ON bug_report.issue_id = version_contains_issue.issue_id
JOIN version ON version_contains_issue.version_id = version.version_id
JOIN package ON version.package_id = package.package_id
WHERE package.package_id = 1002
AND bug_report.stack_trace <> '';

SELECT AVG(rating) AS average_rating
FROM review
WHERE
    package_id = 1002;

SELECT * FROM package
WHERE package_id NOT IN( SELECT host_package_id FROM depends_on );