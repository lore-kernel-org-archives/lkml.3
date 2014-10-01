Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaJAO3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:29:51 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37498 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaJAO3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:29:50 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, walken@google.com,
        kirill.shutemov@linux.intel.com, hughd@google.com,
        akpm@linux-foundation.org
Subject: [PATCH] MM: mremap use linux headers
Date: Wed,  1 Oct 2014 15:29:30 +0100
Message-Id: <1412173770-4420-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>"

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 mm/mremap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 05f1180..f970f02 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -21,8 +21,8 @@
 #include <linux/syscalls.h>
 #include <linux/mmu_notifier.h>
 #include <linux/sched/sysctl.h>
+#include <linux/uaccess.h>
 
-#include <asm/uaccess.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
-- 
1.9.1

