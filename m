Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaCCJgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 04:36:32 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47861 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbaCCJg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 04:36:29 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: sjenning@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] mm: zswap: remove unnecessary parentheses
Date: Mon,  3 Mar 2014 18:37:56 +0900
Message-Id: <1393839476-24989-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following trivial checkpatch error:
	ERROR: return is not a function, parentheses are not required

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 mm/zswap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index c0c9b7c..34b75cc 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -204,7 +204,7 @@ static struct kmem_cache *zswap_entry_cache;
 static int zswap_entry_cache_create(void)
 {
 	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);
-	return (zswap_entry_cache == NULL);
+	return zswap_entry_cache == NULL;
 }
 
 static void zswap_entry_cache_destory(void)
@@ -408,8 +408,8 @@ cleanup:
 **********************************/
 static bool zswap_is_full(void)
 {
-	return (totalram_pages * zswap_max_pool_percent / 100 <
-		zswap_pool_pages);
+	return totalram_pages * zswap_max_pool_percent / 100 <
+		zswap_pool_pages;
 }
 
 /*********************************
-- 
1.8.3.2

