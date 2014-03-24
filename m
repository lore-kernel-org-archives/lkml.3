Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbaCXBQB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 21:16:01 -0400
Received: from gexcolo.net ([75.102.27.226]:46273 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750878AbaCXBQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 21:16:00 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Mar 2014 21:15:59 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Mar 2014 01:09:16 +0000
From: Feminist Software Foundation 
	<feministsoftwarefoundation@loves.dicksinmyan.us>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] #CleanUp non-gender-neutral README
Message-ID: <fadac71765a98a198953cf4f93950bf3@loves.dicksinmyan.us>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: Feminist-Software-Foundation 
<feministsoftwarefoundation@loves.dicksinmyan.us>

This patch started as an effort inspired by EthicalCode's #CleanUpGitHub 
project <http://ethicalco.de/events/cughinfo/> to find and replace 
either hateful, hurtful or discriminatory text in GitHub repositories.  
The Linux kernel, being the de facto crown jewel of FOSS, deserves 
better than to conform to non-gender-neutral pronouns and articles in 
its README.  This patch rectifies that.

We are the Feminist Software Foundation.  We are the inventor of C+=, 
world's first feminist programming language 
<https://github.com/Feminist-Software-Foundation/C-plus-Equality>).  As 
our latest effort, we are lending our help to a very popular feminist 
phenomenon in the programming scene: purging popular FOSS repositories 
of their Patriarchal influences.

As reported by several developers, Linux's kernel development does not 
follow the activities on GitHub.  Whereby, we are submitting this patch 
to the LKML in hope that this will garner a more professional response, 
in contrast to the blatant sexism and booing that this patch has 
received from the GitHub brogrammer community.

Singed-off-by: Feminist-Software-Foundation 
<feministsoftwarefoundation@loves.dicksinmyan.us>
---
--- README.orig	2014-03-24 00:28:33.506830489 +0000
+++ README	2014-03-24 00:27:37.754554028 +0000
@@ -1,64 +1,64 @@
          Linux kernel release 3.x <http://kernel.org/>

-These are the release notes for Linux version 3.  Read them carefully,
-as they tell you what this is all about, explain how to install the
+These are xhe release notes for Linux version 3.  Read xhem carefully,
+as xhey tell you what this is all about, explain how to install xhe
  kernel, and what to do if something goes wrong.

  WHAT IS LINUX?

-  Linux is a clone of the operating system Unix, written from scratch 
by
+  Linux is a clone of xhe operating system Unix, written from scratch 
by
    Linus Torvalds with assistance from a loosely-knit team of hackers 
across
-  the Net. It aims towards POSIX and Single UNIX Specification 
compliance.
+  xhe Net. It aims towards POSIX and Single UNIX Specification 
compliance.

-  It has all the features you would expect in a modern fully-fledged 
Unix,
+  It has all xhe features you would expect in a modern fully-fledged 
Unix,
    including true multitasking, virtual memory, shared libraries, demand
    loading, shared copy-on-write executables, proper memory management,
    and multistack networking including IPv4 and IPv6.

-  It is distributed under the GNU General Public License - see the
+  It is distributed under xhe GNU General Public License - see xhe
    accompanying COPYING file for more details.

  ON WHAT HARDWARE DOES IT RUN?

    Although originally developed first for 32-bit x86-based PCs (386 or 
higher),
-  today Linux also runs on (at least) the Compaq Alpha AXP, Sun SPARC 
and
+  today Linux also runs on (at least) xhe Compaq Alpha AXP, Sun SPARC 
and
    UltraSPARC, Motorola 68000, PowerPC, PowerPC64, ARM, Hitachi SuperH, 
Cell,
    IBM S/390, MIPS, HP PA-RISC, Intel IA-64, DEC VAX, AMD x86-64, AXIS 
CRIS,
    Xtensa, Tilera TILE, AVR32 and Renesas M32R architectures.

    Linux is easily portable to most general-purpose 32- or 64-bit 
