Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbaD1Xbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:31:41 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34555 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757086AbaD1Xar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:30:47 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/3] documentation: Update sysfs path for rcu_cpu_stall_suppress
Date: Mon, 28 Apr 2014 16:30:38 -0700
Message-Id: <1398727840-11521-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20140428233013.GA10816@linux.vnet.ibm.com>
References: <20140428233013.GA10816@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-6688-0000-0000-0000016C68B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Commit 6bfc09e2327d (rcu: Provide RCU CPU stall warnings for tiny RCU)
moved the rcu_cpu_stall_suppress module parameter from rcutree.c to
rcupdate.c, but failed to update Documentation/RCU/stallwarn.txt.  This
commit therefore repairs this omission.

Reported-by: Kirill Tkhai <tkhai@yandex.ru>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/stallwarn.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 6f3a0057548e..68fe3ad27015 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -24,7 +24,7 @@ CONFIG_RCU_CPU_STALL_TIMEOUT
 	timing of the next warning for the current stall.
 
 	Stall-warning messages may be enabled and disabled completely via
-	/sys/module/rcutree/parameters/rcu_cpu_stall_suppress.
+	/sys/module/rcupdate/parameters/rcu_cpu_stall_suppress.
 
 CONFIG_RCU_CPU_STALL_VERBOSE
 
-- 
1.8.1.5

