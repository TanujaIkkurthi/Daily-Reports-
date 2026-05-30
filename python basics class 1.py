#!/usr/bin/env python
# coding: utf-8

# #Python vs SQL — what's the difference?
# #SQL is only for talking to databases (querying, inserting, updating data). Python is a full programming language — it can do everything SQL does AND much more.
# 
# 
# 

# In[10]:


# SQL does this:
# SELECT name FROM users WHERE age > 18

# Python does this AND more:
users = [{"name": "Alice", "age": 20}, {"name": "Bob", "age": 16}]
adults = [u["name"] for u in users if u["age"] > 18]
print(adults)


# What is Python?
# Python is a general-purpose programming language. You can build websites, analyze data, automate tasks, make games, and more. It reads almost like plain English.
# 

# In[ ]:


print("Hello, World!")


# DATA TYPES:
# 1. int — Integer
# Whole numbers, no decimal
# A whole number — positive, negative, or zero. No decimal point. Used for counting, ages, scores, and anything you can count exactly.
# 
# Rule: No decimal allowed. 5 is an int. 5.0 is NOT an int — it's a float.

# In[12]:


age = 25
score = -10
zero = 0

print(age)        # 25
print(type(age))  # <class 'int'>
print(age + 5)    # 30


# 2. float — Floating point
# Numbers with a decimal point
# A number with a decimal point. Used for prices, measurements, temperatures — anything that needs precision beyond whole numbers.
# 
# Rule: If you write 5.0 Python treats it as float, even though it looks like a whole number.

# In[13]:


price = 9.99
temp  = 36.6
pi    = 3.14159

print(price)        # 9.99
print(type(price))  # <class 'float'>
print(price * 2)    # 19.98


# 3. bool — Boolean
# Only True or False
# Can only be one of two values: True or False. Think of it as a light switch — ON or OFF. Used whenever you need a yes/no answer.
# 
# Rule: True and False must start with a capital letter. true or false (lowercase) will cause an error.

# In[14]:


is_logged_in = True
has_error    = False

print(is_logged_in)         # True
print(type(is_logged_in))   # <class 'bool'>

print(10 > 5)               # True  (comparison gives bool)
print(10 < 5)               # False


# 4. str — String
# Text — any characters in quotes
# Any text — letters, words, sentences, even numbers wrapped in quotes. Always surrounded by single or double quotes. 
# Used for names, messages, labels.
# 
# 
# Rule: "123" is a string, NOT a number. You can't do math with it unless you convert it first using int("123").

# In[15]:


name    = "Alice"
city    = 'Dallas'
message = "Hello, World!"

print(name)           # Alice
print(type(name))     # <class 'str'>
print(name + " wins") # Alice wins  (join strings)
print(len(name))      # 5  (length)


# 5. complex — Complex number
# Real part + imaginary part
# A number with two parts: a real part and an imaginary part (written with j). Mostly used in engineering, physics, and 
#     advanced math. Rarely used in everyday coding.
# 
# Rule: Python uses j for imaginary numbers (not i like math class). You won't use this often as a beginner.

# In[16]:


z = 3 + 4j

print(z)          # (3+4j)
print(type(z))    # <class 'complex'>
print(z.real)     # 3.0  — the real part
print(z.imag)     # 4.0  — the imaginary part


# VARIABLES:
# What is a variable?
# A variable is a named box that stores a value in your program. You give it a name, then use = to put a value inside it. You can use that name anytime you want that value.

# In[17]:


name = "Alice"
age  = 25
city = "Dallas"

print(name)  # Alice
print(age)   # 25
print(city)  # Dallas


# Reassignment:
# Assigning the same name twice
# If you use the same variable name again with a new value, the old value is completely gone and replaced. Python only keeps the latest value.
# 
# Rule:The old value is not saved anywhere. Once you reassign, it is gone. Python does not keep a history.;:

# In[18]:


score = 10
print(score)   # 10

score = 99     # old value (10) is erased
print(score)   # 99

score = score + 1   # use current value, add 1
print(score)        # 100


# dynamic typing:
# Dynamic typing — type can change
# In Python you never need to say what type a variable will hold. Python figures it out automatically.
# And the type can change — a variable that holds a number can later hold text with no error.
# 
# Python does not — that is what "dynamic" means.

# In[19]:


x = 10          # x is an int
print(type(x))  # <class 'int'>

x = "hello"     # now x is a str — no error!
print(type(x))  # <class 'str'>

x = True        # now x is a bool
print(type(x))  # <class 'bool'>


# type checking:
# Checking the type with type()
# You can always ask Python what type any variable or value is using type(). Very useful when debugging.
# 
# type() never changes the variable — it just tells you what it is. Use it any time you are unsure.

# In[20]:


a = 42
b = 3.14
c = "hello"
d = True

