Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab3CRVRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:17:24 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56071 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932447Ab3CRVRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:17:20 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, Jiang Fang <jiang.xx.fang@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/7] rcu: Fix spacing problem
Date: Mon, 18 Mar 2013 14:16:50 -0700
Message-Id: <1363641416-18642-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20130318211615.GA15814@linux.vnet.ibm.com>
References: <20130318211615.GA15814@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031821-7182-0000-0000-000005D7BF45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Fang <jiang.xx.fang@gmail.com>

Signed-off-by: Jiang Fang <jiang.xx.fang@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5b8ad82..157539a 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -3171,7 +3171,7 @@ void __init rcu_init(void)
 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
 	__rcu_init_preempt();
 	rcu_init_nocb();
-	 open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 
 	/*
 	 * We don't need protection against CPU-hotplug here because
-- 
1.8.1.5

