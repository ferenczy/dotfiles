# PowerShell wrapper for Jumper - a simple command-line favorite shortcut retriever

# It allows to execute Jumper simply by using: `jump <key> [subkey]`
# Example: `jump me doc`

# Place this script to any directory under PATH so it may be executed from anywhere simply by typing
# `jump` on a command-line.

# path to Python interpreter, use absolute path if it's not in PATH
$PYTHON_EXECUTABLE = 'python'

# Jumper may be anywhere, just make sure the proper ABSOLUTE path is specified here
$JUMPER_PATH = 'c:\utils\jumper.py'

# get favorite path using key and optionally subkey (first and second parameter)
$result=(& $PYTHON_EXECUTABLE $JUMPER_PATH $Args[0] $Args[1])

# change path if Jumper execution has been successful
if ($LastExitCode -eq 0) {
    cd $result
}
# or just print error
else {
    echo "Error[$LastExitCode]: $result"
}
