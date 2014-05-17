Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135AbaEQS6B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 14:58:01 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:33513 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862AbaEQS6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 14:58:00 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgYVAIuwd1NbsnYM/2dsb2JhbABZgwaCQn2nMwQBBQUBmicCAoEJF3SCZhwjGIECJBOIRQHRKYVViBdkhEcBA48viioBkxqDOTswgQE
Date: Sat, 17 May 2014 20:57:55 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/1 linux-next] kernel/events/core.c: remove unused variable
 tmp
Message-Id: <20140517205755.a0d9706a5e779a3223cf22a1@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tmp is no longer used in perf_event_exit_task_context since

3a497f48637e2a
"perf: Simplify perf_event_exit_task_context()"

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 49ac18c..244d70a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7432,7 +7432,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 
 static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 {
-	struct perf_event *child_event, *tmp;
+	struct perf_event *child_event;
 	struct perf_event_context *child_ctx;
 	unsigned long flags;
 
-- 
1.8.4.5

