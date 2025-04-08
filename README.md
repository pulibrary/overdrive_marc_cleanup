# overdrive_marc_cleanup
This repository will automate task to clean up overdrive marc records. 
1. When user gets an email from overdrive
2. User saves the attachements to a folder 
3. User calls OverdriveCleaner.clean(/path/to/folder)
4. Script makes a new file in folder called clean_records.mrc
5. User can upload clean_records.mrc into ALMA

## Development

### Setup
* See .tool-versions for language version requirements (ruby)

`asdf install`
`bundle install`

### Run tests

`bundle exec rspec`