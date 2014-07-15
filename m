Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbaGORIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:08:18 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:39850 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbaGORCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:20 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Helge Deller <deller@gmx.de>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 86/94] parisc: drop unused defines and header includes
Date: Tue, 15 Jul 2014 20:01:41 +0300
Message-Id: <1405443709-15288-86-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Helge Deller <deller@gmx.de>

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # 3.13+
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/parisc/kernel/sys_parisc32.c |   36 ------------------------------------
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
1.7.10.4

