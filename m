Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbaHHPXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:23:37 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:59175 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160AbaHHPXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:23:33 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/4] Documentation: kbuild: Improve grammar
Date: Fri,  8 Aug 2014 17:23:10 +0200
Message-Id: <1407511390-5429-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407511390-5429-1-git-send-email-geert@linux-m68k.org>
References: <1407511390-5429-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - singular versus plural,
  - "by" versus "of",
  - missing "if", "it", "the",
  - consistent use of "xxx-specific" versus "xxx specific".

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 Documentation/kbuild/makefiles.txt | 58 +++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 4275a719f45f..2aa04af8e249 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -175,7 +175,7 @@ more details, with real examples.
 
 --- 3.3 Loadable module goals - obj-m
 
-	$(obj-m) specify object files which are built as loadable
+	$(obj-m) specifies object files which are built as loadable
 	kernel modules.
 
 	A module may be built from one source file or several source
@@ -278,7 +278,7 @@ more details, with real examples.
 	down in the ext2 directory.
 	Kbuild only uses this information to decide that it needs to visit
 	the directory, it is the Makefile in the subdirectory that
-	specifies what is modules and what is built-in.
+	specifies what is modular and what is built-in.
 
 	It is good practice to use a CONFIG_ variable when assigning directory
 	names. This allows kbuild to totally skip the directory if the
@@ -404,7 +404,7 @@ more details, with real examples.
 	echoing information to user in a rule is often a good practice
 	but when execution "make -s" one does not expect to see any output
 	except for warnings/errors.
-	To support this kbuild define $(kecho) which will echo out the
+	To support this kbuild defines $(kecho) which will echo out the
 	text following $(kecho) to stdout except if "make -s" is used.
 
 	Example:
@@ -418,7 +418,7 @@ more details, with real examples.
 
 	The kernel may be built with several different versions of
 	$(CC), each supporting a unique set of features and options.
-	kbuild provide basic support to check for valid options for $(CC).
+	kbuild provides basic support to check for valid options for $(CC).
 	$(CC) is usually the gcc compiler, but other alternatives are
 	available.
 
@@ -457,8 +457,8 @@ more details, with real examples.
 	Note: as-instr-option uses KBUILD_AFLAGS for $(AS) options
 
     cc-option
-	cc-option is used to check if $(CC) supports a given option, and not
-	supported to use an optional second option.
+	cc-option is used to check if $(CC) supports a given option, and if
+	not supported to use an optional second option.
 
 	Example:
 		#arch/x86/Makefile
@@ -558,8 +558,8 @@ more details, with real examples.
 			false ; \
 		fi
 
-	In this example for a specific GCC version the build will error out explaining
-	to the user why it stops.
+	In this example for a specific GCC version the build will error out
+	explaining to the user why it stops.
 
     cc-cross-prefix
 	cc-cross-prefix is used to check if there exists a $(CC) in path with
@@ -659,7 +659,7 @@ Both possibilities are described in the following.
 		libkconfig-objs := expr.o type.o
 
 	Shared libraries always require a corresponding -objs line, and
-	in the example above the shared library libkconfig is composed by
+	in the example above the shared library libkconfig is composed of
 	the two objects expr.o and type.o.
 	expr.o and type.o will be built as position independent code and
 	linked as a shared library libkconfig.so. C++ is not supported for
@@ -679,7 +679,7 @@ Both possibilities are described in the following.
 	In the example above the executable is composed of the C++ file
 	qconf.cc - identified by $(qconf-cxxobjs).
 
-	If qconf is composed by a mixture of .c and .cc files, then an
+	If qconf is composed of a mixture of .c and .cc files, then an
 	additional line can be used to identify this.
 
 	Example:
@@ -756,7 +756,7 @@ Both possibilities are described in the following.
 		hostprogs-$(CONFIG_KALLSYMS) += kallsyms
 
 	Kbuild knows about both 'y' for built-in and 'm' for module.
-	So if a config symbol evaluate to 'm', kbuild will still build
+	So if a config symbol evaluates to 'm', kbuild will still build
 	the binary. In other words, Kbuild handles hostprogs-m exactly
 	like hostprogs-y. But only hostprogs-y is recommended to be used
 	when no CONFIG symbols are involved.
@@ -777,8 +777,8 @@ Additional files can be specified in kbuild makefiles by use of $(clean-files).
 		#drivers/pci/Makefile
 		clean-files := devlist.h classlist.h
 
-When executing "make clean", the two files "devlist.h classlist.h" will
-be deleted. Kbuild will assume files to be in same relative directory as the
+When executing "make clean", the two files "devlist.h classlist.h" will be
+deleted. Kbuild will assume files to be in the same relative directory as the
 Makefile except if an absolute path is specified (path starting with '/').
 
 To delete a directory hierarchy use:
@@ -809,7 +809,7 @@ is not sufficient this sometimes needs to be explicit.
 The above assignment instructs kbuild to descend down in the
 directory compressed/ when "make clean" is executed.
 
-To support the clean infrastructure in the Makefiles that builds the
+To support the clean infrastructure in the Makefiles that build the
 final bootimage there is an optional target named archclean:
 
 	Example:
