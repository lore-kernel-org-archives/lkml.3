Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbaJBQGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:06:11 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44689 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbaJBQGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:06:09 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: jcmvbkbc@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: highmem fix pointers
Date: Thu,  2 Oct 2014 17:06:00 +0100
Message-Id: <1412265960-3948-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pointers should be foo *bar

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 mm/highmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index 123bcd3..7543624 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -130,7 +130,7 @@ unsigned int nr_free_highpages (void)
 static int pkmap_count[LAST_PKMAP];
 static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(kmap_lock);
 
-pte_t * pkmap_page_table;
+pte_t *pkmap_page_table;
 
 /*
  * Most architectures have no use for kmap_high_get(), so let's abstract
-- 
1.9.1

