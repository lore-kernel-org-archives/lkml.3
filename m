Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaLRGbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:31:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58675 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbaLRGbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:31:07 -0500
Date: Wed, 17 Dec 2014 22:30:30 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-6xmwcvgm2rvoayv2mf9n5sf8@git.kernel.org>
Cc: dzickus@redhat.com, adrian.hunter@intel.com, tglx@linutronix.de,
        jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        efault@gmx.de, dsahern@gmail.com, eranian@google.com,
        peterz@infradead.org, acme@redhat.com, paulus@samba.org,
        mingo@kernel.org, bp@suse.de, hpa@zytor.com, fweisbec@gmail.com
Reply-To: namhyung@kernel.org, linux-kernel@vger.kernel.org, dsahern@gmail.com,
        efault@gmx.de, jolsa@redhat.com, tglx@linutronix.de,
        adrian.hunter@intel.com, dzickus@redhat.com, fweisbec@gmail.com,
        hpa@zytor.com, mingo@kernel.org, paulus@samba.org, acme@redhat.com,
        bp@suse.de, peterz@infradead.org, eranian@google.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools:
  Whitespace prep patches for moving bitops.h
Git-Commit-ID: 93c49b3e535659102aa1ca28b775b48e3594036c
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

Commit-ID:  93c49b3e535659102aa1ca28b775b48e3594036c
Gitweb:     http://git.kernel.org/tip/93c49b3e535659102aa1ca28b775b48e3594036c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 15 Dec 2014 17:08:00 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Dec 2014 11:11:56 -0300

tools: Whitespace prep patches for moving bitops.h

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
Link: http://lkml.kernel.org/n/tip-6xmwcvgm2rvoayv2mf9n5sf8@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/include/linux/bitops.h | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index 71f017d..58c4a25 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -10,13 +10,14 @@
 #endif
 
 #define BITS_PER_LONG __WORDSIZE
-#define BITS_PER_BYTE           8
-#define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
-#define BITS_TO_U64(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
-#define BITS_TO_U32(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
-#define BITS_TO_BYTES(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE)
-#define BIT_WORD(nr)            ((nr) / BITS_PER_LONG)
-#define BIT_MASK(nr)            (1UL << ((nr) % BITS_PER_LONG))
+
+#define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
+#define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
+#define BITS_PER_BYTE		8
+#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
+#define BITS_TO_U64(nr)		DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
+#define BITS_TO_U32(nr)		DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
+#define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE)
 
 #define for_each_set_bit(bit, addr, size) \
 	for ((bit) = find_first_bit((addr), (size));		\
