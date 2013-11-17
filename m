Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab3KQDMw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 22:12:52 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:51436 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab3KQDMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 22:12:44 -0500
Date: Sun, 17 Nov 2013 12:12:36 +0900 (JST)
Message-Id: <20131117.121236.1990617639803941055.shigeru.yoshida@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix a trivial typo in comments.
From: Shigeru Yoshida <shigeru.yoshida@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a trivial typo in rq_attach_root.

Signed-off-by: Shigeru Yoshida <shigeru.yoshida@gmail.com>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5ac63c9..2bc3bc0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4985,7 +4985,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 		cpumask_clear_cpu(rq->cpu, old_rd->span);
 
 		/*
-		 * If we dont want to free the old_rt yet then
+		 * If we dont want to free the old_rd yet then
 		 * set old_rd to NULL to skip the freeing later
 		 * in this function:
 		 */
-- 
1.8.3.2

