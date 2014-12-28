Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaL1JOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 04:14:18 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:44336 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaL1JMS (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Sun, 28 Dec 2014 04:12:18 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Davidlohr Bueso <dave@stgolabs.net>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 4/8] locking/mutex: Delete useless comment
Date: Sun, 28 Dec 2014 01:11:19 -0800
Message-Id: <1419757883-4423-5-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1419757883-4423-1-git-send-email-dave@stgolabs.net>
References: <1419757883-4423-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/mutex.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 3252a7d..caa3c9f 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -197,13 +197,7 @@ ww_mutex_set_context_fastpath(struct ww_mutex *lock,
  * In order to avoid a stampede of mutex spinners from acquiring the mutex
  * more or less simultaneously, the spinners need to acquire a MCS lock
  * first before spinning on the owner field.
- *
  */
-
-/*
- * Mutex spinning code migrated from kernel/sched/core.c
- */
-
 static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
 {
 	if (lock->owner != owner)
-- 
2.1.2

