Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692AbaDHSGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:06:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757128AbaDHSBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:01:31 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 02/10] perf top: Fix documentation of invalid -s option
Date: Tue,  8 Apr 2014 20:01:00 +0200
Message-Id: <1396980068-27124-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1396980068-27124-1-git-send-email-jolsa@redhat.com>
References: <1396980068-27124-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

On perf top, the -s option is used for --sort, but the man page
contains invalid documentation of -s option for --sym-annotate.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1395193578-27098-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Documentation/perf-top.txt | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index cdd8d49..976b00c 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -87,7 +87,6 @@ Default is to monitor all CPUS.
 --realtime=<priority>::
 	Collect data with this RT SCHED_FIFO priority.
 
--s <symbol>::
 --sym-annotate=<symbol>::
         Annotate this symbol.
 
-- 
1.8.3.1

