Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaFDTJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:09:42 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:59868 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaFDTIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:08:48 -0400
From: Jack Miller <millerjo@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mikey@au1.ibm.com, anton@au1.ibm.com, miltonm@us.ibm.com
Subject: [PATCH 3/3] shm: Remove unneeded extern for function
Date: Wed,  4 Jun 2014 14:07:48 -0500
Message-Id: <1401908868-14554-4-git-send-email-millerjo@us.ibm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401908868-14554-1-git-send-email-millerjo@us.ibm.com>
References: <1401908868-14554-1-git-send-email-millerjo@us.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060419-1542-0000-0000-00000255EF7D
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

