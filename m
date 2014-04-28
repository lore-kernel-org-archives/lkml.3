Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbaD1X6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:58:09 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:40178 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbaD1X4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:56:44 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Pranith Kumar <pranith@gatech.edu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 17/19] rcu: Remove duplicate resched_cpu() declaration
Date: Mon, 28 Apr 2014 16:56:30 -0700
Message-Id: <1398729392-15087-17-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140428235600.GA12200@linux.vnet.ibm.com>
 <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-1542-0000-0000-00000169B428
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <pranith@gatech.edu>

Signed-off-by: Pranith Kumar <pranith@gatech.edu>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index dbf43f5c86fa..ecd7e046de76 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -975,12 +975,6 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	force_quiescent_state(rsp);  /* Kick them all. */
 }
 
-/*
- * This function really isn't for public consumption, but RCU is special in
- * that context switches can allow the state machine to make progress.
- */
-extern void resched_cpu(int cpu);
-
 static void print_cpu_stall(struct rcu_state *rsp)
 {
 	int cpu;
-- 
1.8.1.5

