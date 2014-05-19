Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaESMzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:55:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59077 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaESMzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:55:39 -0400
Date: Mon, 19 May 2014 05:54:59 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-12665b35b0b48c9583ee1b8f0a403dc708fb4a92@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1399720259-28275-1-git-send-email-bp@alien8.de>
References: <1399720259-28275-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/events/core:
  Drop unused variable after cleanup
Git-Commit-ID: 12665b35b0b48c9583ee1b8f0a403dc708fb4a92
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12665b35b0b48c9583ee1b8f0a403dc708fb4a92
Gitweb:     http://git.kernel.org/tip/12665b35b0b48c9583ee1b8f0a403dc708fb4a92
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Sat, 10 May 2014 13:10:59 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 21:52:58 +0900

perf/events/core: Drop unused variable after cleanup

... in 3a497f48637 ("perf: Simplify perf_event_exit_task_context()")

Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1399720259-28275-1-git-send-email-bp@alien8.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7ab734f..ed50b09 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7431,7 +7431,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 
 static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 {
-	struct perf_event *child_event, *tmp;
+	struct perf_event *child_event;
 	struct perf_event_context *child_ctx;
 	unsigned long flags;
 
