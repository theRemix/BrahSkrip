BrahSkrip
=========

### Pidgin Script  
(these may all change at any time, k)  
depends on haxe, hxcpp, gcc, mktemp, and node (for now)  

compiles through gcc, via haxe  
  **brah main**  

transpiles through haxe to javascript  
  **brah main laddat**  

runs immediately through node  
  **brah main now**  

### Sampo Scrip  

````
da name stay jon k
da age steh 31 k

sampo dakine is dakine years old
````
result
````
jon is 31 years old
````

````
da ting stay 3 k

ting stay 2 ya?
  sampo "ting stay " 2
nah ting stay 3 ya?
  sampo "ting stay " 3
nah
  sampo "ting no stay 2 or 3"
k

````
result
````
ting stay 3
````

### Compiler

To build - **haxe build.hxml**  
To test - **haxe test.hxml**  

or  

**make**  
**make test**  
**make install**  

Optional strick mode.
  **brah strick main laddat**  
