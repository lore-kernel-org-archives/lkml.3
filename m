Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab3JNUXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:23:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39012 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705Ab3JNUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 135/161] perf tools: Align perf version output to other build messages
Date: Mon, 14 Oct 2013 17:02:04 -0300
Message-Id: <1381780950-25642-136-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Before:

  CC util/pmu.o
  CC util/parse-events.o
PERF_VERSION = 3.12.rc4.g1b30c
  CC util/parse-events-flex.o
  GEN perf-archive

After:

  CC util/pmu.o
  CC util/parse-events.o
  PERF_VERSION = 3.12.rc4.g1b30c
  CC util/parse-events-flex.o
  GEN perf-archive

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1381312169-17354-4-git-send-email-mingo@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/PERF-VERSION-GEN | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index 15a77b7c0e36..ce7a804b2951 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -40,7 +40,7 @@ else
 	VC=unset
 fi
 test "$VN" = "$VC" || {
-	echo >&2 "PERF_VERSION = $VN"
+	echo >&2 "  PERF_VERSION = $VN"
 	echo "#define PERF_VERSION \"$VN\"" >$GVF
 }
 
-- 
1.8.1.4

