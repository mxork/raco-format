Alternatives
============

Check out <https://github.com/sorawee/fmt> for a similar project that is aimed
at having more features and extensibility.

raco-format
===========

Formats source files.

```
raco format [FILE] ...
```

## Examples

Reading from `stdin`:

```
$ raco format <<EOF
#lang racket/base

    (require
racket/list
)

(for ([i 15])
    (displayln
  (cond
     [(= (modulo i 15) 0) 
     "fizzbuzz"]
         [(= (modulo i 5) 0) "buzz"]
     [(= (modulo i 3) 0) "fizz"]
   [else i])))
EOF
#lang racket/base

(require
  racket/list
  )

(for ([i 15])
  (displayln
   (cond
     [(= (modulo i 15) 0) 
      "fizzbuzz"]
     [(= (modulo i 5) 0) "buzz"]
     [(= (modulo i 3) 0) "fizz"]
     [else i])))
```

Formatting files in place:

```
$ raco format a.rkt b.rkt
a.rkt
b.rkt
```


Formatting all `*.rkt` files in a directory:

```
$ find
.
./folder
./folder/e.txt
./folder/d.rkt
./c.txt
./b.rkt
./a.rkt

$ raco format .
./a.rkt
./b.rkt
./folder/d.rkt
```
