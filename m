Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbaLRGcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:32:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58718 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbaLRGcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:32:03 -0500
Date: Wed, 17 Dec 2014 22:31:27 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-mvfu6x753tksnto3t6412m93@git.kernel.org>
Cc: eranian@google.com, dsahern@gmail.com, tglx@linutronix.de,
        dzickus@redhat.com, jolsa@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, namhyung@kernel.org,
        hpa@zytor.com, acme@redhat.com, fweisbec@gmail.com, bp@suse.de,
        peterz@infradead.org, adrian.hunter@intel.com, efault@gmx.de
Reply-To: eranian@google.com, dsahern@gmail.com, paulus@samba.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, jolsa@redhat.com,
        dzickus@redhat.com, tglx@linutronix.de, fweisbec@gmail.com,
        peterz@infradead.org, bp@suse.de, namhyung@kernel.org, acme@redhat.com,
        hpa@zytor.com, efault@gmx.de, adrian.hunter@intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools: Move bitops.h from tools/perf/
 util to tools/
Git-Commit-ID: 3967278496ffa69704b941745de393223406a83d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3967278496ffa69704b941745de393223406a83d
Gitweb:     http://git.kernel.org/tip/3967278496ffa69704b941745de393223406a83d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 16 Dec 2014 10:55:42 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Dec 2014 11:17:53 -0300

tools: Move bitops.h from tools/perf/util to tools/

So that we better mirror the kernel sources and make it available for
other tools.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-mvfu6x753tksnto3t6412m93@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/{perf/util => }/include/linux/bitops.h | 0
 tools/perf/MANIFEST                          | 1 +
 tools/perf/Makefile.perf                     | 2 +-
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/include/linux/bitops.h b/tools/include/linux/bitops.h
similarity index 100%
rename from tools/perf/util/include/linux/bitops.h
rename to tools/include/linux/bitops.h
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 86f115c..7729af9 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -10,6 +10,7 @@ tools/include/asm-generic/bitops/atomic.h
 tools/include/asm-generic/bitops/__ffs.h
 tools/include/asm-generic/bitops/find.h
 tools/include/asm-generic/bitops.h
+tools/include/linux/bitops.h
 tools/include/linux/compiler.h
 tools/include/linux/export.h
 tools/include/linux/hash.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 3a73a95..28e590e 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -231,7 +231,7 @@ LIB_H += ../../include/uapi/linux/const.h
 LIB_H += ../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
-LIB_H += util/include/linux/bitops.h
+LIB_H += ../include/linux/bitops.h
 LIB_H += ../include/asm-generic/bitops/atomic.h
 LIB_H += ../include/asm-generic/bitops/find.h
 LIB_H += ../include/asm-generic/bitops/__ffs.h
