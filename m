Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbaD1X6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:58:15 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:43920 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbaD1X4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:56:44 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Iulia Manda <iulia.manda21@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/19] rcu: Remove "extern" from function declaration in include/linux/rcupdate.h
Date: Mon, 28 Apr 2014 16:56:21 -0700
Message-Id: <1398729392-15087-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140428235600.GA12200@linux.vnet.ibm.com>
 <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-1344-0000-0000-00000134CB14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Iulia Manda <iulia.manda21@gmail.com>

Because functions have the extern storage class specifier by default,
this keyword can be removed. It is redundant to use it explicitly.

Signed-off-by: Iulia Manda <iulia.manda21@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 00a7fd61b3c6..fdc422f3d61d 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -328,7 +328,7 @@ extern struct lockdep_map rcu_lock_map;
 extern struct lockdep_map rcu_bh_lock_map;
 extern struct lockdep_map rcu_sched_lock_map;
 extern struct lockdep_map rcu_callback_map;
-extern int debug_lockdep_rcu_enabled(void);
+int debug_lockdep_rcu_enabled(void);
 
 /**
  * rcu_read_lock_held() - might we be in RCU read-side critical section?
-- 
1.8.1.5

