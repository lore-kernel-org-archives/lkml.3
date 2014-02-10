Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaBJCst (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:48:49 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:58726 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbaBJCre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:47:34 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-ca-52f83dc32cf3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 7/7] perf tools: Show absolute percentage by default
Date: Mon, 10 Feb 2014 11:47:24 +0900
Message-Id: <1392000446-14744-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1392000446-14744-1-git-send-email-namhyung@kernel.org>
References: <1392000446-14744-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now perf report will show absolute percentage on filter entries by
default.

Suggested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/symbol.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b888cb241164..a9d758a3b371 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -33,7 +33,6 @@ struct symbol_conf symbol_conf = {
 	.try_vmlinux_path = true,
 	.annotate_src	  = true,
 	.demangle	  = true,
-	.filter_relative  = true,
 	.symfs            = "",
 };
 
-- 
1.7.11.7