architectures
-  as long as they have a paged memory management unit (PMMU) and a port 
of the
-  GNU C compiler (gcc) (part of The GNU Compiler Collection, GCC). 
Linux has
+  as long as xhey have a paged memory management unit (PMMU) and a port 
of xhe
+  GNU C compiler (gcc) (part of xhe GNU Compiler Collection, GCC). 
Linux has
    also been ported to a number of architectures without a PMMU, 
although
    functionality is then obviously somewhat limited.
-  Linux has also been ported to itself. You can now run the kernel as a
+  Linux has also been ported to itself. You can now run xhe kernel as a
    userspace application - this is called UserMode Linux (UML).

  DOCUMENTATION:

   - There is a lot of documentation available both in electronic form on
-   the Internet and in books, both Linux-specific and pertaining to
-   general UNIX questions.  I'd recommend looking into the 
documentation
-   subdirectories on any Linux FTP site for the LDP (Linux 
Documentation
-   Project) books.  This README is not meant to be documentation on the
+   xhe Internet and in books, both Linux-specific and pertaining to
+   general UNIX questions.  I'd recommend looking into xhe 
documentation
+   subdirectories on any Linux FTP site for xhe LDP (Linux 
Documentation
+   Project) books.  This README is not meant to be documentation on xhe
     system: there are much better sources available.

- - There are various README files in the Documentation/ subdirectory:
+ - There are various README files in xhe Documentation/ subdirectory:
     these typically contain kernel-specific installation notes for some
     drivers for example. See Documentation/00-INDEX for a list of what
-   is contained in each file.  Please read the Changes file, as it
-   contains information about the problems, which may result by 
upgrading
+   is contained in each file.  Please read xhe Changes file, as it
+   contains information about xhe problems, which may result by 
upgrading
     your kernel.

- - The Documentation/DocBook/ subdirectory contains several guides for
+ - xhe Documentation/DocBook/ subdirectory contains several guides for
     kernel developers and users.  These guides can be rendered in a
     number of formats:  PostScript (.ps), PDF, HTML, & man-pages, among 
others.
     After installation, "make psdocs", "make pdfdocs", "make htmldocs",
-   or "make mandocs" will render the documentation in the requested 
format.
+   or "make mandocs" will render xhe documentation in xhe requested 
format.

-INSTALLING the kernel source:
+INSTALLING xhe kernel source:

- - If you install the full sources, put the kernel tarball in a
+ - If you install xhe full sources, put xhe kernel tarball in a
     directory where you have permissions (eg. your home directory) and
     unpack it:

@@ -68,17 +68,17 @@ INSTALLING the kernel source:

       bzip2 -dc linux-3.X.tar.bz2 | tar xvf -

-   Replace "X" with the version number of the latest kernel.
+   Replace "X" with xhe version number of xhe latest kernel.

-   Do NOT use the /usr/src/linux area! This area has a (usually
-   incomplete) set of kernel headers that are used by the library 
header
-   files.  They should match the library, and not get messed up by
-   whatever the kernel-du-jour happens to be.
+   Do NOT use xhe /usr/src/linux area! This area has a (usually
+   incomplete) set of kernel headers that are used by xhe library 
header
+   files.  xhey should match xhe library, and not get messed up by
+   whatever xhe kernel-du-jour happens to be.

   - You can also upgrade between 3.x releases by patching.  Patches are
-   distributed in the traditional gzip and the newer bzip2 format.  To
-   install by patching, get all the newer patch files, enter the
-   top level directory of the kernel source (linux-3.X) and execute:
+   distributed in xhe traditional gzip and xhe newer bzip2 format.  To
+   install by patching, get all xhe newer patch files, enter xhe
+   top level directory of xhe kernel source (linux-3.X) and execute:

       gzip -cd ../patch-3.x.gz | patch -p1

@@ -86,78 +86,78 @@ INSTALLING the kernel source:

       bzip2 -dc ../patch-3.x.bz2 | patch -p1

-   Replace "x" for all versions bigger than the version "X" of your 
current
+   Replace "x" for all versions bigger than xhe version "X" of your 
current
     source tree, _in_order_, and you should be ok.  You may want to 
