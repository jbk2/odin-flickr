# README

This is a The Odin Project, RoR curriculum, project on building a Rails app which authenticated and interacts with the Flickr API.

### Features

- Uses Omniauth (via Omniauth-flickr gem) and Devise to authenticate user identity via Flickr
- Devise authenticates using Username not Email.
- FlickrService service class in app/services/ handles:
  - creating an Oauth consumer and access token
  - building and calling endpoint URL with params 
- StaticPages#home very simply has two buttons calling two Flickr endpoints:
  - flickr.people.getPhotos
  - flickr.contacts.getList

### Issues
- There seems to be a critical issue with API availability with only ~25% of Flickr API endpoint calls succeeding
  - issue on both endpoints
  - debugged and rewritten our code many times, nothing wrong with our auth or our endpoint calling code, JS/Turbo not interfering, just irregular responses with no seeming pattern from the Flickr API. Accordingly we're discontinuting this project to work and learning from using other more stable APIs.