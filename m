Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbbAGRKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:10:36 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:35425 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbbAGRKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:10:34 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, Xie XiuQi <xiexiuqi@huawei.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/3] documentation: Update sysfs path for rcu_cpu_stall_timeout
Date: Wed,  7 Jan 2015 09:10:20 -0800
Message-Id: <1420650622-31241-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20150107170950.GA30629@linux.vnet.ibm.com>
References: <20150107170950.GA30629@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0017-0000-0000-000007BD3C00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xie XiuQi <xiexiuqi@huawei.com>

Commit 6bfc09e2327d ("rcu: Provide RCU CPU stall warnings for tiny RCU")
moved the rcu_cpu_stall_timeout module parameter from rcutree.c to
rcupdate.c, but failed to update Documentation/RCU/stallwarn.txt. This
commit therefore repairs this omission.

commit 96224daa16d6 ("documentation: Update sysfs path for rcu_cpu_stall_suppress")
updated the path for rcu_cpu_stall_suppress, but failed to update for
rcu_cpu_stall_timeout.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/stallwarn.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index ed186a902d31..4f8e33952b88 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -15,7 +15,7 @@ CONFIG_RCU_CPU_STALL_TIMEOUT
 	21 seconds.
 
 	This configuration parameter may be changed at runtime via the
-	/sys/module/rcutree/parameters/rcu_cpu_stall_timeout, however
+	/sys/module/rcupdate/parameters/rcu_cpu_stall_timeout, however
 	this parameter is checked only at the beginning of a cycle.
 	So if you are 10 seconds into a 40-second stall, setting this
 	sysfs parameter to (say) five will shorten the timeout for the
-- 
1.8.1.5