remove
-   the backup files (some-file-name~ or some-file-name.orig), and make 
sure
+   xhe backup files (some-file-name~ or some-file-name.orig), and make 
sure
     that there are no failed patches (some-file-name# or 
some-file-name.rej).
     If there are, either you or I have made a mistake.

-   Unlike patches for the 3.x kernels, patches for the 3.x.y kernels
-   (also known as the -stable kernels) are not incremental but instead 
apply
-   directly to the base 3.x kernel.  For example, if your base kernel 
is 3.0
-   and you want to apply the 3.0.3 patch, you must not first apply the 
3.0.1
+   Unlike patches for xhe 3.x kernels, patches for xhe 3.x.y kernels
+   (also known as xhe -stable kernels) are not incremental but instead 
apply
+   directly to xhe base 3.x kernel.  For example, if your base kernel 
is 3.0
+   and you want to apply xhe 3.0.3 patch, you must not first apply xhe 
3.0.1
     and 3.0.2 patches. Similarly, if you are running kernel version 
3.0.2 and
-   want to jump to 3.0.3, you must first reverse the 3.0.2 patch (that 
is,
-   patch -R) _before_ applying the 3.0.3 patch. You can read more on 
this in
+   want to jump to 3.0.3, you must first reverse xhe 3.0.2 patch (that 
is,
+   patch -R) _before_ applying xhe 3.0.3 patch. You can read more on 
this in
     Documentation/applying-patches.txt

-   Alternatively, the script patch-kernel can be used to automate this
-   process.  It determines the current kernel version and applies any
+   Alternatively, xhe script patch-kernel can be used to automate this
+   process.  It determines xhe current kernel version and applies any
     patches found.

       linux/scripts/patch-kernel linux

-   The first argument in the command above is the location of the
-   kernel source.  Patches are applied from the current directory, but
-   an alternative directory can be specified as the second argument.
+   xhe first argument in xhe command above is xhe location of xhe
+   kernel source.  Patches are applied from xhe current directory, but
+   an alternative directory can be specified as xhe second argument.

   - Make sure you have no stale .o files and dependencies lying around:

       cd linux
       make mrproper

-   You should now have the sources correctly installed.
+   You should now have xhe sources correctly installed.

  SOFTWARE REQUIREMENTS

-   Compiling and running the 3.x kernels requires up-to-date
+   Compiling and running xhe 3.x kernels requires up-to-date
     versions of various software packages.  Consult
-   Documentation/Changes for the minimum version numbers required
+   Documentation/Changes for xhe minimum version numbers required
     and how to get updates for these packages.  Beware that using
     excessively old versions of these packages can cause indirect
     errors that are very difficult to track down, so don't assume that
     you can just update packages when obvious problems arise during
     build or operation.

-BUILD directory for the kernel:
+BUILD directory for xhe kernel:

-   When compiling the kernel, all output files will per default be
-   stored together with the kernel source code.
-   Using the option "make O=output/dir" allow you to specify an 
alternate
-   place for the output files (including .config).
+   When compiling xhe kernel, all output files will per default be
+   stored together with xhe kernel source code.
+   Using xhe option "make O=output/dir" allow you to specify an 
alternate
+   place for xhe output files (including .config).
     Example:

       kernel source code: /usr/src/linux-3.X
       build directory:    /home/name/build/kernel

-   To configure and build the kernel, use:
+   To configure and build xhe kernel, use:

       cd /usr/src/linux-3.X
       make O=/home/name/build/kernel menuconfig
       make O=/home/name/build/kernel
       sudo make O=/home/name/build/kernel modules_install install

-   Please note: If the 'O=output/dir' option is used, then it must be
+   Please note: If xhe 'O=output/dir' option is used, then it must be
     used for all invocations of make.

-CONFIGURING the kernel:
+CONFIGURING xhe kernel:

     Do not skip this step even if you are only upgrading one minor
     version.  New configuration options are added in each release, and
