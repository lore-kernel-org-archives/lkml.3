Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaI2NPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:15:48 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:34984 "EHLO
	homiemail-a99.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754053AbaI2NPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:15:02 -0400
From: Davidlohr Bueso <dave@stgolabs.net>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@kernel.org, dave@stgolabs.net,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 4/4] locktorture: Cleanup header usage
Date: Mon, 29 Sep 2014 06:14:26 -0700
Message-Id: <1411996466-11488-5-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1411996466-11488-1-git-send-email-dave@stgolabs.net>
References: <1411996466-11488-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some unnecessary ones and explicitly include rwsem.h

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/locktorture.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index b05dc46..ec8cce2 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -20,32 +20,20 @@
  * Author: Paul E. McKenney <paulmck@us.ibm.com>
  *	Based on kernel/rcu/torture.c.
  */
-#include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kthread.h>
-#include <linux/err.h>
 #include <linux/spinlock.h>
 #include <linux/rwlock.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/smp.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/atomic.h>
-#include <linux/bitops.h>
-#include <linux/completion.h>
 #include <linux/moduleparam.h>
-#include <linux/percpu.h>
-#include <linux/notifier.h>
-#include <linux/reboot.h>
-#include <linux/freezer.h>
-#include <linux/cpu.h>
 #include <linux/delay.h>
-#include <linux/stat.h>
 #include <linux/slab.h>
-#include <linux/trace_clock.h>
-#include <asm/byteorder.h>
 #include <linux/torture.h>
 
 MODULE_LICENSE("GPL");
-- 
1.8.4.5

