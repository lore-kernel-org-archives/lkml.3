Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaAKRtY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 12:49:24 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:44243 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbaAKRtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 12:49:18 -0500
From: Yann Droneaud <ydroneaud@opteya.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] perf tools: add .gitignore for files generated for feature check
Date: Sat, 11 Jan 2014 18:48:16 +0100
Message-Id: <faf3b2dfbe992bc3d088c1420a6721a6b7c2019d.1389461371.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <cover.1389461371.git.ydroneaud@opteya.com>
References: <cover.1389461371.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1389461371.git.ydroneaud@opteya.com>
References: <cover.1389461371.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of system features auto-detection, some dependency files are
generated and some programs are built.

These files should not be considered by git, so this patch adds
a dedicated .gitignore in tools/perf/config/ sub-directory to
ignore the files.

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 tools/perf/config/feature-checks/.gitignore | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 tools/perf/config/feature-checks/.gitignore

diff --git a/tools/perf/config/feature-checks/.gitignore b/tools/perf/config/feature-checks/.gitignore
new file mode 100644
index 000000000000..53b84b102c78
--- /dev/null
+++ b/tools/perf/config/feature-checks/.gitignore
@@ -0,0 +1,28 @@
+*.d
+test-all
+test-backtrace
+test-bionic
+test-cplus-demangle
+test-dwarf
+test-fortify-source
+test-glibc
+test-gtk2
+test-gtk2-infobar
+test-hello
+test-libaudit
+test-libbfd
+test-libelf
+test-libelf-getphdrnum
+test-libelf-mmap
+test-liberty
+test-liberty-z
+test-libnuma
+test-libperl
+test-libpython
+test-libpython-version
+test-libslang
+test-libunwind
+test-libunwind-debug-frame
+test-on-exit
+test-stackprotector-all
+test-timerfd
-- 
1.8.4.2

