Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbaEERt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:49:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53089 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbaEERtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:49:25 -0400
Date: Mon, 5 May 2014 10:48:09 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-8be26c539f0d4c77a798b20515ad6404d72de74d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, acme@kernel.org,
        namhyung@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de, bp@suse.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1399293219-8732-3-git-send-email-jolsa@kernel.org>
References: <1399293219-8732-3-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove unlikely define from perf.h
Git-Commit-ID: 8be26c539f0d4c77a798b20515ad6404d72de74d
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

Commit-ID:  8be26c539f0d4c77a798b20515ad6404d72de74d
Gitweb:     http://git.kernel.org/tip/8be26c539f0d4c77a798b20515ad6404d72de74d
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 5 May 2014 12:32:05 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 5 May 2014 17:46:10 +0200

perf tools: Remove unlikely define from perf.h

It's defined in tools/include/linux/compiler.h header.

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1399293219-8732-3-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/perf.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 3bea2e6..a547f38 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -203,7 +203,6 @@ static inline unsigned long long rdclock(void)
  */
 #define asmlinkage
 
-#define unlikely(x)	__builtin_expect(!!(x), 0)
 #define min(x, y) ({				\
 	typeof(x) _min1 = (x);			\
 	typeof(y) _min2 = (y);			\
