Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbaFLQYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:24:09 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:58577 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbaFLQYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:24:07 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] tracing: Add description of set_graph_notrace to tracing/README
Date: Fri, 13 Jun 2014 01:23:53 +0900
Message-Id: <1402590233-22321-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1402590233-22321-1-git-send-email-namhyung@kernel.org>
References: <1402590233-22321-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was missing the description of set_graph_notrace file.  Add it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 384ede311717..a5f1f8f10645 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3687,6 +3687,7 @@ static const char readme_msg[] =
 #endif
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	"  set_graph_function\t- Trace the nested calls of a function (function_graph)\n"
+	"  set_graph_notrace\t- Do not trace the nested calls of a function (function_graph)\n"
 	"  max_graph_depth\t- Trace a limited depth of nested calls (0 is unlimited)\n"
 #endif
 #ifdef CONFIG_TRACER_SNAPSHOT
-- 
1.7.9.2

