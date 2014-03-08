Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaCHDqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 22:46:12 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:60821 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaCHDqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 22:46:10 -0500
From: Choi Gi-yong <yong@gnoy.org>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, Choi Gi-yong <yong@gnoy.org>
Subject: [PATCH] mm: Fix Coding style
Date: Sat,  8 Mar 2014 12:46:01 +0900
Message-Id: <1394250361-5151-1-git-send-email-yong@gnoy.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Choi Gi-yong <yong@gnoy.org>
---
 mm/percpu.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 036cfe0..6528ffa 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -72,7 +72,7 @@
 #include <asm/cacheflush.h>
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 #define PCPU_SLOT_BASE_SHIFT		5	/* 1-31 shares the same slot */
 #define PCPU_DFL_MAP_ALLOC		16	/* start a map with 16 ents */
@@ -715,7 +715,7 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
 
 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
 		WARN(true, "illegal size (%zu) or align (%zu) for "
-		     "percpu allocation\n", size, align);
+				"percpu allocation\n", size, align);
 		return NULL;
 	}
 
@@ -968,8 +968,8 @@ bool is_kernel_percpu_address(unsigned long addr)
 		void *start = per_cpu_ptr(base, cpu);
 
 		if ((void *)addr >= start && (void *)addr < start + static_size)
-			return true;
-        }
+		return true;
+       }
 #endif
 	/* on UP, can't distinguish from other static vars, always false */
 	return false;
@@ -1929,8 +1929,7 @@ void __init setup_per_cpu_areas(void)
  */
 void __init percpu_init_late(void)
 {
-	struct pcpu_chunk *target_chunks[] =
-		{ pcpu_first_chunk, pcpu_reserved_chunk, NULL };
+	struct pcpu_chunk *target_chunks[] = { pcpu_first_chunk, pcpu_reserved_chunk, NULL };
 	struct pcpu_chunk *chunk;
 	unsigned long flags;
 	int i;
-- 
1.8.3.2