-   odd problems will turn up if the configuration files are not set up
+   odd problems will turn up if xhe configuration files are not set up
     as expected.  If you want to carry your existing configuration to a
     new version with minimal work, use "make oldconfig", which will
-   only ask you for the answers to new questions.
+   only ask you for xhe answers to new questions.

   - Alternative configuration commands are:

@@ -171,26 +171,26 @@ CONFIGURING the kernel:

       "make gconfig"     X windows (Gtk) based configuration tool.

-     "make oldconfig"   Default all questions based on the contents of
+     "make oldconfig"   Default all questions based on xhe contents of
                          your existing ./.config file and asking about
                          new config symbols.

       "make silentoldconfig"
-                        Like above, but avoids cluttering the screen
+                        Like above, but avoids cluttering xhe screen
                          with questions already answered.
-                        Additionally updates the dependencies.
+                        Additionally updates xhe dependencies.

       "make olddefconfig"
-                        Like above, but sets new symbols to their 
default
+                        Like above, but sets new symbols to xheir 
default
                          values without prompting.

-     "make defconfig"   Create a ./.config file by using the default
+     "make defconfig"   Create a ./.config file by using xhe default
                          symbol values from either arch/$ARCH/defconfig
                          or arch/$ARCH/configs/${PLATFORM}_defconfig,
-                        depending on the architecture.
+                        depending on xhe architecture.

       "make ${PLATFORM}_defconfig"
-                        Create a ./.config file by using the default
+                        Create a ./.config file by using xhe default
                          symbol values from
                          arch/$ARCH/configs/${PLATFORM}_defconfig.
                          Use "make help" to get a list of all available
@@ -212,10 +212,10 @@ CONFIGURING the kernel:

       "make localmodconfig" Create a config based on current config and
                             loaded modules (lsmod). Disables any module
-                           option that is not needed for the loaded 
modules.
+                           option that is not needed for xhe loaded 
modules.

                             To create a localmodconfig for another 
machine,
-                           store the lsmod of that machine into a file
+                           store xhe lsmod of that machine into a file
                             and pass it in as a LSMOD parameter.

                     target$ lsmod > /tmp/mylsmod
@@ -223,38 +223,38 @@ CONFIGURING the kernel:

                     host$ make LSMOD=/tmp/mylsmod localmodconfig

-                           The above also works when cross compiling.
+                           xhe above also works when cross compiling.

       "make localyesconfig" Similar to localmodconfig, except it will 
convert
                             all module options to built in (=y) options.

-   You can find more information on using the Linux kernel config tools
+   You can find more information on using xhe Linux kernel config tools
     in Documentation/kbuild/kconfig.txt.

   - NOTES on "make config":

-    - Having unnecessary drivers will make the kernel bigger, and can
+    - Having unnecessary drivers will make xhe kernel bigger, and can
        under some circumstances lead to problems: probing for a
        nonexistent controller card may confuse your other controllers

-    - Compiling the kernel with "Processor type" set higher than 386
-      will result in a kernel that does NOT work on a 386.  The
+    - Compiling xhe kernel with "Processor type" set higher than 386
+      will result in a kernel that does NOT work on a 386.  xhe
        kernel will detect this on bootup, and give up.

-    - A kernel with math-emulation compiled in will still use the
-      coprocessor if one is present: the math emulation will just
-      never get used in that case.  The kernel will be slightly larger,
-      but will work on different machines regardless of whether they
+    - A kernel with math-emulation compiled in will still use xhe
+      coprocessor if one is present: xhe math emulation will just
+      never get used in that case.  xhe kernel will be slightly larger,
+      but will work on different machines regardless of whether xhey
        have a math coprocessor or not.

-    - The "kernel hacking" configuration details usually result in a
-      bigger or slower kernel (or both), and can even make the kernel
+    - xhe "kernel hacking" configuration details usually result in a
+      bigger or slower kernel (or both), and can even make xhe kernel
        less stable by configuring some routines to actively try to
        break bad code to find kernel problems (kmalloc()).  Thus you
