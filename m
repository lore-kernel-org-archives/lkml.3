Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162716AbaDCI5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:57:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13419 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162584AbaDCI5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:57:41 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-da-533d2260b24e
From: Heesub Shin <heesub.shin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Heesub Shin <heesub.shin@samsung.com>,
        Dongjun Shin <d.j.shin@samsung.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>
Subject: [PATCH 1/2] mm/compaction: clean up unused code lines
Date: Thu, 03 Apr 2014 17:57:03 +0900
Message-id: <1396515424-18794-1-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zLd0EJdtgg5c3xC3mrF/DZnHiYq3F
	wdlLmCwu75rDZnFvzX9Wi8nvnjFanO5YxOrA7rHp0yR2jxMzfrN49G1Zxeix+XS1x+dNcgGs
	UVw2Kak5mWWpRfp2CVwZL75YF3znrpjWeZStgfE6ZxcjJ4eEgInE3AcXmCBsMYkL99azdTFy
	cQgJLGOU2HPxPRtM0YNJd9ghEtMZJfb2b4Zy2pkkmidfZ+1i5OBgE9CWOLQtGKRBREBXYtXz
	XcwgNcwCpxklJndcYwVJCAvYSTxYcZMZxGYRUJX4fms2WJxXwF3iytN+FohtChLLvqxlhrCb
	2SUuHEmAqBeQ+Db5EAvILgkBWYlNB6BKJCUOrrjBMoFRcAEjwypG0dSC5ILipPQiU73ixNzi
	0rx0veT83E2MkICduIPx/gHrQ4zJQOMmMkuJJucDAz6vJN7Q2MzIwtTE1NjI3NKMNGElcd70
	R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhiPH1y1beE8kYlODoYLtPZyOv9t8VXawfP5
	rFrSqvO6fAxzHC76LaiwfTC9aMFf/YU+8xNmlWe6xnDXMMgd3GC48N/c/zZ+vaIOdUHPg81O
	dq+u1Z6U8a7gqAv3k7k86cXb3rnpXFoV8HbjZsWEqPl7V9hVffAoc9WLLtfzz9w2I2Tyye23
	U98rsRRnJBpqMRcVJwIAz9KMr24CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQd0EJdtgg9XLhS3mrF/DZnHiYq3F
	wdlLmCwu75rDZnFvzX9Wi8nvnjFanO5YxOrA7rHp0yR2jxMzfrN49G1Zxeix+XS1x+dNcgGs
	UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVygp
	lCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM158sS74zl0xrfMoWwPjdc4u
	Rk4OCQETiQeT7rBD2GISF+6tZ+ti5OIQEpjOKLG3fzM7hNPOJNE8+TprFyMHB5uAtsShbcEg
	DSICuhKrnu9iBqlhFjjNKDG54xorSEJYwE7iwYqbzCA2i4CqxPdbs8HivALuElee9rNAbFOQ
	WPZlLfMERu4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYIj4pnUDsaVDRaHGAU4GJV4
	eC2kbIKFWBPLiitzDzFKcDArifBe/AIU4k1JrKxKLcqPLyrNSS0+xJgMtH0is5Rocj4wWvNK
	4g2NTcyMLI3MjE3MjY1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgXH/qtPlBWpzJpWk
	s1SV2qWmPbk30X7uKoc9H6Oe6MxcMivv3IT/ews83a6tXDO35aezEqfB5b2/i6ZveMDEl9zl
	4trVqyKp6GGXueGhstzktkmH72721z+rtufZRzPO9vWCnCVzGuJ28q/N6fM9K2SuExsXp3/g
	VoNn3qJne4LW9UXJK80T+KDEUpyRaKjFXFScCAANWTdXzAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit removes code lines currently not in use or never called.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
Cc: Dongjun Shin <d.j.shin@samsung.com>
Cc: Sunghwan Yun <sunghwan.yun@samsung.com>
---
 mm/compaction.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 9635083..1ef9144 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -208,12 +208,6 @@ static bool compact_checklock_irqsave(spinlock_t *lock, unsigned long *flags,
 	return true;
 }
 
-static inline bool compact_trylock_irqsave(spinlock_t *lock,
-			unsigned long *flags, struct compact_control *cc)
-{
-	return compact_checklock_irqsave(lock, flags, false, cc);
-}
-
 /* Returns true if the page is within a block suitable for migration to */
 static bool suitable_migration_target(struct page *page)
 {
@@ -728,7 +722,6 @@ static void isolate_freepages(struct zone *zone,
 			continue;
 
 		/* Found a block suitable for isolating free pages from */
-		isolated = 0;
 
 		/*
 		 * As pfn may not start aligned, pfn+pageblock_nr_page
@@ -1160,9 +1153,6 @@ static void __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
 			if (zone_watermark_ok(zone, cc->order,
 						low_wmark_pages(zone), 0, 0))
 				compaction_defer_reset(zone, cc->order, false);
-			/* Currently async compaction is never deferred. */
-			else if (cc->sync)
-				defer_compaction(zone, cc->order);
 		}
 
 		VM_BUG_ON(!list_empty(&cc->freepages));
-- 
1.8.3.2

