# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [1.2.0] - 2015-09-19
### Added
- Add `libpixel_image_tag` Rails view helper.
- Add `https` option to `LibPixel::Client.url`.
- Set host automatically in clients from `LIBPIXEL_HOST` env var.
- Set secret automatically in clients from `LIBPIXEL_SECRET` env var.

### Changed
- `LibPixel::Client.url` raises an exception if host is undefined.
- `LibPixel::Client.sign` raises an exception if secret is undefined.

## [1.1.0] - 2015-08-12
### Changed
- Make path optional in LibPixel::Client#url [@matiaskorhonen](https://github.com/matiaskorhonen).

## [1.0.1] - 2015-08-11
### Fixed
- Set path default value to "/" in LibPixel::Client#url.

## [1.0.0] - 2015-08-11
### Added
- Initial release.
