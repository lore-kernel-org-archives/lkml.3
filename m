Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039AbaDJSqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:46:22 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:48445 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758618AbaDJSqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:46:21 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, aquini@redhat.com
Subject: [PATCH 04/15] ipc:sem Remove whitespace
Date: Thu, 10 Apr 2014 19:46:16 +0100
Message-Id: <1397155576-6472-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: trailing whitespace

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 ipc/sem.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 3bbfa6c..64a8bba 100644
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
@@ -1181,7 +1181,7 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
 		}
 		max_id = ipc_get_maxid(&sem_ids(ns));
 		up_read(&sem_ids(ns).rwsem);
-		if (copy_to_user(p, &seminfo, sizeof(struct seminfo))) 
+		if (copy_to_user(p, &seminfo, sizeof(struct seminfo)))
 			return -EFAULT;
 		return (max_id < 0) ? 0 : max_id;
 	}
@@ -1883,7 +1883,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	/* We need to sleep on this operation, so we put the current
 	 * task into the pending queue and go to sleep.
 	 */
-		
+
 	queue.sops = sops;
 	queue.nsops = nsops;
 	queue.undo = un;
@@ -2016,7 +2016,7 @@ int copy_semundo(unsigned long clone_flags, struct task_struct *tsk)
 			return error;
 		atomic_inc(&undo_list->refcnt);
 		tsk->sysvsem.undo_list = undo_list;
-	} else 
+	} else
 		tsk->sysvsem.undo_list = NULL;
 
 	return 0;
-- 
1.8.3.2

