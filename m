Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab3KSTQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:16:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51695 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab3KSTQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:16:23 -0500
Date: Tue, 19 Nov 2013 11:15:52 -0800
From: tip-bot for Shigeru Yoshida <tipbot@zytor.com>
Message-ID: <tip-0515973ffb16c2852a1bb1df2ca1456556faaaa5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, shigeru.yoshida@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, shigeru.yoshida@gmail.com
In-Reply-To: <20131117.121236.1990617639803941055.shigeru.yoshida@gmail.com>
References: <20131117.121236.1990617639803941055.shigeru.yoshida@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix a trivial typo in comments
Git-Commit-ID: 0515973ffb16c2852a1bb1df2ca1456556faaaa5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 19 Nov 2013 11:15:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0515973ffb16c2852a1bb1df2ca1456556faaaa5
Gitweb:     http://git.kernel.org/tip/0515973ffb16c2852a1bb1df2ca1456556faaaa5
Author:     Shigeru Yoshida <shigeru.yoshida@gmail.com>
AuthorDate: Sun, 17 Nov 2013 12:12:36 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 19 Nov 2013 17:01:18 +0100

sched: Fix a trivial typo in comments

Fix a trivial typo in rq_attach_root().

Signed-off-by: Shigeru Yoshida <shigeru.yoshida@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131117.121236.1990617639803941055.shigeru.yoshida@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a1591ca..718730d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4762,7 +4762,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 		cpumask_clear_cpu(rq->cpu, old_rd->span);
 
 		/*
-		 * If we dont want to free the old_rt yet then
+		 * If we dont want to free the old_rd yet then
 		 * set old_rd to NULL to skip the freeing later
 		 * in this function:
 		 */
