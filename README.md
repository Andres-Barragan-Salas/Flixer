# Project 2 - *Flixer*

**Flixer** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **21** hours spent in total

## User Stories

The following **required** functionality is complete:

- [x] User sees an app icon on the home screen and a styled launch screen.
- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.
- [x] User sees an error message when there's a networking error.
- [x] User can tap a tab bar button to view a grid layout of Movie Posters using a CollectionView.

The following **optional** features are implemented:

- [x] User can tap a poster in the collection view to see a detail screen of that movie
- [x] User can search for a movie.
- [x] All images fade in as they are loading.
- [ ] User can view the large movie poster by tapping on a cell.
- [ ] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [x] Customize the selection effect of the cell.
- [x] Customize the navigation bar.
- [x] Customize the UI.

The following **additional** features are implemented:

- [x] Details view displays the release date and vote average (with conditional color) of the movie.
- [x] User is presented with the trailer (YouTube) when tapping on the backdrop from the details view.
- [x] The grid view can display different sets of movies depending on the selected category (selected from a "settings view").

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Implementing the search bar inside the collection view.
2. Using Web View/WebKit View properly.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://g.recordit.co/gDzPvRv9Ez.gif' title='Video1' width='' alt='Video1' />
<img src='http://g.recordit.co/LCpItkTga7.gif' title='Video2' width='' alt='Video2' />
<img src='http://g.recordit.co/mz656BXTsq.gif' title='Video3' width='' alt='Video3' />
<img src='http://g.recordit.co/G0Q0NLjQVF.gif' title='Video4' width='' alt='Video4' />
<img src='http://g.recordit.co/vga7D9dVu8.gif' title='Video5' width='' alt='Video5' />

GIF created with [LiceCap](https://recordit.co/).

## Notes

At times XCode doesn't detect the custom class set for a View Controller, restaring XCode seems to work so far. For some reason trying to load a low resolution image before the complete one was resulting in not loading either. "stringByAppendingString" method throws an error (*"unrecognised selector sent to instance"*) at times which "stringWithFormat" doesn't. 

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library

## License

    Copyright [2020] [Andres Barragan]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
