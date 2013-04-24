Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab3DXJkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:40:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758544Ab3DXJjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:39:37 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>, Sam Ravnborg <sam@ravnborg.org>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 25/26] perf tools: Remove '?=' Makefile STRIP assignment
Date: Wed, 24 Apr 2013 11:37:52 +0200
Message-Id: <1366796273-4780-26-git-send-email-jolsa@redhat.com>
In-Reply-To: <1366796273-4780-1-git-send-email-jolsa@redhat.com>
References: <1366796273-4780-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to use '?=' assignment for STRP variable, the standard
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
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6ee3868..763da02 100644
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
-- 
1.7.11.7

