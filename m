Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbaEMWHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:07:16 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63273 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbaEMWFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:05:53 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        acme@ghostprotocols.net, dsahern@gmail.com, mingo@kernel.org
Subject: [PATCH 30/34] perf kbuild: update Kbuild files with new and removed sources
Date: Wed, 14 May 2014 00:03:25 +0200
Message-Id: <1400018609-20486-31-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
References: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 tools/perf/bench/Kbuild | 3 +++
 tools/perf/util/Kbuild  | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/bench/Kbuild b/tools/perf/bench/Kbuild
index 57f87e8..863646a 100644
--- a/tools/perf/bench/Kbuild
+++ b/tools/perf/bench/Kbuild
@@ -2,6 +2,9 @@ obj-y += mem-memcpy.o
 obj-y += mem-memset.o
 obj-y += sched-messaging.o
 obj-y += sched-pipe.o
+obj-y += futex-hash.o
+obj-y += futex-requeue.o
+obj-y += futex-wake.o
 
 obj-$(CONFIG_LIBNUMA) += numa.o
 
diff --git a/tools/perf/util/Kbuild b/tools/perf/util/Kbuild
index 234937f..6e02080 100644
--- a/tools/perf/util/Kbuild
+++ b/tools/perf/util/Kbuild
@@ -48,6 +48,8 @@ obj-y += string.o
 obj-y += strlist.o
 obj-y += svghelper.o
 obj-y += symbol.o
+obj-y += perf_regs.o
+
 
 obj-$(CONFIG_LIBUNWIND) += unwind-libunwind.o
 obj-$(CONFIG_LIBDWARF_UNWIND) += unwind-libdw.o
@@ -60,7 +62,6 @@ obj-$(CONFIG_LIBDWARF) += probe-finder.o
 
 obj-$(CONFIG_LIBELF_MINIMAL) += symbol-minimal.o
 
-obj-y += fs.o
 obj-y += target.o
 obj-y += thread.o
 obj-y += thread_map.o
-- 
1.9.2

