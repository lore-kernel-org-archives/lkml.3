Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbbANOEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:04:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36913 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbbANOEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:04:11 -0500
Date: Wed, 14 Jan 2015 06:03:44 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-5a5375977b721503e4d6b37ab8982902cd2d10b3@git.kernel.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de
Reply-To: tglx@linutronix.de, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, peterz@infradead.org,
        mingo@kernel.org
In-Reply-To: <20150105103554.495253233@infradead.org>
References: <20150105103554.495253233@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/debug: Print rq->clock_task
Git-Commit-ID: 5a5375977b721503e4d6b37ab8982902cd2d10b3
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

Commit-ID:  5a5375977b721503e4d6b37ab8982902cd2d10b3
Gitweb:     http://git.kernel.org/tip/5a5375977b721503e4d6b37ab8982902cd2d10b3
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 5 Jan 2015 11:18:12 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 14 Jan 2015 13:34:22 +0100

sched/debug: Print rq->clock_task

We seem to have forgotten adding it to the debug output like
forever... do so now.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20150105103554.495253233@infradead.org
Cc: umgwanakikbuti@gmail.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 92cc520..8baaf85 100644
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
