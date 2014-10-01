Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaJAPff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:35:35 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:64494 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbaJAPfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:35:32 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: akpm@linux-foundation.org, walken@google.com, hughd@google.com,
        hannes@cmpxchg.org, aarcange@redhat.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MM: mremap use linux headers
Date: Wed,  1 Oct 2014 16:35:25 +0100
Message-Id: <1412177725-2715-1-git-send-email-paulmcquad@gmail.com>
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

