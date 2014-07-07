Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaGGWYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:24:38 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56313 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaGGWYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:24:36 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Pranith Kumar <bobby.prani@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/4] documentation: Update reference, kerneltrap.org no longer works
Date: Mon,  7 Jul 2014 15:24:20 -0700
Message-Id: <1404771862-6904-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404771862-6904-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707222345.GA6320@linux.vnet.ibm.com>
 <1404771862-6904-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-0928-0000-0000-00000338803F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

The kerneltrap.org site no longer works, so this commit updates it to
a working reference, namely gmane.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/RTFP.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/RCU/RTFP.txt b/Documentation/RCU/RTFP.txt
index 2f0fcb2112d2..f29bcbc463e7 100644
--- a/Documentation/RCU/RTFP.txt
+++ b/Documentation/RCU/RTFP.txt
@@ -2451,8 +2451,8 @@ lot of {Linux} into your technology!!!"
 ,month="February"
 ,year="2010"
 ,note="Available:
-\url{http://kerneltrap.com/mailarchive/linux-netdev/2010/2/26/6270589}
-[Viewed March 20, 2011]"
+\url{http://thread.gmane.org/gmane.linux.network/153338}
+[Viewed June 9, 2014]"
 ,annotation={
 	Use a pair of list_head structures to support RCU-protected
 	resizable hash tables.
-- 
1.8.1.5

