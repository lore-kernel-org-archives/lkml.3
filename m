Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaHMK5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:57:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53366 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaHMK5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:57:40 -0400
Date: Wed, 13 Aug 2014 03:56:08 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-214e0aed639ef40987bf6159fad303171a6de31e@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        rdunlap@infradead.org, jason.low2@hp.com, airlied@linux.ie,
        standby24x7@gmail.com, clm@fb.com, viro@zeniv.linux.org.uk,
        gregkh@linuxfoundation.org, ddstreet@ieee.org,
        akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
        tglx@linutronix.de, davidlohr@hp.com, lkundrak@v3.sk,
        linux-kernel@vger.kernel.org, hpa@zytor.com,
        tim.c.chen@linux.intel.com, davem@davemloft.net,
        paulmck@linux.vnet.ibm.com, vgupta@synopsys.com, keescook@chromium.org,
        jbacik@fusionio.com, ast@plumgrid.com
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, rdunlap@infradead.org, airlied@linux.ie,
        jason.low2@hp.com, viro@zeniv.linux.org.uk, clm@fb.com,
        standby24x7@gmail.com, gregkh@linuxfoundation.org, ddstreet@ieee.org,
        akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
        tglx@linutronix.de, davidlohr@hp.com, lkundrak@v3.sk, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tim.c.chen@linux.intel.com,
        davem@davemloft.net, paulmck@linux.vnet.ibm.com, jbacik@fusionio.com,
        keescook@chromium.org, vgupta@synopsys.com, ast@plumgrid.com
In-Reply-To: <1406752916-3341-6-git-send-email-davidlohr@hp.com>
References: <1406752916-3341-6-git-send-email-davidlohr@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/Documentation:
  Move locking related docs into Documentation/locking/
Git-Commit-ID: 214e0aed639ef40987bf6159fad303171a6de31e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  214e0aed639ef40987bf6159fad303171a6de31e
Gitweb:     http://git.kernel.org/tip/214e0aed639ef40987bf6159fad303171a6de31e
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Wed, 30 Jul 2014 13:41:55 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Aug 2014 10:32:03 +0200

locking/Documentation: Move locking related docs into Documentation/locking/

Specifically:
  Documentation/locking/lockdep-design.txt
  Documentation/locking/lockstat.txt
  Documentation/locking/mutex-design.txt
  Documentation/locking/rt-mutex-design.txt
  Documentation/locking/rt-mutex.txt
  Documentation/locking/spinlocks.txt
  Documentation/locking/ww-mutex-design.txt

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: jason.low2@hp.com
Cc: aswin@hp.com
Cc: Alexei Starovoitov <ast@plumgrid.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jason Low <jason.low2@hp.com>
Cc: Josef Bacik <jbacik@fusionio.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lubomir Rintel <lkundrak@v3.sk>
Cc: Masanari Iida <standby24x7@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: fengguang.wu@intel.com
Link: http://lkml.kernel.org/r/1406752916-3341-6-git-send-email-davidlohr@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/00-INDEX                          |  2 ++
 Documentation/DocBook/kernel-locking.tmpl       |  2 +-
 Documentation/{ => locking}/lockdep-design.txt  |  0
 Documentation/{ => locking}/lockstat.txt        |  2 +-
 Documentation/{ => locking}/mutex-design.txt    |  0
 Documentation/{ => locking}/rt-mutex-design.txt |  0
 Documentation/{ => locking}/rt-mutex.txt        |  0
 Documentation/{ => locking}/spinlocks.txt       | 14 +++++++-------
 Documentation/{ => locking}/ww-mutex-design.txt |  0
 MAINTAINERS                                     |  4 ++--
 drivers/gpu/drm/drm_modeset_lock.c              |  2 +-
 include/linux/lockdep.h                         |  2 +-
 include/linux/mutex.h                           |  2 +-
 include/linux/rwsem.h                           |  2 +-
 kernel/locking/mutex.c                          |  2 +-
 kernel/locking/rtmutex.c                        |  2 +-
 lib/Kconfig.debug                               |  4 ++--
 17 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 27e67a9..1750fce 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -287,6 +287,8 @@ local_ops.txt
 	- semantics and behavior of local atomic operations.
 lockdep-design.txt
 	- documentation on the runtime locking correctness validator.
+locking/
+	- directory with info about kernel locking primitives
 lockstat.txt
 	- info on collecting statistics on locks (and contention).
 lockup-watchdogs.txt
