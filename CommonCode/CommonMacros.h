// Useful Macros.
// The best place to import this is in your project's pch file.
// See http://www.cimgf.com/2010/05/02/my-current-prefix-pch-file/ for details.
// Most current version at https://gist.github.com/325926 along with usage notes.

#ifndef jcscommonmacros
#define jcscommonmacros_1_0  10000
#define jcscommonmacros      jcscommonmacros_1_0
#endif

#ifdef DEBUG
  #define DLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
  #define ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
#else
  #define DLog(...) do { } while (0)
  #ifndef NS_BLOCK_ASSERTIONS
    #define NS_BLOCK_ASSERTIONS
  #endif
  #define ALog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#endif
 
#define ZAssert(condition, ...) do { if (!(condition)) { ALog(__VA_ARGS__); }} while(0)

//
// This is a general test for emptiness
// Courtesy of Wil Shipley http://www.wilshipley.com/blog/2005/10/pimp-my-code-interlude-free-code.html

static inline BOOL isEmpty(id thing) {
    return thing == nil
        || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
        || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}