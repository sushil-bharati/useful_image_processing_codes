Compiler produces `translational unit -> object file` for every source files.  
It is a good idea to set the compiler to optimize.  
Linker links all the object files into one executable.  
There are two types of linking -> `static` and `dynamic`.  

Variables are stored in `stack` or `heap` memory.  

`unsigned int` helps to release a bit that would otherwise store a sign for storage.   

When it comes to accessing a memory, we cannot access 1 bit but only in byte(s). This largely explains why `bool` are 1 byte long though the requirement is 1 bit (0/1).  

Build a habit of using `#pragma once` in the top of all of the header files.  

References are just aliases.  
```
int a = 2, b = 3;
int& ref = a; // does NOT create an extra var ref
ref = b; // think of this as a = b
std::cout << a; // will print 3
```
Similarly,  
```
void incr (int& a) // copies address ONLY
{
  a++;
}
```

There is not much difference between `Class` and `struct` except for all the members in `Class` are private by default whereas all the members in `struct` are public by default. One of the reasons we might have `struct` in C++ is to retain backward compatibility with C.  

`static` properties or methods are shared across all the instances of the Class. `static` methods cannot access non-static properties. Think of `static` methods as if they are written outside the class and similarly for static variables. Hence, they do not have an access to class object because `static` methods are accessed without an object.  

```
class Grade
{
  enum GradeVals : char
  {
    FAIL = 0, PASS
  };  
};
std::cout << Grade::PASS ; // prints 1, notice we don't need to refer 'GradeVals'
```

Destructor of a class applies to both heap and stack based objects. If you call a `delete` on any `new` object, the destructor gets called. Also, if an object in stack goes out of scope, destructor gets called.

Virtual functions help you override the methods in inherited classes **safely**.
Runtime costs : (a) Memory requirements to store vtable and (b) access vtable everytime virtual function is called.
```
class Parent
{
  public:
    int memberVar_ = 2;
    virtual int IncMemberVar() { return ++memberVar_; }
};
class Child : public Parent
{
  int IncMemberVar() override { return memberVar_+2; }
};
```

Pure virtual functions helps to build interfaces in C++. It basically allows to define a function in base/parent class and enforce child class to implement the behavior of the function.
```
class Parent
{
  public:
    virtual int GetMemberVar() = 0; // pure virtual function
}
class Child : public Parent
{
  private:
    int memberVar_ = 2;
  public:
    int GetMemberVar() override {return memberVar_;} // must be implemented
}
```

Oneliner to find a substring in a string.  
`bool contains = str.find(substr) != std::string::npos;`

Make a habit of passing a string in a function using `const` reference unless you need to modify.
`void passingString(const std::string& strToPass) {}`

const usage depends on where it occurs.
```
const double B_CONST = 12.0;
double* a = new double;
*a = 3.0; // ok to change the content of the var the pointer is pointing to
a = (double*)&B_CONST; // ok to change the memory address the pointer is pointing top but do not do this because B_CONST is a const

const double* b = new double;
*b = 3.0; // error, cannot change the content of the var the pointer is pointing to
b = (double*)&B_CONST; // ok to change where it points

double* const c = new double;
*c = 3.0; // ok, can change the content of the var the pointer is pointing to
c = (double*)&B_CONST; // error, cannot reassign the pointer to point to sth else

int const* c = new double; // same as const int* c = new double;

const int* const c; // cannot change the content nor the address
```

Make a habit of declaring getter methods in a class using `const`
```  int getter() const {return m_Var;} ```
```
If a member variables are pointers,
``` const int* const getter() const {return m_PtrVar; } ```
```
```
class Example
{
  public:
    int m_Var;
    int getter() {return m_Var}
}

int runGetter (const Example& ex) {return ex.getter();} // this will throw error
```
The above example will throw error because by declaring `const Example& ex`, we have declared `ex` to be a const ref type and thus `ex` should be guaranteed to access a function which promises no changes. Since `getter()` in `Example` class is not a const function, `getter()` might change `m_var` which is not acceptable for a const reference type. Thus, if one defines getter function as `int getter() const {return m_var;}`, the above code will not thrown any error.

If you need to change a variable inside a const method, use `mutable`.
```
class Example
{
  public:
    mutable int m_A = 2; // allows to be modified inside const methods
    void func() const {m_A++;}
}
```

Pass by value variables inside a lambda function is **not** mutable.
Usage of `mutable` in `lambda`
```
int var = 1;
auto f = [=]() mutable {var++;} // = pass by value, & pass by reference
```
By defining `mutable`, we are letting the lambda function catch var and change inside the function without the need to create a new variable and copying `var` into it. Otherwise, you may pass by reference. Note, when passed by value, `var` is not changed outside the lambda function.

Make a habit of using *member initializer list* in a constructor.

Allocation in heap takes longer than that in stack. Also, you will need to manually delete vars in heap.

 Implicit conversions and explicit keyword
 ```
 class Example
 {
   int m_Var;
   std::string m_Str;

   public:
    Example (const int var) : m_Var(var) {}
    explicit Example (const std::string& str) : m_Str(str) {} //explicit constructor
 };
 void ExternalFunction(const Example& e)
 {
   // body
 }
Example e1(2); // works
Example e2("This is a string"); // works
Example e3 = 2; // this also works due to implicit conversion
Example e4 = "This is a string"; // throws error because constructor is marked explicit
ExternalFunction(2); // works - same as e1 or e3
ExternalFunction("hello"); // throws error because "hello" is a const char array
ExternalFunction(std::string("hello")); // throws error but will work if not marked explicit
```

Operator overloading
```
#include <iostream>

class OperatorOverload
{
    public:
    double m_X, m_Y;
    OperatorOverload(const double x, const double y) : m_X(x), m_Y(y) {}
    OperatorOverload& operator+(const OperatorOverload& other)
    {
      m_X += other.m_X;
      m_Y += other.m_Y;
      return *this;
    }
    bool operator==(const OperatorOverload& other) const
    {
      return m_X == other.m_X && m_Y == other.m_Y;
    }
    bool operator!=(const OperatorOverload& other) const
    {
      return !(*this==other);
    }
};
std::ostream& operator<<(std::ostream& str, const OperatorOverload& obj)
{
    str << obj.m_X << ", " << obj.m_Y;
    return str;
}
int main()
{
    OperatorOverload obj(1.0, 2.0);
    OperatorOverload obj2(3.0, -1.0);
    std::cout << obj + obj2 << std::endl; // 4.0, 1.0
    std::cout << (obj==obj2); // 0
    std::cout << (obj2!=obj1); // 1
}
```
