# s3-log

## Use an S3 bucket to log traffic to an arbitrary webpage

The concept uses two buckets: one stores the logs, and the other stores a
publicly accessible tracking pixel and has Amazon S3’s built-in access logging
enabled. (Storing logs on the bucket being logged results in a vicious cycle, as
the logging itself accesses the bucket, generating more logs.)

The actual referrer is stored in the query of the tracking pixel request
(presumably placed there by JavaScript using the `document.referrer` API). The
HTTP `Referer` header (which is logged by S3) is the URL of the page being
tracked.

Thus, the `unsafe-url` referrer policy should be used when fetching the tracking
pixel, to ensure the full URL of the page is included in the `Referer` header.
While such a policy can be a security risk, the tracking pixel is requested over
HTTPS, mitigating most concerns. (Although S3 doesn’t support static web hosting
over HTTPS, the tracking pixel can be retrieved over HTTPS from a regular
bucket, without static web hosting enabled).

Of course, the tracking pixel should be fetched over the network every time. The
included sample JavaScript ensures that using `cache: 'no-store'` in the `fetch`
options.

`getLogs.ts` is a Deno module that retrieves the access logs (they use an ad-hoc
text format), cleans them up, and writes a stream of JSON objects (one for each
significant access) to a local logfile. The remote access logs are deleted by
default after processing. The script also maintains a local cache of geolocation
data for each IP address that occurs in the logs (using the lovely and free
https://seeip.org).

`log.js` can be referenced from a `<script>` tag on any page to enable logging
access to that page.

***Work in progress\!***