print(type(a))   # <class 'int'>
print(type(b))   # <class 'float'>
print(type(c))   # <class 'str'>
print(type(d))   # <class 'bool'>
print(type(99))  # works on raw values too!


# Naming rules:
# Variable naming rules
# Variable names have a few simple rules in Python you must follow, and some good habits to keep your code readable.
# 
# Python convention: use lowercase with underscores (snake_case). Examples: user_name, total_score, is_active.

# In[45]:


# GOOD variable names — these work
my_name = "Alice"    # snake_case
age2    = 30         # number allowed (not at start)
_temp   = 99         # underscore ok at start

# BAD examples — DO NOT include these:
# 2fast   = "no"     # ERROR — starts with number
# my-name = "no"     # ERROR — hyphen not allowed
# class   = "no"     # ERROR — reserved word

print(my_name, age2)


# implicit:
# Implicit conversion — Python does it automatically
# When you mix an int and a float together, Python quietly upgrades the int to a float so the math works.
# You don't ask for it — Python just does it.
# 
# Rule: Python always converts to the "bigger" or more precise type. int + float = float. 
#     Python never loses precision automatically.

# In[25]:


x = 5      # int
y = 2.0    # float

z = x + y  # Python converts x to 5.0 automatically
print(z)         # 7.0
print(type(z))   # <class 'float'>

# Another example
result = 10 * 1.5   # int * float = float
print(result)       # 15.0


# explicit:
# Explicit type casting — you do it manually
# You manually convert a value from one type to another using built-in functions: int(), float(), str(), bool(). 
#     You are in control.
# 
# 
# Watch out: int(9.99) does NOT round — it cuts the decimal. 9.99 becomes 9, not 10. Use round() if you want rounding.

# In[26]:


int("42")       # str → int    →  42
float("3.14")   # str → float  →  3.14
str(100)        # int → str    →  "100"
int(9.99)       # float → int  →  9  (cuts decimal!)
bool(0)         # int → bool   →  False
bool(5)         # int → bool   →  True

age = int(input("Enter age: "))   # real use case
print(age + 1)


# errors:
# What fails — not everything can be cast
# You cannot cast just anything. If the value does not make sense as the target type, Python throws a ValueError.
# 
# Always make sure the value actually makes sense before casting. "42" can become an int. "hello" cannot.

# In[46]:


# The safe way — this is all you need to run:
x = float("3.14")   # first convert string to float
y = int(x)          # then convert float to int
print(y)            # 3


# duck typing:
# Duck typing — behaviour over type
# "If it walks like a duck and quacks like a duck, it's a duck." Python doesn't care what TYPE something is — if it
# can DO what you need, Python uses it. The same function works on different types automatically.
# 
# 
# Duck typing is why Python functions are so flexible. You write one function and it works on many types — as long as
# the operation makes sense.

# In[28]:


def double(x):
    return x * 2        # just multiply by 2

print(double(5))        # 10       — works for int
print(double(3.14))     # 6.28     — works for float
print(double("hi"))     # "hihi"   — works for string!
print(double([1, 2]))   # [1,2,1,2]— works for list too!

# Python never asked "what type is x?"
# It just tried x * 2 and it worked.


# dynamic typing:
# Dynamic typing — types checked at runtime
# In Python, types are not checked when you write the code — they are checked when the code actually runs.
# This means Python discovers type problems only when it hits that line during execution.
# 
# Contrast with static typing (Java, C++): those languages catch type errors before the program even runs. 
#     Python only finds them at runtime — so testing your code matters!

# In[47]:


items = [10, "Alice", True, 3.14]
for item in items:
    print(item, "is", type(item).__name__)


# Arithmetic:
# Arithmetic operations — basic math
# The standard math operators. Most are familiar — but //, %, and ** are special to Python and very useful.
# 
# 
# // (floor divide) drops the decimal. 10 // 3 = 3, not 3.33.   % (modulo) gives the leftover: 10 % 3 = 1 because 3 goes into 10 three times with 1 left over.

# In[32]:


