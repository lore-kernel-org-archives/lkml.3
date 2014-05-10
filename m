Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbaEJKDp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 06:03:45 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:65445 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaEJKDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 06:03:42 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, 1vier1@web.de,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 1/6] ipc/sem.c: further whitespace cleanups
Date: Sat, 10 May 2014 12:03:14 +0200
Message-Id: <1399716199-26776-2-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399716199-26776-1-git-send-email-manfred@colorfullife.com>
References: <1399716199-26776-1-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somehow <TAB>$ was overlooked in the last round of whitespace
cleanups.
Do that now, before making further changes.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index bee5554..5749b9c 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -160,7 +160,7 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it);
  *	sem_array.pending{_alter,_cont},
  *	sem_array.sem_undo: global sem_lock() for read/write
  *	sem_undo.proc_next: only "current" is allowed to read/write that field.
- *	
+ *
  *	sem_array.sem_base[i].pending_{const,alter}:
  *		global or semaphore sem_lock() for read/write
  */
@@ -1161,7 +1161,7 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
 		err = security_sem_semctl(NULL, cmd);
 		if (err)
 			return err;
-		
+
 		memset(&seminfo, 0, sizeof(seminfo));
 		seminfo.semmni = ns->sc_semmni;
 		seminfo.semmns = ns->sc_semmns;
@@ -1883,7 +1883,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	/* We need to sleep on this operation, so we put the current
 	 * task into the pending queue and go to sleep.
 	 */
-		
+
 	queue.sops = sops;
 	queue.nsops = nsops;
 	queue.undo = un;
-- 
1.9.0

