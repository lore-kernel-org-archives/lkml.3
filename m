Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab3DAG5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:57:04 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45882 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473Ab3DAG46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:56:58 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-9b-51592fb9b3e9
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/9] f2fs: introduce TOTAL_SECS macro
Date: Mon, 01 Apr 2013 15:55:53 +0900
Message-id: <1364799360-23145-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zfd2d+pGBBo0XWSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyji3dRdLQadixe6V
	65gaGJdJdzFycEgImEicmh7dxcgJZIpJXLi3nq2LkYtDSGAZo8TR5g1sEAkTiYWPvrJCJBYx
	Spzqv8kM4bQxSVy6uokNZBKbgLbE5v0GIA0iAswSC6aeZwSpYRaYwCjxf9F7FpCEsICpRPfr
	+8wgNouAqsTN638ZQWxeAXeJTXNvskBs05VY/f85O4jNKeAh8bntI1hcCKjm1L7VYOdJCHxn
	k7j5/wwrxCABiW+TD7FAvCMrsekAM8QcSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IWK84Mbe4
	NC9dLzk/dxMjJGT7dzDePWB9iDEZaNxEZinR5HxgyOeVxBsamxlZmJqYGhuZW5qRJqwkzqvW
	Yh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgZF58QzLVb2X330VzW26OTOTY/rm91we383Z
	OkquMHBXWDNVlxQ+XWr27Lr1o32nigTZeiumhHHoWj/c4VY+Z1diTL/F3LYTGRnfow9UXp+Q
	0vPSUGBmM9e6aI5GYW6XtQH3bvpe2PSRP1ip+Pm+sqzv555+mSpo3BuyTEr0R2+IqbvyGoeW
	40osxRmJhlrMRcWJANReQGRvAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAd2d+pGBBhuZLa7v+stkcWmRu8We
	vSdZLC7vmsPmwOKxe8FnJo++LasYPT5vkgtgjmpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443
	NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBWqakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zck
	CK7HyAANJKxjzDi3dRdLQadixe6V65gaGJdJdzFyckgImEgsfPSVFcIWk7hwbz1bFyMXh5DA
	IkaJU/03mSGcNiaJS1c3AWU4ONgEtCU27zcAaRARYJZYMPU8I0gNs8AERon/i96zgCSEBUwl
	ul/fZwaxWQRUJW5e/8sIYvMKuEtsmnuTBWKbrsTq/8/ZQWxOAQ+Jz20fweJCQDWn9q1mm8DI
	u4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcEQ8k97BuKrB4hCjAAejEg9vxIWIQCHW
	xLLiytxDjBIczEoivD7fgEK8KYmVValF+fFFpTmpxYcYk4GumsgsJZqcD4zWvJJ4Q2MTMyNL
	IzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgzGM9z7N+HS9Hx7xdYe4znMx+
	6H/QPVLsmsT6UkE9hN30wdrKZhb3ZddbpzKzFN1/cX2hx56l/LddjzxWPzTjosWVyxa3pzdV
	7kp4vqAvTShhMbdwx3311iq/7kt/3nzyO3eoy29KOk9O8qOFfJtr73EsWL28qv+wc4Din2sN
	+hzR4j4OvyftUGIpzkg01GIuKk4EAMeH/mLMAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's use a macro to get the total number of sections.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/debug.c   |  7 +++----
 fs/f2fs/segment.c | 19 +++++++++----------
 fs/f2fs/segment.h |  1 +
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 025b9e2..20b8794 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -106,7 +106,7 @@ static void update_sit_info(struct f2fs_sb_info *sbi)
 		}
 	}
 	mutex_unlock(&sit_i->sentry_lock);
-	dist = sbi->total_sections * hblks_per_sec * hblks_per_sec / 100;
+	dist = TOTAL_SECS(sbi) * hblks_per_sec * hblks_per_sec / 100;
 	si->bimodal = bimodal / dist;
 	if (si->dirty_count)
 		si->avg_vblocks = total_vblocks / ndirty;
@@ -138,14 +138,13 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
 	si->base_mem += f2fs_bitmap_size(TOTAL_SEGS(sbi));
 	si->base_mem += 2 * SIT_VBLOCK_MAP_SIZE * TOTAL_SEGS(sbi);
 	if (sbi->segs_per_sec > 1)
