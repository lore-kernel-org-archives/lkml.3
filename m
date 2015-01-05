Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbbAEKhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:37:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:46168 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbbAEKhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:37:35 -0500
Message-Id: <20150105103554.495253233@infradead.org>
User-Agent: quilt/0.61-1
Date: Mon, 05 Jan 2015 11:18:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, umgwanakikbuti@gmail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        "Peter Zijlstra" <peterz@infradead.org>
Subject: [RFC][PATCH 3/3] sched,debug: Print clock_task
References: <20150105101809.860964488@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-sched-debug-clock_task.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We seem to have forgotten adding it to the debug output like
forever... do so now.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/sched/debug.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -305,6 +305,7 @@ do {									\
 	PN(next_balance);
 	SEQ_printf(m, "  .%-30s: %ld\n", "curr->pid", (long)(task_pid_nr(rq->curr)));
 	PN(clock);
+	PN(clock_task);
 	P(cpu_load[0]);
 	P(cpu_load[1]);
 	P(cpu_load[2]);


