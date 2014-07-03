Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366AbaGCQPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:15:03 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:16237 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932231AbaGCQM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:29 -0400
Message-Id: <20140703161227.010531021@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 21/21] tracing: Add description of set_graph_notrace to tracing/README
References: <20140703160503.006976702@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0021-tracing-Add-description-of-set_graph_notrace-to-trac.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

It was missing the description of set_graph_notrace file.  Add it.

Link: http://lkml.kernel.org/p/1402590233-22321-5-git-send-email-namhyung@kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4caa814d41c3..822f6a0894f7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3663,6 +3663,7 @@ static const char readme_msg[] =
 #endif
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	"  set_graph_function\t- Trace the nested calls of a function (function_graph)\n"
+	"  set_graph_notrace\t- Do not trace the nested calls of a function (function_graph)\n"
 	"  max_graph_depth\t- Trace a limited depth of nested calls (0 is unlimited)\n"
 #endif
 #ifdef CONFIG_TRACER_SNAPSHOT
-- 
2.0.0