print(10 + 3)   # 13  — addition
print(10 - 3)   # 7   — subtraction
print(10 * 3)   # 30  — multiply
print(10 / 3)   # 3.3333 — always float
print(10 // 3)  # 3   — whole number only
print(10 % 3)   # 1   — leftover after dividing
print(2 ** 4)   # 16  — 2 to the power of 4


# assignment:
# Assignment operations — update shortcuts
# Instead of writing x = x + 5 every time, Python gives you shortcuts. These update the variable's value in one step.
# 
# These are just shortcuts. x += 5 means exactly the same thing as x = x + 5. Use whichever feels clearer to you.

# In[31]:


score = 10

score += 5    # score = score + 5  → 15
score -= 2    # score = score - 2  → 13
score *= 3    # score = score * 3  → 39
score //= 4   # score = score // 4 → 9
print(score)  # 9


# comparison:
# Comparison operations — always True or False
# Comparison operators compare two values and always return a boolean: True or False. These are the backbone of every if statement.
# 
# Big mistake: = assigns a value. == checks if two things are equal. Never mix them up in an if statement!

# In[33]:


x = 10
print(x == 10)  # True  — is x equal to 10?
print(x != 5)   # True  — is x NOT equal to 5?
print(x > 8)   # True  — is x greater than 8?
print(x < 8)   # False — is x less than 8?
print(x >= 10) # True  — is x greater or equal to 10?
print(x <= 9)  # False — is x less or equal to 9?


# logical:
# Logical operations — combining conditions
# Logical operators let you combine multiple conditions into one. and needs both to be True. or needs at least one to be True.
# not flips the result.
# 
# Think of and as "stricter" (both must pass) and or as "more lenient" (either can pass). not just flips whatever comes after it.

# In[34]:


print(age >= 18 and has_id)    # True  — both true
print(age < 18 or has_id)     # True  — one is true
print(not age < 18)            # True  — flips False→True

# Real use: combining in an if
if age >= 18 and has_id:
    print("Welcome!")
else:
    print("Sorry, no entry.")


# f-string:
# f-string — the easiest way to build strings
# Put f right before the opening quote. Then use {} curly braces to drop any variable or expression directly into the text.
# Python replaces {name} with the actual value automatically.
# 
# You can put ANY expression inside {}: math, function calls, comparisons. f"2 + 2 = {2+2}" gives "2 + 2 = 4"

# In[38]:


name = "Alice"
age  = 25
city = "Dallas"

print(f"My name is {name}.")
print(f"I am {age} years old.")
print(f"I live in {city}.")
print(f"Next year I will be {age + 1}.")  # math works too!
print(f"{name} is from {city} and is {age}.")


# .format():
# .format() — the older way to build strings
# Use {} as placeholders inside your string, then call .format() at the end and pass in the values in order.
# You can also use index numbers like {0} and {1} to reuse values.
# 
# 
# f-strings (added in Python 3.6) are now preferred over .format() — they are shorter and easier to read. 
# But you will see .format() in older code.

# In[39]:


name  = "Bob"
score = 95

msg = "Player {} scored {} points!".format(name, score)
print(msg)

# using index numbers — reuse values
print("Hello {0}! {0} scored {1}.".format(name, score))

# using keyword names — very readable
print("Hi {n}, your score is {s}!".format(n=name, s=score))


# formatting extras:
# Formatting numbers inside strings
# Both f-strings and .format() let you control how numbers look — decimal places, padding, percentages — using a format
# spec after a colon : inside the braces.
# 
# The format spec goes after a colon inside the braces: {value:.2f} means "show this value with 2 decimal places as a float".

# In[40]:


pi    = 3.14159265
price = 9.5
ratio = 0.876

print(f"{pi:.2f}")       # 3.14   — 2 decimal places
print(f"{price:.2f}")    # 9.50   — always show 2 decimals
print(f"{ratio:.1%}")    # 87.6%  — as a percentage
print(f"{1000000:,}")    # 1,000,000 — add commas
print(f"{'hi':>10}")     # '        hi' — right-align in 10 chars


# boolean evaluation:
# Boolean evaluation of strings — truthy and falsy
# Every string is either True (truthy) or False (falsy) when used in an if statement.
# An empty string "" is False. Any string with content — even just a space — is True.
# 
# 

# In[42]:


username = ""

if username:
    print(f"Welcome, {username}!")
else:
    print("Please enter a username.")

name = "Alice"
if name:
    print(f"Hello, {name}!")  # this runs


# string methods:
# Handy string methods to know
# Strings come with built-in tools called methods. Call them with a dot after the string variable.
# 
# Methods do not change the original string — they return a new one. text.upper() does not change text, it gives you 
# a new uppercase copy.

# In[43]:


text = "  Hello, World!  "

print(text.strip())        # "Hello, World!"  — remove spaces
print(text.lower())        # "  hello, world!  "
print(text.upper())        # "  HELLO, WORLD!  "
print(text.replace("World", "Python"))  # "  Hello, Python!  "
print(len("Alice"))        # 5  — length of string
print("hello".startswith("he"))  # True
print("Alice".split("l"))  # ['A', 'ice']  — split into list


# if / elif / else — multiple conditions in order:
# elif means "else if" — check another condition only if the previous ones were False. Python goes through them top
# to bottom and stops at the first one that is True. Only one block runs.
# 
# Order matters! Python checks from top to bottom and stops at the first True condition. Put your most specific condition
# first and most general (else) last.

# In[44]:


score = 75

if score >= 90:
    print("Grade: A")
elif score >= 80:
    print("Grade: B")
elif score >= 70:
    print("Grade: C")
elif score >= 60:
    print("Grade: D")
else:
    print("Grade: F")


# In[ ]:




