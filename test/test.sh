#!/bin/sh
mocha --timeout 999999999 --compilers coffee:coffee-script $(cd `dirname $0`; pwd)/unit_test.coffee
#mocha --timeout 999999999 --compilers coffee:coffee-script/register $(cd `dirname $0`; pwd)/unit_test.coffee