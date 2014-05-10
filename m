Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbaEJLLE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 07:11:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46818 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaEJLLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 07:11:02 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] perf/events/core: Drop unused variable after cleanup
Date: Sat, 10 May 2014 13:10:59 +0200
Message-Id: <1399720259-28275-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... in 3a497f48637 ("perf: Simplify perf_event_exit_task_context()")

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7ab734fbaeeb..ed50b0943213 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7431,7 +7431,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 
 static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 {
-	struct perf_event *child_event, *tmp;
+	struct perf_event *child_event;
 	struct perf_event_context *child_ctx;
 	unsigned long flags;
 
-- 
1.9.0