diff --git a/Documentation/DocBook/kernel-locking.tmpl b/Documentation/DocBook/kernel-locking.tmpl
index e584ee1..7c9cc48 100644
--- a/Documentation/DocBook/kernel-locking.tmpl
+++ b/Documentation/DocBook/kernel-locking.tmpl
@@ -1972,7 +1972,7 @@ machines due to caching.
    <itemizedlist>
     <listitem>
      <para>
-       <filename>Documentation/spinlocks.txt</filename>: 
+       <filename>Documentation/locking/spinlocks.txt</filename>:
        Linus Torvalds' spinlocking tutorial in the kernel sources.
      </para>
     </listitem>
diff --git a/Documentation/lockdep-design.txt b/Documentation/locking/lockdep-design.txt
similarity index 100%
rename from Documentation/lockdep-design.txt
rename to Documentation/locking/lockdep-design.txt
diff --git a/Documentation/lockstat.txt b/Documentation/locking/lockstat.txt
similarity index 99%
rename from Documentation/lockstat.txt
rename to Documentation/locking/lockstat.txt
index 72d0106..7428773 100644
--- a/Documentation/lockstat.txt
+++ b/Documentation/locking/lockstat.txt
@@ -12,7 +12,7 @@ Because things like lock contention can severely impact performance.
 - HOW
 
 Lockdep already has hooks in the lock functions and maps lock instances to
-lock classes. We build on that (see Documentation/lockdep-design.txt).
+lock classes. We build on that (see Documentation/lokcing/lockdep-design.txt).
 The graph below shows the relation between the lock functions and the various
 hooks therein.
 
diff --git a/Documentation/mutex-design.txt b/Documentation/locking/mutex-design.txt
similarity index 100%
rename from Documentation/mutex-design.txt
rename to Documentation/locking/mutex-design.txt
diff --git a/Documentation/rt-mutex-design.txt b/Documentation/locking/rt-mutex-design.txt
similarity index 100%
rename from Documentation/rt-mutex-design.txt
rename to Documentation/locking/rt-mutex-design.txt
diff --git a/Documentation/rt-mutex.txt b/Documentation/locking/rt-mutex.txt
similarity index 100%
rename from Documentation/rt-mutex.txt
rename to Documentation/locking/rt-mutex.txt
diff --git a/Documentation/spinlocks.txt b/Documentation/locking/spinlocks.txt
similarity index 98%
rename from Documentation/spinlocks.txt
rename to Documentation/locking/spinlocks.txt
index 97eaf57..ff35e40 100644
--- a/Documentation/spinlocks.txt
+++ b/Documentation/locking/spinlocks.txt
@@ -105,9 +105,9 @@ never used in interrupt handlers, you can use the non-irq versions:
 	spin_unlock(&lock);
 
 (and the equivalent read-write versions too, of course). The spinlock will
-guarantee the same kind of exclusive access, and it will be much faster. 
+guarantee the same kind of exclusive access, and it will be much faster.
 This is useful if you know that the data in question is only ever
-manipulated from a "process context", ie no interrupts involved. 
+manipulated from a "process context", ie no interrupts involved.
 
 The reasons you mustn't use these versions if you have interrupts that
 play with the spinlock is that you can get deadlocks:
@@ -122,21 +122,21 @@ the other interrupt happens on another CPU, but it is _not_ ok if the
 interrupt happens on the same CPU that already holds the lock, because the
 lock will obviously never be released (because the interrupt is waiting
 for the lock, and the lock-holder is interrupted by the interrupt and will
-not continue until the interrupt has been processed). 
+not continue until the interrupt has been processed).
 
 (This is also the reason why the irq-versions of the spinlocks only need
 to disable the _local_ interrupts - it's ok to use spinlocks in interrupts
 on other CPU's, because an interrupt on another CPU doesn't interrupt the
 CPU that holds the lock, so the lock-holder can continue and eventually
-releases the lock). 
+releases the lock).
 
 Note that you can be clever with read-write locks and interrupts. For
 example, if you know that the interrupt only ever gets a read-lock, then
 you can use a non-irq version of read locks everywhere - because they
-don't block on each other (and thus there is no dead-lock wrt interrupts. 
-But when you do the write-lock, you have to use the irq-safe version. 
+don't block on each other (and thus there is no dead-lock wrt interrupts.
+But when you do the write-lock, you have to use the irq-safe version.
 
