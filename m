Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaCCBPA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 20:15:00 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:61734 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaCCBO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 20:14:28 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-02-5313d770c05c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 13/13] perf tools: Show absolute percentage by default
Date: Mon,  3 Mar 2014 10:14:14 +0900
Message-Id: <1393809254-4480-14-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1393809254-4480-1-git-send-email-namhyung@kernel.org>
References: <1393809254-4480-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now perf report will show absolute percentage on filter entries by
default.

Suggested-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/symbol.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 233681e304dd..0ada68b3b096 100644
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

