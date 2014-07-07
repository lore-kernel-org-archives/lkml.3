Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaGGWYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:24:51 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:41469 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaGGWYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:24:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/4] documentation: Add pointer to percpu-ref for RCU and refcount
Date: Mon,  7 Jul 2014 15:24:22 -0700
Message-Id: <1404771862-6904-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404771862-6904-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707222345.GA6320@linux.vnet.ibm.com>
 <1404771862-6904-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-7164-0000-0000-000002F4739B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/rcuref.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/RCU/rcuref.txt b/Documentation/RCU/rcuref.txt
index 141d531aa14b..613033ff2b9b 100644
--- a/Documentation/RCU/rcuref.txt
+++ b/Documentation/RCU/rcuref.txt
@@ -1,5 +1,14 @@
 Reference-count design for elements of lists/arrays protected by RCU.
 
+
+Please note that the percpu-ref feature is likely your first
+stop if you need to combine reference counts and RCU.  Please see
+include/linux/percpu-refcount.h for more information.  However, in
+those unusual cases where percpu-ref would consume too much memory,
+please read on.
+
+------------------------------------------------------------------------
+
 Reference counting on elements of lists which are protected by traditional
 reader/writer spinlocks or semaphores are straightforward:
 
-- 
1.8.1.5