@@ -949,7 +949,7 @@ When kbuild executes, the following steps are followed (roughly):
 
     KBUILD_AFLAGS_MODULE   Options for $(AS) when building modules
 
-	$(KBUILD_AFLAGS_MODULE) is used to add arch specific options that
+	$(KBUILD_AFLAGS_MODULE) is used to add arch-specific options that
 	are used for $(AS).
 	From commandline AFLAGS_MODULE shall be used (see kbuild.txt).
 
@@ -960,13 +960,13 @@ When kbuild executes, the following steps are followed (roughly):
 
     KBUILD_CFLAGS_MODULE   Options for $(CC) when building modules
 
-	$(KBUILD_CFLAGS_MODULE) is used to add arch specific options that
+	$(KBUILD_CFLAGS_MODULE) is used to add arch-specific options that
 	are used for $(CC).
 	From commandline CFLAGS_MODULE shall be used (see kbuild.txt).
 
     KBUILD_LDFLAGS_MODULE   Options for $(LD) when linking modules
 
-	$(KBUILD_LDFLAGS_MODULE) is used to add arch specific options
+	$(KBUILD_LDFLAGS_MODULE) is used to add arch-specific options
 	used when linking modules. This is often a linker script.
 	From commandline LDFLAGS_MODULE shall be used (see kbuild.txt).
 
@@ -1088,7 +1088,7 @@ When kbuild executes, the following steps are followed (roughly):
 
     extra-y
 
-	extra-y specify additional targets created in the current
+	extra-y specifies additional targets created in the current
 	directory, in addition to any targets specified by obj-*.
 
 	Listing all targets in extra-y is required for two purposes:
@@ -1164,7 +1164,7 @@ When kbuild executes, the following steps are followed (roughly):
 		2) delete target during make clean
 
 	The ": %: %.o" part of the prerequisite is a shorthand that
-	free us from listing the setup.o and bootsect.o files.
+	frees us from listing the setup.o and bootsect.o files.
 	Note: It is a common mistake to forget the "targets :=" assignment,
 	      resulting in the target file being recompiled for no
 	      obvious reason.
@@ -1236,11 +1236,11 @@ When kbuild executes, the following steps are followed (roughly):
 	When building the *.lds target, kbuild uses the variables:
 	KBUILD_CPPFLAGS	: Set in top-level Makefile
 	cppflags-y	: May be set in the kbuild makefile
-	CPPFLAGS_$(@F)  : Target specific flags.
+	CPPFLAGS_$(@F)  : Target-specific flags.
 	                  Note that the full filename is used in this
 	                  assignment.
 
-	The kbuild infrastructure for *lds file are used in several
+	The kbuild infrastructure for *lds files is used in several
 	architecture-specific files.
 
 --- 6.10 Generic header files
@@ -1253,11 +1253,11 @@ When kbuild executes, the following steps are followed (roughly):
 
 === 7 Kbuild syntax for exported headers
 
-The kernel include a set of headers that is exported to userspace.
+The kernel includes a set of headers that is exported to userspace.
 Many headers can be exported as-is but other headers require a
 minimal pre-processing before they are ready for user-space.
 The pre-processing does:
-- drop kernel specific annotations
+- drop kernel-specific annotations
 - drop include of compiler.h
 - drop all sections that are kernel internal (guarded by ifdef __KERNEL__)
 
@@ -1267,7 +1267,7 @@ See subsequent chapter for the syntax of the Kbuild file.
 
 	--- 7.1 header-y
 
-	header-y specify header files to be exported.
+	header-y specifies header files to be exported.
 
 		Example:
 			#include/linux/Kbuild
@@ -1277,7 +1277,7 @@ See subsequent chapter for the syntax of the Kbuild file.
 	The convention is to list one file per line and
 	preferably in alphabetic order.
 
-	header-y also specify which subdirectories to visit.
+	header-y also specifies which subdirectories to visit.
 	A subdirectory is identified by a trailing '/' which
 	can be seen in the example above for the usb subdirectory.
 
@@ -1295,9 +1295,9 @@ See subsequent chapter for the syntax of the Kbuild file.
 
 	--- 7.3 destination-y
 
-	When an architecture have a set of exported headers that needs to be
+	When an architecture has a set of exported headers that needs to be
 	exported to a different directory destination-y is used.
-	destination-y specify the destination directory for all exported
+	destination-y specifies the destination directory for all exported
 	headers in the file where it is present.
 
 		Example:
@@ -1390,9 +1390,9 @@ The top Makefile exports the following variables:
 
     INSTALL_MOD_STRIP
 
-	If this variable is specified, will cause modules to be stripped
+	If this variable is specified, it will cause modules to be stripped
 	after they are installed.  If INSTALL_MOD_STRIP is '1', then the
-	default option --strip-debug will be used.  Otherwise,
+	default option --strip-debug will be used.  Otherwise, the
 	INSTALL_MOD_STRIP value will be used as the option(s) to the strip
 	command.
 
-- 
1.9.1

