Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab3EaMhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:37:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57805 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3EaMhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:37:48 -0400
Date: Fri, 31 May 2013 05:37:03 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-0dce60f530eee32a3455a8a9c5edf6d286b769a7@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org, sam@ravnborg.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, bp@alien8.de, mingo@elte.hu
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com,
        a.p.zijlstra@chello.nl, sam@ravnborg.org, acme@ghostprotocols.net,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@kernel.org, bp@alien8.de,
        mingo@elte.hu
In-Reply-To: <1369398928-9809-25-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-25-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove '?=' Makefile STRIP assignment
Git-Commit-ID: 0dce60f530eee32a3455a8a9c5edf6d286b769a7
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

Commit-ID:  0dce60f530eee32a3455a8a9c5edf6d286b769a7
Gitweb:     http://git.kernel.org/tip/0dce60f530eee32a3455a8a9c5edf6d286b769a7
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 15 Apr 2013 04:49:43 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 30 May 2013 16:51:41 +0300

perf tools: Remove '?=' Makefile STRIP assignment

No need to use '?=' assignment for STRIP variable, the standard
'=' does the same job without creating confusion.

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Link: http://lkml.kernel.org/r/1369398928-9809-25-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ac52598..b5f5c6d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -82,7 +82,7 @@ FIND    = find
 INSTALL = install
 FLEX    = flex
 BISON   = bison
-STRIP  ?= strip
+STRIP   = strip
 
 LK_DIR          = $(srctree)/tools/lib/lk/
 TRACE_EVENT_DIR = $(srctree)/tools/lib/traceevent/
