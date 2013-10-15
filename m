Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab3JOFUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:20:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60880 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab3JOFUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:20:18 -0400
Date: Mon, 14 Oct 2013 22:19:58 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-20c99e82173bed9e4e0013ec45c0b2b3b80b65d5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build:
  Harmonize the style of the feature testcases
Git-Commit-ID: 20c99e82173bed9e4e0013ec45c0b2b3b80b65d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:20:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20c99e82173bed9e4e0013ec45c0b2b3b80b65d5
Gitweb:     http://git.kernel.org/tip/20c99e82173bed9e4e0013ec45c0b2b3b80b65d5
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 7 Oct 2013 13:27:23 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:49:03 +0200

tools/perf/build: Harmonize the style of the feature testcases

The various testcases used different styles, which was not really
visible as long as they hid in feature-tests.mak. Now that they
are out in the open make them prettier.

( Also delete the leftover, empty feature-tests.mak file. )

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-drDWk8xltndjdsespzjbhu6w@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/feature-checks/test-backtrace.c         | 1 -
 tools/perf/config/feature-checks/test-cplus-demangle.c    | 1 -
 tools/perf/config/feature-checks/test-dwarf.c             | 1 +
 tools/perf/config/feature-checks/test-glibc.c             | 2 +-
 tools/perf/config/feature-checks/test-libaudit.c          | 1 +
 tools/perf/config/feature-checks/test-libbfd.c            | 1 -
 tools/perf/config/feature-checks/test-libelf-getphdrnum.c | 3 ++-
 tools/perf/config/feature-checks/test-libelf-mmap.c       | 3 ++-
 tools/perf/config/feature-checks/test-libelf.c            | 1 +
 tools/perf/config/feature-checks/test-libnuma.c           | 1 +
 tools/perf/config/feature-checks/test-libpython.c         | 3 ++-
 tools/perf/config/feature-tests.mak                       | 2 --
 12 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/tools/perf/config/feature-checks/test-backtrace.c b/tools/perf/config/feature-checks/test-backtrace.c
index 5b33bcf..7124aa1 100644
--- a/tools/perf/config/feature-checks/test-backtrace.c
+++ b/tools/perf/config/feature-checks/test-backtrace.c
@@ -11,4 +11,3 @@ int main(void)
 
 	return 0;
 }
-
diff --git a/tools/perf/config/feature-checks/test-cplus-demangle.c b/tools/perf/config/feature-checks/test-cplus-demangle.c
index ab29f80..610c686 100644
--- a/tools/perf/config/feature-checks/test-cplus-demangle.c
+++ b/tools/perf/config/feature-checks/test-cplus-demangle.c
@@ -12,4 +12,3 @@ int main(void)
 
 	return 0;
 }
-
diff --git a/tools/perf/config/feature-checks/test-dwarf.c b/tools/perf/config/feature-checks/test-dwarf.c
index 783dfcd..3fc1801 100644
--- a/tools/perf/config/feature-checks/test-dwarf.c
+++ b/tools/perf/config/feature-checks/test-dwarf.c
@@ -5,5 +5,6 @@
 int main(void)
 {
 	Dwarf *dbg = dwarf_begin(0, DWARF_C_READ);
+
 	return (long)dbg;
 }
diff --git a/tools/perf/config/feature-checks/test-glibc.c b/tools/perf/config/feature-checks/test-glibc.c
index 13c66a5..b082034 100644
--- a/tools/perf/config/feature-checks/test-glibc.c
+++ b/tools/perf/config/feature-checks/test-glibc.c
@@ -3,6 +3,6 @@
 int main(void)
 {
 	const char *version = gnu_get_libc_version();
+
 	return (long)version;
 }
-
diff --git a/tools/perf/config/feature-checks/test-libaudit.c b/tools/perf/config/feature-checks/test-libaudit.c
index f7e791e..afc019f 100644
--- a/tools/perf/config/feature-checks/test-libaudit.c
+++ b/tools/perf/config/feature-checks/test-libaudit.c
@@ -5,5 +5,6 @@ extern int printf(const char *format, ...);
 int main(void)
 {
 	printf("error message: %s\n", audit_errno_to_name(0));
+
 	return audit_open();
 }
diff --git a/tools/perf/config/feature-checks/test-libbfd.c b/tools/perf/config/feature-checks/test-libbfd.c
index 1886c78..2405990 100644
--- a/tools/perf/config/feature-checks/test-libbfd.c
+++ b/tools/perf/config/feature-checks/test-libbfd.c
@@ -13,4 +13,3 @@ int main(void)
 
 	return 0;
 }
-
diff --git a/tools/perf/config/feature-checks/test-libelf-getphdrnum.c b/tools/perf/config/feature-checks/test-libelf-getphdrnum.c
index 58eca53..d710459 100644
--- a/tools/perf/config/feature-checks/test-libelf-getphdrnum.c
+++ b/tools/perf/config/feature-checks/test-libelf-getphdrnum.c
@@ -1,7 +1,8 @@
 #include <libelf.h>
-#
+
 int main(void)
 {
 	size_t dst;
+
 	return elf_getphdrnum(0, &dst);
 }
diff --git a/tools/perf/config/feature-checks/test-libelf-mmap.c b/tools/perf/config/feature-checks/test-libelf-mmap.c
index 1c64815..564427d 100644
--- a/tools/perf/config/feature-checks/test-libelf-mmap.c
+++ b/tools/perf/config/feature-checks/test-libelf-mmap.c
@@ -1,7 +1,8 @@
 #include <libelf.h>
-#
+
 int main(void)
 {
 	Elf *elf = elf_begin(0, ELF_C_READ_MMAP, 0);
+
 	return (long)elf;
 }
diff --git a/tools/perf/config/feature-checks/test-libelf.c b/tools/perf/config/feature-checks/test-libelf.c
index 1a08f97..08db322 100644
--- a/tools/perf/config/feature-checks/test-libelf.c
+++ b/tools/perf/config/feature-checks/test-libelf.c
@@ -3,5 +3,6 @@
 int main(void)
 {
 	Elf *elf = elf_begin(0, ELF_C_READ, 0);
+
 	return (long)elf;
 }
diff --git a/tools/perf/config/feature-checks/test-libnuma.c b/tools/perf/config/feature-checks/test-libnuma.c
index 70510a9..4763d9c 100644
--- a/tools/perf/config/feature-checks/test-libnuma.c
+++ b/tools/perf/config/feature-checks/test-libnuma.c
@@ -4,5 +4,6 @@
 int main(void)
 {
 	numa_available();
+
 	return 0;
 }
diff --git a/tools/perf/config/feature-checks/test-libpython.c b/tools/perf/config/feature-checks/test-libpython.c
index 7226797..b24b28a 100644
--- a/tools/perf/config/feature-checks/test-libpython.c
+++ b/tools/perf/config/feature-checks/test-libpython.c
@@ -1,7 +1,8 @@
 #include <Python.h>
-#
+
 int main(void)
 {
 	Py_Initialize();
+
 	return 0;
 }
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
deleted file mode 100644
index 139597f..0000000
--- a/tools/perf/config/feature-tests.mak
+++ /dev/null
@@ -1,2 +0,0 @@
-
-
