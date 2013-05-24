Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336Ab3EXHYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 03:24:23 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:49177 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab3EXHYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 03:24:22 -0400
From: Harsh Prateek Bora <harsh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, rostedt@goodmis.org
Cc: srikar@linux.vnet.ibm.com, Harsh Prateek Bora <harsh@linux.vnet.ibm.com>
Subject: [PATCH] tracing: code cleanup
Date: Fri, 24 May 2013 12:52:17 +0530
Message-Id: <1369380137-12452-1-git-send-email-harsh@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052418-3568-0000-0000-000003AA6834
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Harsh Prateek Bora <harsh@linux.vnet.ibm.com>
---
 kernel/trace/trace_events.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 7a0cf68..371c7b0 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2011,10 +2011,7 @@ event_enable_func(struct ftrace_hash *hash,
 	int ret;
 
 	/* hash funcs only work with set_ftrace_filter */
-	if (!enabled)
-		return -EINVAL;
-
-	if (!param)
+	if (!enabled || !param)
 		return -EINVAL;
 
 	system = strsep(&param, ":");
-- 
1.7.11.7

