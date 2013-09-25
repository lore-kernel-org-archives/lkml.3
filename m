Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab3IYBRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:17:49 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44400 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab3IYBRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:17:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/3] rcu: Fix occurrence of "the the" in checklist.txt
Date: Tue, 24 Sep 2013 18:17:23 -0700
Message-Id: <1380071843-30362-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380071843-30362-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925011657.GA29958@linux.vnet.ibm.com>
 <1380071843-30362-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-9332-0000-0000-000001875398
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/checklist.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index 7703ec7..ad6cba4 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -203,7 +203,7 @@ over a rather long period of time, but improvements are always welcome!
 	the corresponding readers must disable preemption, possibly
 	by calling rcu_read_lock_sched() and rcu_read_unlock_sched().
 	If the updater uses synchronize_srcu() or call_srcu(),
-	the the corresponding readers must use srcu_read_lock() and
+	the corresponding readers must use srcu_read_lock() and
 	srcu_read_unlock(), and with the same srcu_struct.  The rules for
 	the expedited primitives are the same as for their non-expedited
 	counterparts.  Mixing things up will result in confusion and
-- 
1.8.1.5

