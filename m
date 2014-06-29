Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbaF2KWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 06:22:18 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61321 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbaF2KVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 06:21:48 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org
Subject: [PATCH -trivial 3/4] mm: memcontrol: Spelling s/invlidate/invalidate/, s/trucate/truncate/
Date: Sun, 29 Jun 2014 12:21:38 +0200
Message-Id: <1404037299-31570-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404037299-31570-1-git-send-email-geert@linux-m68k.org>
References: <1404037299-31570-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a2c7bcb0e6eb..2c010573668e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4034,7 +4034,7 @@ void mem_cgroup_uncharge_cache_page(struct page *page)
 }
 
 /*
- * Batch_start/batch_end is called in unmap_page_range/invlidate/trucate.
+ * Batch_start/batch_end is called in unmap_page_range/invalidate/truncate.
  * In that cases, pages are freed continuously and we can expect pages
  * are in the same memcg. All these calls itself limits the number of
  * pages freed at once, then uncharge_start/end() is called properly.
-- 
1.9.1

