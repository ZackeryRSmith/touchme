> **NOTE**
Touch Me isn't a 1-1 interface and does miss some important functionallity, the hope is to have this added in the future :)

<br />

-----

<div id="user-content-toc" align="center">
  <ul>
    <summary><h1 style="display: inline-block;">Touch Me</h1></summary>
  </ul>
  <p>
	  MacOS Touch ID integration in C/C++
  </p>
</div>

-----

_Touch Me_ leverages [Objective-C](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html) to create a user interface for the [TouchID API](https://developer.apple.com/documentation/localauthentication/accessing_keychain_items_with_face_id_or_touch_id). While _Touch Me_ sacrifices the full power of pure Objective-C by serving as an interface, it gains the advantage of seamless integration with Touch ID functionality.

_Touch Me_ does require you to place an extern somewhere in your project, this allows you to call the Objective C function.
```c
extern int touchId(char *);
// then you may use it like
touchId("your reason for requesting the TouchID");
```

<br />

## A 🌸 𝒞𝓊𝓉𝑒 🌸  note
*Touch Me* **requires**   [Foundation](https://developer.apple.com/documentation/foundation) and [LocalAuthentication](https://developer.apple.com/documentation/localauthentication), if they're not linked Touch Me will not cause compile errors, but it won't prompt the user for their finger.

### to make your life eaiser
You can use Make or CMake to compile your app, many find CMake complex so here is a simple CMake example to use Touch Me on Mac

```cmake
cmake_minimum_required(VERSION 3.12)
project(projectnamehere LANGUAGES C OBJC)

set(SOURCES touchme.m main.c)
add_executable(projectnamehere ${SOURCES})

if(APPLE)
  # find frameworks
  find_library(Foundation Foundation)
  find_library(LocalAuthentication LocalAuthentication)

  # link against the frameworks
  target_link_libraries(${PROJECT_NAME} PRIVATE ${Foundation})
  target_link_libraries(${PROJECT_NAME} PRIVATE ${LocalAuthentication})
endif()
```
