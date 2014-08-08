Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301AbaHHUyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:54:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41529 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261AbaHHUy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:54:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Helge Deller <deller@gmx.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 105/259] parisc: drop unused defines and header includes
Date: Fri,  8 Aug 2014 13:38:48 -0700
Message-Id: <1407530482-4483-106-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit fe22ddcb9f271d2af0e72d2743726cf28085b1dd upstream.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/parisc/kernel/sys_parisc32.c | 36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/arch/parisc/kernel/sys_parisc32.c b/arch/parisc/kernel/sys_parisc32.c
index ec741fe..93c1963 100644
--- a/arch/parisc/kernel/sys_parisc32.c
+++ b/arch/parisc/kernel/sys_parisc32.c
@@ -12,44 +12,8 @@
 
 #include <linux/compat.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/fs.h> 
-#include <linux/mm.h> 
-#include <linux/file.h> 
-#include <linux/signal.h>
-#include <linux/resource.h>
-#include <linux/times.h>
-#include <linux/time.h>
-#include <linux/smp.h>
-#include <linux/sem.h>
-#include <linux/shm.h>
-#include <linux/slab.h>
-#include <linux/uio.h>
-#include <linux/ncp_fs.h>
-#include <linux/poll.h>
-#include <linux/personality.h>
-#include <linux/stat.h>
-#include <linux/highmem.h>
-#include <linux/highuid.h>
-#include <linux/mman.h>
-#include <linux/binfmts.h>
-#include <linux/namei.h>
-#include <linux/vfs.h>
-#include <linux/ptrace.h>
-#include <linux/swap.h>
 #include <linux/syscalls.h>
 
-#include <asm/types.h>
-#include <asm/uaccess.h>
-#include <asm/mmu_context.h>
-
-#undef DEBUG
-
-#ifdef DEBUG
-#define DBG(x)	printk x
-#else
-#define DBG(x)
-#endif
 
 asmlinkage long sys32_unimplemented(int r26, int r25, int r24, int r23,
 	int r22, int r21, int r20)
-- 
1.9.1

