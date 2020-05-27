# flutter_demo_movies

https:&#x2F;&#x2F;dribbble.com&#x2F;shots&#x2F;3982621-InVision-Studio-Movies-app-concept

![demo](https://github.com/fdoyle/flutter_demo_movies/blob/master/movies.gif)

NB: I'm mostly happy with the result, but I also have a hunch there might be a more idiomatic way to do this. It seems like you should be able to do something like this with slivers or pageview transforms, but the more I read the docs on both, the more it felt like I'd be better off doing it with more "fundamental" widgets. 

I've fixed the issue where child gesturedetectors were ignored. Should work as expected now. If you think it would be helpful to have the PagerGestureDetector as a standalone library or something, let me know, I'll look into it. 