-For an example of being clever with rw-locks, see the "waitqueue_lock" 
+For an example of being clever with rw-locks, see the "waitqueue_lock"
 handling in kernel/sched/core.c - nothing ever _changes_ a wait-queue from
 within an interrupt, they only read the queue in order to know whom to
 wake up. So read-locks are safe (which is good: they are very common
diff --git a/Documentation/ww-mutex-design.txt b/Documentation/locking/ww-mutex-design.txt
similarity index 100%
rename from Documentation/ww-mutex-design.txt
rename to Documentation/locking/ww-mutex-design.txt
diff --git a/MAINTAINERS b/MAINTAINERS
index 1acc624..aac481f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5523,8 +5523,8 @@ M:	Ingo Molnar <mingo@redhat.com>
 L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core/locking
 S:	Maintained
-F:	Documentation/lockdep*.txt
-F:	Documentation/lockstat.txt
+F:	Documentation/locking/lockdep*.txt
+F:	Documentation/locking/lockstat.txt
 F:	include/linux/lockdep.h
 F:	kernel/locking/
 
diff --git a/drivers/gpu/drm/drm_modeset_lock.c b/drivers/gpu/drm/drm_modeset_lock.c
index 0dc57d5..3a02e5e 100644
--- a/drivers/gpu/drm/drm_modeset_lock.c
+++ b/drivers/gpu/drm/drm_modeset_lock.c
@@ -35,7 +35,7 @@
  * of extra utility/tracking out of our acquire-ctx.  This is provided
  * by drm_modeset_lock / drm_modeset_acquire_ctx.
  *
- * For basic principles of ww_mutex, see: Documentation/ww-mutex-design.txt
+ * For basic principles of ww_mutex, see: Documentation/locking/ww-mutex-design.txt
  *
  * The basic usage pattern is to:
  *
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 008388f9..f388481 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -4,7 +4,7 @@
  *  Copyright (C) 2006,2007 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
  *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
  *
- * see Documentation/lockdep-design.txt for more details.
+ * see Documentation/locking/lockdep-design.txt for more details.
  */
 #ifndef __LINUX_LOCKDEP_H
 #define __LINUX_LOCKDEP_H
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index e4c2941..cc31498 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -133,7 +133,7 @@ static inline int mutex_is_locked(struct mutex *lock)
 
 /*
  * See kernel/locking/mutex.c for detailed documentation of these APIs.
- * Also see Documentation/mutex-design.txt.
+ * Also see Documentation/locking/mutex-design.txt.
  */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 035d3c5..8f498cd 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -149,7 +149,7 @@ extern void downgrade_write(struct rw_semaphore *sem);
  * static then another method for expressing nested locking is
  * the explicit definition of lock class keys and the use of
  * lockdep_set_class() at lock initialization time.
- * See Documentation/lockdep-design.txt for more details.)
+ * See Documentation/locking/lockdep-design.txt for more details.)
  */
 extern void down_read_nested(struct rw_semaphore *sem, int subclass);
 extern void down_write_nested(struct rw_semaphore *sem, int subclass);
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 0d8b6ed..dadbf88 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -15,7 +15,7 @@
  *    by Steven Rostedt, based on work by Gregory Haskins, Peter Morreale
  *    and Sven Dietrich.
  *
- * Also see Documentation/mutex-design.txt.
+ * Also see Documentation/locking/mutex-design.txt.
  */
 #include <linux/mutex.h>
 #include <linux/ww_mutex.h>
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index a0ea2a1..7c98873 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -8,7 +8,7 @@
  *  Copyright (C) 2005 Kihon Technologies Inc., Steven Rostedt
  *  Copyright (C) 2006 Esben Nielsen
  *
- *  See Documentation/rt-mutex-design.txt for details.
+ *  See Documentation/locking/rt-mutex-design.txt for details.
  */
 #include <linux/spinlock.h>
 #include <linux/export.h>
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 901096d..9b94a06 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -924,7 +924,7 @@ config PROVE_LOCKING
 	 the proof of observed correctness is also maintained for an
 	 arbitrary combination of these separate locking variants.
 
-	 For more details, see Documentation/lockdep-design.txt.
+	 For more details, see Documentation/locking/lockdep-design.txt.
 
 config LOCKDEP
 	bool
@@ -945,7 +945,7 @@ config LOCK_STAT
 	help
 	 This feature enables tracking lock contention points
 
-	 For more details, see Documentation/lockstat.txt
+	 For more details, see Documentation/locking/lockstat.txt
 
 	 This also enables lock events required by "perf lock",
 	 subcommand of perf.
