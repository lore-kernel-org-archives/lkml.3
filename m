Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbaJBPe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:34:26 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34201 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbaJBPeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:34:25 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: akpm@linux-foundation.org, hughd@google.com, gorcunov@openvz.org,
        kirill.shutemov@linux.intel.com, riel@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: fremap use linux header
Date: Thu,  2 Oct 2014 16:34:17 +0100
Message-Id: <1412264057-3146-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use #include <linux/mmu_context.h> instead of <asm/mmu_context.h>

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 mm/fremap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/fremap.c b/mm/fremap.c
index 72b8fa3..d614f1c 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -1,6 +1,6 @@
 /*
  *   linux/mm/fremap.c
- * 
+ *
  * Explicit pagetable population and nonlinear (random) mappings support.
  *
  * started by Ingo Molnar, Copyright (C) 2002, 2003
@@ -16,8 +16,8 @@
 #include <linux/rmap.h>
 #include <linux/syscalls.h>
 #include <linux/mmu_notifier.h>
+#include <linux/mmu_context.h>
 
-#include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
-- 
1.9.1

