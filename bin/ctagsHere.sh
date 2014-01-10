#!/bin/bash
DIRS=$1
TAGS=tags
echo "$DIRS/$TAGS will be created!"
echo "$1/$TAGS will be created!" > /dev/null
pushd $1

#should be asked whether TAGS is to be deleted or not
if [ -f ${TAGS} ]; then rm -f ${TAGS}; fi

if [ "${DIRS##*/}" = "android" ] || [ -f "${DIRS}/build/envsetup.sh" ];then
echo Hello android!!
time ctags -f ${TAGS}\
        --languages=C,C++,Asm,Java,Sh,Make,Python\
    --exclude=*.{js,html,htm,css,php,guess,log,txt}        \
    --sort=foldcase \
    --fields=+iaS \
    --extra=+q \
        -R        \
        abi                        \
        build                        \
        bionic                        \
        bootable                \
        dalvik                        \
        development/samples/ApiDemos                        \
        development/samples/HelloActivity                \
        device                        \
        frameworks                \
        hardware                \
        libcore                \
        system                        \
        vendor                        \
        #

#remove special char from language encoding ex UTF-8
#or you can encounter "cstag is not ~~~~ "msg
if [ "CYGWIN" = "$(uname | grep CYGWIN -o)" ];then
echo " running on cygwin"
    cat ${TAGS} | sed '1,/^\!/d' > ${TAGS}_
    mv ${TAGS}_ ${TAGS}
fi

else # if android

echo Hello Others!!
time ctags -f ${TAGS}\
        --languages=C,C++,Asm,Java,Sh,Make,Python\
    --exclude=*.{js,htm,css,php,guess,log,txt}        \
    --sort=foldcase \
        -R
fi
popd
