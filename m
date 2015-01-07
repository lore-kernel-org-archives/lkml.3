Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbbAGRK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:10:59 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:56826 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbbAGRKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:10:34 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, Davidlohr Bueso <dave@stgolabs.net>,
        Davidlohr Bueso <dbueso@suse.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/3] documentation: Fix smp typo in memory-barriers.txt
Date: Wed,  7 Jan 2015 09:10:22 -0800
Message-Id: <1420650622-31241-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420650622-31241-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107170950.GA30629@linux.vnet.ibm.com>
 <1420650622-31241-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0033-0000-0000-0000033CF719
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@stgolabs.net>

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/memory-barriers.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index a10f7cd2619e..ca2387ef27ab 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -794,7 +794,7 @@ In summary:
       However, they do -not- guarantee any other sort of ordering:
       Not prior loads against later loads, nor prior stores against
       later anything.  If you need these other forms of ordering,
-      use smb_rmb(), smp_wmb(), or, in the case of prior stores and
+      use smp_rmb(), smp_wmb(), or, in the case of prior stores and
       later loads, smp_mb().
 
   (*) If both legs of the "if" statement begin with identical stores
-- 
1.8.1.5

