PY65 Testcase Stealer
=====================

This is a small quick-n-dirty python script to grab the preconditions and postconditions
of the unit tests written for py65.

It will print a suitable swift file on STDOUT, which is committed with the name StolenCases.swift.

There are two other printers in the file, one for json output, and other that create a POD swift
array with the information needed, but they're vestigial in the code.