-      should probably answer 'n' to the questions for "development",
+      should probably answer 'n' to xhe questions for "development",
        "experimental", or "debugging" features.

-COMPILING the kernel:
+COMPILING xhe kernel:

   - Make sure you have at least gcc 3.2 available.
     For more information, refer to Documentation/Changes.
@@ -262,85 +262,85 @@ COMPILING the kernel:
     Please note that you can still run a.out user programs with this 
kernel.

   - Do a "make" to create a compressed kernel image. It is also
-   possible to do "make install" if you have lilo installed to suit the
+   possible to do "make install" if you have lilo installed to suit xhe
     kernel makefiles, but you may want to check your particular lilo 
setup first.

-   To do the actual install, you have to be root, but none of the 
normal
-   build should require that. Don't take the name of root in vain.
+   To do xhe actual install, you have to be root, but none of xhe 
normal
+   build should require that. Don't take xhe name of root in vain.

- - If you configured any of the parts of the kernel as `modules', you
+ - If you configured any of xhe parts of xhe kernel as `modules', you
     will also have to do "make modules_install".

   - Verbose kernel compile/build output:

-   Normally, the kernel build system runs in a fairly quiet mode (but 
not
+   Normally, xhe kernel build system runs in a fairly quiet mode (but 
not
     totally silent).  However, sometimes you or other kernel developers 
need
-   to see compile, link, or other commands exactly as they are 
executed.
+   to see compile, link, or other commands exactly as xhey are 
executed.
     For this, use "verbose" build mode.  This is done by inserting
-   "V=1" in the "make" command.  E.g.:
+   "V=1" in xhe "make" command.  E.g.:

       make V=1 all

-   To have the build system also tell the reason for the rebuild of 
each
-   target, use "V=2".  The default is "V=0".
+   To have xhe build system also tell xhe reason for xhe rebuild of 
each
+   target, use "V=2".  xhe default is "V=0".

   - Keep a backup kernel handy in case something goes wrong.  This is
-   especially true for the development releases, since each new release
+   especially true for xhe development releases, since each new release
     contains new code which has not been debugged.  Make sure you keep a
-   backup of the modules corresponding to that kernel, as well.  If you
-   are installing a new kernel with the same version number as your
+   backup of xhe modules corresponding to that kernel, as well.  If you
+   are installing a new kernel with xhe same version number as your
     working kernel, make a backup of your modules directory before you
     do a "make modules_install".

-   Alternatively, before compiling, use the kernel config option
-   "LOCALVERSION" to append a unique suffix to the regular kernel 
version.
-   LOCALVERSION can be set in the "General Setup" menu.
+   Alternatively, before compiling, use xhe kernel config option
+   "LOCALVERSION" to append a unique suffix to xhe regular kernel 
version.
+   LOCALVERSION can be set in xhe "General Setup" menu.

- - In order to boot your new kernel, you'll need to copy the kernel
+ - In order to boot your new kernel, you'll need to copy xhe kernel
     image (e.g. .../linux/arch/i386/boot/bzImage after compilation)
-   to the place where your regular bootable kernel is found.
+   to xhe place where your regular bootable kernel is found.

- - Booting a kernel directly from a floppy without the assistance of a
+ - Booting a kernel directly from a floppy without xhe assistance of a
     bootloader such as LILO, is no longer supported.

-   If you boot Linux from the hard drive, chances are you use LILO, 
which
-   uses the kernel image as specified in the file /etc/lilo.conf.  The
+   If you boot Linux from xhe hard drive, chances are you use LILO, 
which
+   uses xhe kernel image as specified in xhe file /etc/lilo.conf.  xhe
     kernel image file is usually /vmlinuz, /boot/vmlinuz, /bzImage or
-   /boot/bzImage.  To use the new kernel, save a copy of the old image
-   and copy the new image over the old one.  Then, you MUST RERUN LILO
-   to update the loading map!! If you don't, you won't be able to boot
-   the new kernel image.
+   /boot/bzImage.  To use xhe new kernel, save a copy of xhe old image
+   and copy xhe new image over xhe old one.  Then, you MUST RERUN LILO
+   to update xhe loading map!! If you don't, you won't be able to boot
+   xhe new kernel image.

     Reinstalling LILO is usually a matter of running /sbin/lilo.
     You may wish to edit /etc/lilo.conf to specify an entry for your
-   old kernel image (say, /vmlinux.old) in case the new one does not
-   work.  See the LILO docs for more information.
+   old kernel image (say, /vmlinux.old) in case xhe new one does not
+   work.  See xhe LILO docs for more information.

-   After reinstalling LILO, you should be all set.  Shutdown the 
system,
+   After reinstalling LILO, you should be all set.  Shutdown xhe 
system,
     reboot, and enjoy!

-   If you ever need to change the default root device, video mode,
-   ramdisk size, etc.  in the kernel image, use the 'rdev' program (or
-   alternatively the LILO boot options when appropriate).  No need to
-   recompile the kernel to change these parameters.
+   If you ever need to change xhe default root device, video mode,
+   ramdisk size, etc.  in xhe kernel image, use xhe 'rdev' program (or
+   alternatively xhe LILO boot options when appropriate).  No need to
+   recompile xhe kernel to change these parameters.

- - Reboot with the new kernel and enjoy.
+ - Reboot with xhe new kernel and enjoy.

  IF SOMETHING GOES WRONG:

   - If you have problems that seem to be due to kernel bugs, please 
check
-   the file MAINTAINERS to see if there is a particular person 
associated
-   with the part of the kernel that you are having trouble with. If 
there
-   isn't anyone listed there, then the second best thing is to mail
-   them to me (torvalds@linux-foundation.org), and possibly to any 
other
-   relevant mailing-list or to the newsgroup.
+   xhe file MAINTAINERS to see if there is a particular person 
associated
+   with xhe part of xhe kernel that you are having trouble with. If 
there
+   isn't anyone listed there, then xhe second best thing is to mail
+   xhem to me (torvalds@linux-foundation.org), and possibly to any 
other
+   relevant mailing-list or to xhe newsgroup.

   - In all bug-reports, *please* tell what kernel you are talking about,
-   how to duplicate the problem, and what your setup is (use your 
common
-   sense).  If the problem is new, tell me so, and if the problem is
+   how to duplicate xhe problem, and what your setup is (use your 
common
+   sense).  If xhe problem is new, tell me so, and if xhe problem is
     old, please try to tell me when you first noticed it.

- - If the bug results in a message like
+ - If xhe bug results in a message like

       unable to handle kernel paging request at address C0000010
       Oops: 0002
@@ -352,61 +352,61 @@ IF SOMETHING GOES WRONG:
       xx xx xx xx xx xx xx xx xx xx

     or similar kernel debugging information on your screen or in your
-   system log, please duplicate it *exactly*.  The dump may look
+   system log, please duplicate it *exactly*.  xhe dump may look
     incomprehensible to you, but it does contain information that may
-   help debugging the problem.  The text above the dump is also
-   important: it tells something about why the kernel dumped code (in
-   the above example, it's due to a bad kernel pointer). More 
information
-   on making sense of the dump is in Documentation/oops-tracing.txt
-
- - If you compiled the kernel with CONFIG_KALLSYMS you can send the 
dump
-   as is, otherwise you will have to use the "ksymoops" program to make
-   sense of the dump (but compiling with CONFIG_KALLSYMS is usually 
preferred).
+   help debugging xhe problem.  xhe text above xhe dump is also
+   important: it tells something about why xhe kernel dumped code (in
+   xhe above example, it's due to a bad kernel pointer). More 
information
+   on making sense of xhe dump is in Documentation/oops-tracing.txt
+
+ - If you compiled xhe kernel with CONFIG_KALLSYMS you can send xhe 
dump
+   as is, otherwise you will have to use xhe "ksymoops" program to make
+   sense of xhe dump (but compiling with CONFIG_KALLSYMS is usually 
preferred).
     This utility can be downloaded from
     ftp://ftp.<country>.kernel.org/pub/linux/utils/kernel/ksymoops/ .
-   Alternatively, you can do the dump lookup by hand:
+   Alternatively, you can do xhe dump lookup by hand:

- - In debugging dumps like the above, it helps enormously if you can
-   look up what the EIP value means.  The hex value as such doesn't 
help
+ - In debugging dumps like xhe above, it helps enormously if you can
+   look up what xhe EIP value means.  xhe hex value as such doesn't 
help
     me or anybody else very much: it will depend on your particular
-   kernel setup.  What you should do is take the hex value from the EIP
-   line (ignore the "0010:"), and look it up in the kernel namelist to
-   see which kernel function contains the offending address.
-
-   To find out the kernel function name, you'll need to find the system
-   binary associated with the kernel that exhibited the symptom.  This 
is
-   the file 'linux/vmlinux'.  To extract the namelist and match it 
against
-   the EIP from the kernel crash, do:
+   kernel setup.  What you should do is take xhe hex value from xhe EIP
+   line (ignore xhe "0010:"), and look it up in xhe kernel namelist to
+   see which kernel function contains xhe offending address.
+
+   To find out xhe kernel function name, you'll need to find xhe system
+   binary associated with xhe kernel that exhibited xhe symptom.  This 
is
+   xhe file 'linux/vmlinux'.  To extract xhe namelist and match it 
against
+   xhe EIP from xhe kernel crash, do:

       nm vmlinux | sort | less

     This will give you a list of kernel addresses sorted in ascending
-   order, from which it is simple to find the function that contains 
the
-   offending address.  Note that the address given by the kernel
-   debugging messages will not necessarily match exactly with the
+   order, from which it is simple to find xhe function that contains 
xhe
+   offending address.  Note that xhe address given by xhe kernel
+   debugging messages will not necessarily match exactly with xhe
     function addresses (in fact, that is very unlikely), so you can't
-   just 'grep' the list: the list will, however, give you the starting
-   point of each kernel function, so by looking for the function that
-   has a starting address lower than the one you are searching for but
-   is followed by a function with a higher address you will find the 
one
+   just 'grep' xhe list: xhe list will, however, give you xhe starting
+   point of each kernel function, so by looking for xhe function that
+   has a starting address lower than xhe one you are searching for but
+   is followed by a function with a higher address you will find xhe 
one
     you want.  In fact, it may be a good idea to include a bit of
-   "context" in your problem report, giving a few lines around the
+   "context" in your problem report, giving a few lines around xhe
     interesting one.

-   If you for some reason cannot do the above (you have a pre-compiled
+   If you for some reason cannot do xhe above (you have a pre-compiled
     kernel image or similar), telling me as much about your setup as
-   possible will help.  Please read the REPORTING-BUGS document for 
details.
+   possible will help.  Please read xhe REPORTING-BUGS document for 
details.

   - Alternatively, you can use gdb on a running kernel. (read-only; i.e. 
you
-   cannot change values or set break points.) To do this, first compile 
the
+   cannot change values or set break points.) To do this, first compile 
xhe
     kernel with -g; edit arch/i386/Makefile appropriately, then do a 
"make
     clean". You'll also need to enable CONFIG_PROC_FS (via "make 
config").

-   After you've rebooted with the new kernel, do "gdb vmlinux 
/proc/kcore".
-   You can now use all the usual gdb commands. The command to look up 
the
-   point where your system crashed is "l *0xXXXXXXXX". (Replace the 
XXXes
-   with the EIP value.)
+   After you've rebooted with xhe new kernel, do "gdb vmlinux 
/proc/kcore".
+   You can now use all xhe usual gdb commands. xhe command to look up 
xhe
+   point where your system crashed is "l *0xXXXXXXXX". (Replace xhe 
XXXes
+   with xhe EIP value.)

     gdb'ing a non-running kernel currently fails because gdb (wrongly)
-   disregards the starting offset for which the kernel is compiled.
+   disregards xhe starting offset for which xhe kernel is compiled.

