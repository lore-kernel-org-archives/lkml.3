Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836AbaGOWbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:31:51 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:37875 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019AbaGOWb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 18:31:27 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list:READ-COPY UPDATE...)
Subject: [PATCH 2/3] rcu: Remove stale comment in tree.c
Date: Tue, 15 Jul 2014 18:31:48 -0400
Message-Id: <1405463509-2468-2-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405463509-2468-1-git-send-email-bobby.prani@gmail.com>
References: <1405463509-2468-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit removes a stale comment in rcu/tree.c.
FYI, an updated comment exists a few lines below this.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index a1abaa8..e67246e 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2211,8 +2211,6 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 	/* Adjust any no-longer-needed kthreads. */
 	rcu_boost_kthread_setaffinity(rnp, -1);
 
-	/* Remove the dead CPU from the bitmasks in the rcu_node hierarchy. */
-
 	/* Exclude any attempts to start a new grace period. */
 	mutex_lock(&rsp->onoff_mutex);
 	raw_spin_lock_irqsave(&rsp->orphan_lock, flags);
-- 
1.9.1

