## REAL LIFE PROBLEM

To resolve this assignment, I have a solution below

- Generate unique codes via `ShortLinkService` before and store theme to `available_codes` table
- Whenever we want to shorten a long URL, we will take one of generated codes from `available_codes` table and use it.

Improvement

- Should have a worker/cron to generate new codes when `available_codes` table is empty
- Should have a worker/cron to remove expired shortener URL
- Apply soft-delete on `available_codes` table to reuse removed codes
- Implement authentication and authorization

Potential attack vectors

- Injection attacks
  - Implement input validation and sanitize user inputs to prevent injection attacks.
- DoS Attacks
  - Implement throttling and rate limiting on the API to mitigate the impact of DoS attacks.
- Parameter Tampering
  - Validate and sanitize parameters to prevent tampering with input data.

Scale up and solve the collision problem. 

- Move generate unique codes service to a standalone service and use NoSQL to store data
- Database Partition and Replication
  - Tuning performance for query to databases.
  - Apply master-slave architecture
  - Database sharding
- Caching with Redis or CDN
- Apply load balancer and auto-scaling of Web Server, DB Server and Caching Server
- DB clean up
  - Have a cronjob to remove expired URLs
  - Reuse unique code after removing expired URLS