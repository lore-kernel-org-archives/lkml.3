Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965188AbaFQRcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:32:33 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:47749 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933524AbaFQR2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:28:45 -0400
From: Jack Miller <millerjo@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, davidlohr@hp.com, miltonm@us.ibm.com,
        anton@au1.ibm.com
Subject: [PATCH 3/3] shm: Remove unneeded extern for function
Date: Tue, 17 Jun 2014 12:27:47 -0500
Message-Id: <1403026067-14272-4-git-send-email-millerjo@us.ibm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403026067-14272-1-git-send-email-millerjo@us.ibm.com>
References: <1403026067-14272-1-git-send-email-millerjo@us.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061717-8236-0000-0000-0000032B6548
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A small cleanup while changing adjacent code.  Extern is not needed
for functions and only one declaration had it so remove it from the
odd line.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Jack Miller <millerjo@us.ibm.com>
---
 include/linux/shm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/shm.h b/include/linux/shm.h
index 38a70a2..e0daca0 100644
--- a/include/linux/shm.h
+++ b/include/linux/shm.h
@@ -53,7 +53,7 @@ struct sysv_shm {
 
 long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr,
 	      unsigned long shmlba);
-extern int is_file_shm_hugepages(struct file *file);
+int is_file_shm_hugepages(struct file *file);
 void exit_shm(struct task_struct *task);
 #define shm_init_task(task) INIT_LIST_HEAD(&(task)->sysvshm.shm_clist)
 #else
-- 
1.9.1

