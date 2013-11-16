Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab3KPAY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:24:59 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:47854 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab3KPAX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:23:56 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/16] rcu: Fix srcu_barrier() docbook header
Date: Fri, 15 Nov 2013 16:23:27 -0800
Message-Id: <1384561418-30575-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116002316.GA29049@linux.vnet.ibm.com>
 <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-0928-0000-0000-000003BD0D30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The srcu_barrier() docbook header left out the "sp" argument, so this
commit adds that argument's docbook text.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/srcu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/rcu/srcu.c b/kernel/rcu/srcu.c
index 01d5ccb8bfe3..0f0c63111f20 100644
--- a/kernel/rcu/srcu.c
+++ b/kernel/rcu/srcu.c
@@ -491,6 +491,7 @@ EXPORT_SYMBOL_GPL(synchronize_srcu_expedited);
 
 /**
  * srcu_barrier - Wait until all in-flight call_srcu() callbacks complete.
+ * @sp: srcu_struct on which to wait for in-flight callbacks.
  */
 void srcu_barrier(struct srcu_struct *sp)
 {
-- 
1.8.1.5