-		si->base_mem += sbi->total_sections *
-			sizeof(struct sec_entry);
+		si->base_mem += TOTAL_SECS(sbi) * sizeof(struct sec_entry);
 	si->base_mem += __bitmap_size(sbi, SIT_BITMAP);
 
 	/* build free segmap */
 	si->base_mem += sizeof(struct free_segmap_info);
 	si->base_mem += f2fs_bitmap_size(TOTAL_SEGS(sbi));
-	si->base_mem += f2fs_bitmap_size(sbi->total_sections);
+	si->base_mem += f2fs_bitmap_size(TOTAL_SECS(sbi));
 
 	/* build curseg */
 	si->base_mem += sizeof(struct curseg_info) * NR_CURSEG_TYPE;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 1758149..179a13e 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -348,9 +348,8 @@ static void get_new_segment(struct f2fs_sb_info *sbi,
 			unsigned int *newseg, bool new_sec, int dir)
 {
 	struct free_segmap_info *free_i = FREE_I(sbi);
-	unsigned int total_secs = sbi->total_sections;
 	unsigned int segno, secno, zoneno;
-	unsigned int total_zones = sbi->total_sections / sbi->secs_per_zone;
+	unsigned int total_zones = TOTAL_SECS(sbi) / sbi->secs_per_zone;
 	unsigned int hint = *newseg / sbi->segs_per_sec;
 	unsigned int old_zoneno = GET_ZONENO_FROM_SEGNO(sbi, *newseg);
 	unsigned int left_start = hint;
@@ -367,12 +366,12 @@ static void get_new_segment(struct f2fs_sb_info *sbi,
 			goto got_it;
 	}
 find_other_zone:
-	secno = find_next_zero_bit(free_i->free_secmap, total_secs, hint);
-	if (secno >= total_secs) {
+	secno = find_next_zero_bit(free_i->free_secmap, TOTAL_SECS(sbi), hint);
+	if (secno >= TOTAL_SECS(sbi)) {
 		if (dir == ALLOC_RIGHT) {
 			secno = find_next_zero_bit(free_i->free_secmap,
-						total_secs, 0);
-			BUG_ON(secno >= total_secs);
+							TOTAL_SECS(sbi), 0);
+			BUG_ON(secno >= TOTAL_SECS(sbi));
 		} else {
 			go_left = 1;
 			left_start = hint - 1;
@@ -387,8 +386,8 @@ find_other_zone:
 			continue;
 		}
 		left_start = find_next_zero_bit(free_i->free_secmap,
-						total_secs, 0);
-		BUG_ON(left_start >= total_secs);
+							TOTAL_SECS(sbi), 0);
+		BUG_ON(left_start >= TOTAL_SECS(sbi));
 		break;
 	}
 	secno = left_start;
@@ -1390,7 +1389,7 @@ static int build_sit_info(struct f2fs_sb_info *sbi)
 	}
 
 	if (sbi->segs_per_sec > 1) {
-		sit_i->sec_entries = vzalloc(sbi->total_sections *
+		sit_i->sec_entries = vzalloc(TOTAL_SECS(sbi) *
 					sizeof(struct sec_entry));
 		if (!sit_i->sec_entries)
 			return -ENOMEM;
@@ -1441,7 +1440,7 @@ static int build_free_segmap(struct f2fs_sb_info *sbi)
 	if (!free_i->free_segmap)
 		return -ENOMEM;
 
-	sec_bitmap_size = f2fs_bitmap_size(sbi->total_sections);
+	sec_bitmap_size = f2fs_bitmap_size(TOTAL_SECS(sbi));
 	free_i->free_secmap = kmalloc(sec_bitmap_size, GFP_KERNEL);
 	if (!free_i->free_secmap)
 		return -ENOMEM;
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index c0d7740..fea9245 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -81,6 +81,7 @@
 #define f2fs_bitmap_size(nr)			\
 	(BITS_TO_LONGS(nr) * sizeof(unsigned long))
 #define TOTAL_SEGS(sbi)	(SM_I(sbi)->main_segments)
+#define TOTAL_SECS(sbi)	(sbi->total_sections)
 
 #define SECTOR_FROM_BLOCK(sbi, blk_addr)				\
 	(blk_addr << ((sbi)->log_blocksize - F2FS_LOG_SECTOR_SIZE))
-- 
1.8.1.3.566.gaa39828

