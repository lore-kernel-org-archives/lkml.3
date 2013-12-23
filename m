Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab3LWI44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 03:56:56 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:48668 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab3LWI4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 03:56:36 -0500
From: Stefan Beller <stefanbeller@googlemail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: Stefan Beller <stefanbeller@googlemail.com>
Subject: [PATCH] perf tools: Ignore feature tests
Date: Mon, 23 Dec 2013 09:56:32 +0100
Message-Id: <1387788992-11536-1-git-send-email-stefanbeller@googlemail.com>
X-Mailer: git-send-email 1.8.5.1.109.g3d252a9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The binaries to be ignored are created by
	linux/tools $ make perf

Signed-off-by: Stefan Beller <stefanbeller@googlemail.com>
---
 tools/perf/config/feature-checks/.gitignore | 43 +++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 tools/perf/config/feature-checks/.gitignore

diff --git a/tools/perf/config/feature-checks/.gitignore b/tools/perf/config/feature-checks/.gitignore
new file mode 100644
index 0000000..6f92dcd
--- /dev/null
+++ b/tools/perf/config/feature-checks/.gitignore
@@ -0,0 +1,43 @@
+test-all.d
+test-backtrace
+test-backtrace.d
+test-dwarf
+test-dwarf.d
+test-fortify-source
+test-fortify-source.d
+test-glibc
+test-glibc.d
+test-gtk2
+test-gtk2-infobar
+test-gtk2-infobar.d
+test-gtk2.d
+test-libaudit
+test-libaudit.d
+test-libbfd
+test-libbfd.d
+test-libelf
+test-libelf-getphdrnum
+test-libelf-getphdrnum.d
+test-libelf-mmap
+test-libelf-mmap.d
+test-libelf.d
+test-libnuma
+test-libnuma.d
+test-libperl.d
+test-libpython
+test-libpython-version
+test-libpython-version.d
+test-libpython.d
+test-libslang
+test-libslang.d
+test-libunwind
+test-libunwind.d
+test-on-exit
+test-on-exit.d
+test-stackprotector
+test-stackprotector-all
+test-stackprotector-all.d
+test-stackprotector.d
+test-timerfd
+test-timerfd.d
+
-- 
1.8.5.1.109.g3d252a9

