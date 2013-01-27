Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3A0AQO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:16:14 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:35419 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab3A0AQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:16:12 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/10] rcu: Correct 'optimized' to 'optimize' in header comment
Date: Sat, 26 Jan 2013 16:15:08 -0800
Message-Id: <1359245712-3843-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1359245712-3843-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130127001454.GA2682@linux.vnet.ibm.com>
 <1359245712-3843-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012700-7408-0000-0000-00000C401665
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

Small grammar fix in rcutree comment regarding 'rcu_scheduler_active'
var.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e0d9815..d78ba60 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -105,7 +105,7 @@ int rcu_num_nodes __read_mostly = NUM_RCU_NODES; /* Total # rcu_nodes in use. */
  * The rcu_scheduler_active variable transitions from zero to one just
  * before the first task is spawned.  So when this variable is zero, RCU
  * can assume that there is but one task, allowing RCU to (for example)
- * optimized synchronize_sched() to a simple barrier().  When this variable
+ * optimize synchronize_sched() to a simple barrier().  When this variable
  * is one, RCU must actually do all the hard work required to detect real
  * grace periods.  This variable is also used to suppress boot-time false
  * positives from lockdep-RCU error checking.
-- 
1.7.8

