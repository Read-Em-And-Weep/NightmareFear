# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.13] - 2026-04-25

- Expiring boons will still expire, even if you remove the Vow of Expiry
- Fixed bad interaction with Pony Altar
- Ephyra Zoom Out should no longer reveal secrets hidden from Melinoe's eyes
- Gods should stop trying to kill you more reliably after the battle ends with Vow of Betrayal on (hopefully)

## [1.2.12] - 2026-04-19

- README updated to reflect gemstone gain change

## [1.2.11] - 2026-04-19

- Increased gemstone gain from completing random Testaments from 90 -> 120, so that it's more advantageous to do the testament than just use Grave Thirst
- Added a new screen that opens the first time you are offered a random Testament, explaining how the system works

## [1.2.10] - 2026-04-18

- The random Testament system should now actually work :) Hopefully

## [1.2.9] - 2026-04-18

- Increased gemstone gain from completing random testaments from 50 -> 90

## [1.2.8] - 2026-04-17

- Athena's keepsake (Gorgon Amulet) will no longer activate when the Vow of Isolation is active
- Selene's (Moon Beam) and Athena's (Gorgon Amulet) keepsakes will be blocked in the keepsake rank when swearing the Vows of Eclipse and Isolation respectively

## [1.2.7] - 2026-04-15

- Fixed a potential nil call bug

## [1.2.6] - 2026-04-15

- Updated to work in the newest Post-Release Patch 2!
- Updated a weird interaction in creating the testament screen where it could index nil in a table

## [1.2.5] - 2026-04-07

- Updated how Secrets is handled, for future compatibility with Zagreus Journey (thanks NikkelM!) 

## [1.2.4] - 2026-04-06

- Updated hotkey for changing page for controller compatibility

## [1.2.3] - 2026-04-05

- Changed order that purging and expiry executed, so that it is more logically consistent
- Changed wait for expiry boons to expire after defeating a guardian

## [1.2.2] - 2026-04-05

- Fixed an issue where you could be killed by devotion weapons with the Vow of Betrayal while the results screen was open (betrayal never comes when you expect it)

## [1.2.1] - 2026-04-05

- Expanded testament fear ranks, so they can spawn slightly higher now

## [1.2.0] - 2026-04-05

- Updated testament system so that it requires a random collection of 1-4 vows at random ranks, as well as overall fear. Hopefully this should encourage you to try some combinations you haven't before!
- Bounds on overall fear for testaments slightly altered

## [1.1.1] - 2026-04-05

- Fixed an issue that resulted in you also receiving less major finds while using the Vow of Naivety
- Slightly altered the bounds on the distribution of random fear for testaments

## [1.1.0] - 2026-04-04

### Added

- New random testament system! Once you've cleared every testament, random testaments will be generated to encourage you to try different set-ups!
- Updated ReadMe, to increase readibility

## [1.0.2] - 2026-04-04

- Updated the purge function, so it should hopefully work slightly better
- Updated how the hammer and Selene rewards are restricted to provide a more smooth experience
- Updated Readme to explain compatibility
- Added functionality for random fear Chaos Trials to contain these vows

## [1.0.1] - 2026-04-04

- Fixed description of mod

## [1.0.0] - 2026-04-04

### Added

- First version of the mod!

[unreleased]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/1.2.13...HEAD
[1.2.13]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/1.2.12...1.2.13
[1.2.12]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/1.2.11...1.2.12
[1.2.11]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/1.2.10...1.2.11
[1.2.10]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/1.2.9...1.2.10
[1.2.9]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/1.2.8...1.2.9
[1.2.8]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/1.2.7...1.2.8
[1.2.7]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/1.2.6...1.2.7
[1.2.6]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/1.2.5...1.2.6
[1.2.5]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/1.2.4...1.2.5
[1.2.4]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/1.2.3...1.2.4
[1.2.3]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/1.2.2...1.2.3
[1.2.2]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/1.2.1...1.2.2
[1.2.1]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/1.2.0...1.2.1
[1.2.0]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/1.1.1...1.2.0
[1.1.1]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/1.0.2...1.1.0
[1.0.2]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/1.0.1...1.0.2
[1.0.1]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/Read-Em-And-Weep/NightmareFear/compare/b47f45d2cd94df8ead4f8025f6be6480171a08b0...1.0.0
