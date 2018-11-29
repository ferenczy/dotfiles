"""
Jumper - a simple command-line favorite shortcut retriever

A super-simple script which allows to print a value specified by a key and optionally a subkey
from a predefined 2-level dictionary to stdout.

The purpose is to have a collection of favorite frequently used directory paths, possibly in groups,
and a mechanism to easily retrieve them on a command-line.

In a connection with various few lines long shell scripts (bash, PowerShell, etc.), it allows to
quickly change current working directory by typing just a few characters. Use the shell script so it
may be executed simply by typing `jump <key> [subkey]` anywhere.

Usage: python jumper.py <key> [subkey]

Examples:
    - `python jumper.py dev`
    - `python jumper.py me`
    - `python jumper.py me doc`
"""

import sys

VERSION = '0.1'

SHORTCUTS = {
    'me': {
        'default': 'c:\\Users\\me',
        'doc': 'c:\\Users\\me\\Documents',
    },
    'fav': {
        '1': 'c:\\favorites\\first',
    },
    'dev': 'c:\\development'
}

arg_cnt = (len(sys.argv))
if arg_cnt < 2:
    print(f'Jumper {VERSION}')
    print('Usage: jump <key> [subkey]')
    sys.exit(2)

key = sys.argv[1]
subkey = sys.argv[2] if arg_cnt >= 3 else None

if not key in SHORTCUTS:
    print(f'Unknown key: {key}')
    sys.exit(1)

command = SHORTCUTS[key]
command_type = type(command)

# check that subkey wasn't specified when command is just simple string
if command_type == str and subkey is not None:
    print(f'Key "{key}" cannot be used with a subkey')
    sys.exit(2)

# if command is dictionary and subkey wasn't specified, use "default" for subkey is command contains it
if command_type == dict and subkey is None and 'default' in command:
    subkey = 'default'

# check we have subkey when command is dictionary
if command_type == dict and subkey is None:
    print(f"Key \"{key}\" must be used with one of the following subkeys: {', '.join(command.keys())}")
    sys.exit(2)

# check if command contains specified subkey if it's dictionary
if command_type == dict and subkey not in command:
    print(f'Key "{key}" doesn\'t have subkey "{subkey}"')
    sys.exit(1)

# just print value of the command to stdout so caller can `cd` into it
print(command if command_type == str else command[subkey])
