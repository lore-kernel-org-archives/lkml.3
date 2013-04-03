Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312Ab3DCIH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:07:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37503 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945Ab3DCIHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:07:46 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-12-515be350ece0
Message-id: <1364976415.4353.9.camel@kjgkr>
Subject: Re: [PATCH 5/9 v2] f2fs: change GC bitmaps to apply the section
 granularity
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 03 Apr 2013 17:06:55 +0900
In-reply-to: <CAKYAXd_+6A4nXNKbguqwgSFSJxBDM+5ZmZ+KErX0hpfwd-ieyA@mail.gmail.com>
References: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
 <1364799360-23145-5-git-send-email-jaegeuk.kim@samsung.com>
 <CAKYAXd_+6A4nXNKbguqwgSFSJxBDM+5ZmZ+KErX0hpfwd-ieyA@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-e1mtXHC+3LMe3ZiDc9MH"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t8zI92Ax9GBBlfucFhcv3uL2eLSIneL
	PXtPslhc3jWHzYHFY+esu+weuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK+PlgceMBdNKKtbc
	28rcwDgtoYuRk0NCwERi8/ZnrBC2mMSFe+vZuhi5OIQEljFKTDy4BSjBAVbUdEMCIr6IUaLz
	w2d2kAYhgdeMEs0LA0BsXgFtiT83F4HFhQXCJHbtOswE0ssGFN+83wCiXFHi7f67YCNFBNQk
	JjxLBQkzC2RKzHk9GewEFgFViZXz7zODlHAKBEtMmmsKsfUMo8TD0yvBpvMLiEqcbP3ECNFb
	JXF06wtGiPOVJHa3d7JDXCMo8WPyPRaQZgmBv+wS9zYugFogIPFt8iEWiLdkJTYdYIbolZQ4
	uOIGywRG8VlIxs5CMgoirinRuv03O4StLbFs4WtmCNtWYt2691A1NhKbri5ghLDlJba/ncO8
	gJF9FaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZI1PbvYLx7wPoQYxXQiROZpUST84FRn1cS
	b2hsZmRhamJqbGRuaUYVYSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjK68+Syi
	ZRYPXiirbePNky38F/13+lfRmjOGMrafLXcudIrdLH/sU8/24mtCmw5GfhZS4FHtCNiTveDO
	rTtbm6S5ntjOrufs0LnHHThFeeO2xJjeKzduatTsODz/mU+LrcuPf6fLHoSu+LE1dfdty7QQ
	Ca3UBlm+pNtht5f7iNx4USmQcPvSeSWW4oxEQy3mouJEAMQxjSEHAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKKsWRmVeSWpSXmKPExsVy+t9jAd2Ax9GBBltvMlpcv3uL2eLSIneL
	PXtPslhc3jWHzYHFY+esu+weuxd8ZvL4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHj5YHHjAXTSirW3NvK3MA4LaGLkYNDQsBEoumGRBcjJ5ApJnHh3nq2LkYu
	DiGBRYwSnR8+s4MkhAReM0o0LwwAsXkFtCX+3FwEFhcWCJPYteswE8gcNqD45v0GEOWKEm/3
	32UFCYsIqElMeJYKEmYWyJSY83oyK4jNIqAqsXL+fWaQEk6BYIlJc00htp5hlHh4eiXYdH4B
	UYmTrZ8YIXqrJI5ufcEIcaaSxO72TnaIawQlfky+xzKBUXAWkrJZSFIQcU2J1u2/2SFsbYll
	C18zQ9i2EuvWvYeqsZHYdHUBI4QtL7H97RzmBYzsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNz
	NzGCU8Iz6R2MqxosDjEKcDAq8fCe+BIVKMSaWFZcmXuIUQVozqMNqy8wSrHk5eelKonwch6P
	DhTiTUmsrEotyo8vKs1JLT7EOJERGBwTmaVEk/OBiSyvJN7Q2MTMyNLIzMLIxNyclsJK4rwH
	W60DhQTSE0tSs1NTC1KLYI5i4uCUamBc/Y7xw/Mfe8/OfPzgsYfMv9vRKmWBt1b7uKiWTno+
	MTYz5ahrzMP73W6qp8SbzFnZQxZb8Uf0zV3AayzX7au/g3H62gDFj3trMpUX6T9eYPzBvPVC
	pLusm8sx7kUpjW/9uU990JDRCV2+UEZ/oetlTrOcaWk7tJz3Lxaau2G5JP9c5uTIpMNKLMUZ
	iYZazEXFiQAdNIXbiAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-e1mtXHC+3LMe3ZiDc9MH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,
Agreed, and resolved all the issues like below.
Thanks,

change log from v1:
 o change local variable position
 o change function shape
 o add NULL_SECNO

=46rom f1802031a467751df6475bd3f56300137fd2ac34 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date: Sun, 31 Mar 2013 13:26:03 +0900
Subject: [PATCH] f2fs: change GC bitmaps to apply the section
granularity
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
linux-f2fs-devel@lists.sourceforge.net

This patch removes a bitmap for victim segments selected by foreground
GC, and
modifies the other bitmap for victim segments selected by background GC.

1) foreground GC bitmap
 : We don't need to manage this, since we just only one previous victim
section
   number instead of the whole victim history.
   The f2fs uses the victim section number in order not to allocate
currently
   GC'ed section to current active logs.

2) background GC bitmap
 : This bitmap is used to avoid selecting victims repeatedly by
background GCs.
   In addition, the victims are able to be selected by foreground GCs,
since
   there is no need to read victim blocks during foreground GCs.

   By the fact that the foreground GC reclaims segments in a section
unit, it'd
   be better to manage this bitmap based on the section granularity.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c |  2 --
 fs/f2fs/debug.c      |  2 +-
 fs/f2fs/f2fs.h       |  2 +-
 fs/f2fs/gc.c         | 43 +++++++++++++++++++---------------
 fs/f2fs/segment.c    | 66
++++++++++++++++++++++++----------------------------
 fs/f2fs/segment.h    | 10 +++++++-
 fs/f2fs/super.c      |  2 ++
 7 files changed, 68 insertions(+), 59 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index d947e66..93fd57d 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -748,8 +748,6 @@ void write_checkpoint(struct f2fs_sb_info *sbi, bool
is_umount)
 	flush_nat_entries(sbi);
 	flush_sit_entries(sbi);
=20
-	reset_victim_segmap(sbi);
-
 	/* unlock all the fs_lock[] in do_checkpoint() */
 	do_checkpoint(sbi, is_umount);
=20
diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 20b8794..c3bf343 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -153,7 +153,7 @@ static void update_mem_info(struct f2fs_sb_info
*sbi)
 	/* build dirty segmap */
 	si->base_mem +=3D sizeof(struct dirty_seglist_info);
 	si->base_mem +=3D NR_DIRTY_TYPE * f2fs_bitmap_size(TOTAL_SEGS(sbi));
-	si->base_mem +=3D 2 * f2fs_bitmap_size(TOTAL_SEGS(sbi));
+	si->base_mem +=3D f2fs_bitmap_size(TOTAL_SECS(sbi));
=20
 	/* buld nm */
 	si->base_mem +=3D sizeof(struct f2fs_nm_info);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 77e2eb0..71eacd3 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -410,6 +410,7 @@ struct f2fs_sb_info {
 	/* for cleaning operations */
 	struct mutex gc_mutex;			/* mutex for GC */
 	struct f2fs_gc_kthread	*gc_thread;	/* GC thread */
+	unsigned int cur_victim_sec;		/* current victim section num */
=20
 	/*
 	 * for stat information.
@@ -979,7 +980,6 @@ int lookup_journal_in_cursum(struct
f2fs_summary_block *,
 					int, unsigned int, int);
 void flush_sit_entries(struct f2fs_sb_info *);
 int build_segment_manager(struct f2fs_sb_info *);
-void reset_victim_segmap(struct f2fs_sb_info *);
 void destroy_segment_manager(struct f2fs_sb_info *);
=20
 /*
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 2e3eb2d..09b8a90 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -160,18 +160,21 @@ static unsigned int get_max_cost(struct
f2fs_sb_info *sbi,
 static unsigned int check_bg_victims(struct f2fs_sb_info *sbi)
 {
 	struct dirty_seglist_info *dirty_i =3D DIRTY_I(sbi);
-	unsigned int segno;
+	unsigned int hint =3D 0;
+	unsigned int secno;
=20
 	/*
 	 * If the gc_type is FG_GC, we can select victim segments
 	 * selected by background GC before.
 	 * Those segments guarantee they have small valid blocks.
 	 */
-	segno =3D find_next_bit(dirty_i->victim_segmap[BG_GC],
-						TOTAL_SEGS(sbi), 0);
-	if (segno < TOTAL_SEGS(sbi)) {
-		clear_bit(segno, dirty_i->victim_segmap[BG_GC]);
-		return segno;
+next:
+	secno =3D find_next_bit(dirty_i->victim_secmap, TOTAL_SECS(sbi), hint
++);
+	if (secno < TOTAL_SECS(sbi)) {
+		if (sec_usage_check(sbi, secno))
+			goto next;
+		clear_bit(secno, dirty_i->victim_secmap);
+		return secno * sbi->segs_per_sec;
 	}
 	return NULL_SEGNO;
 }
@@ -234,7 +237,7 @@ static int get_victim_by_default(struct f2fs_sb_info
*sbi,
 {
 	struct dirty_seglist_info *dirty_i =3D DIRTY_I(sbi);
 	struct victim_sel_policy p;
-	unsigned int segno;
+	unsigned int secno;
 	int nsearched =3D 0;
=20
 	p.alloc_mode =3D alloc_mode;
@@ -253,6 +256,7 @@ static int get_victim_by_default(struct f2fs_sb_info
*sbi,
=20
 	while (1) {
 		unsigned long cost;
+		unsigned int segno;
=20
 		segno =3D find_next_bit(p.dirty_segmap,
 						TOTAL_SEGS(sbi), p.offset);
@@ -265,13 +269,11 @@ static int get_victim_by_default(struct
f2fs_sb_info *sbi,
 			break;
 		}
 		p.offset =3D ((segno / p.ofs_unit) * p.ofs_unit) + p.ofs_unit;
+		secno =3D GET_SECNO(sbi, segno);
=20
-		if (test_bit(segno, dirty_i->victim_segmap[FG_GC]))
+		if (sec_usage_check(sbi, secno))
 			continue;
-		if (gc_type =3D=3D BG_GC &&
-				test_bit(segno, dirty_i->victim_segmap[BG_GC]))
-			continue;
-		if (IS_CURSEC(sbi, GET_SECNO(sbi, segno)))
+		if (gc_type =3D=3D BG_GC && test_bit(secno, dirty_i->victim_secmap))
 			continue;
=20
 		cost =3D get_gc_cost(sbi, segno, &p);
@@ -291,13 +293,14 @@ static int get_victim_by_default(struct
f2fs_sb_info *sbi,
 	}
 got_it:
 	if (p.min_segno !=3D NULL_SEGNO) {
-		*result =3D (p.min_segno / p.ofs_unit) * p.ofs_unit;
 		if (p.alloc_mode =3D=3D LFS) {
-			int i;
-			for (i =3D 0; i < p.ofs_unit; i++)
-				set_bit(*result + i,
-					dirty_i->victim_segmap[gc_type]);
+			secno =3D GET_SECNO(sbi, p.min_segno);
+			if (gc_type =3D=3D FG_GC)
+				sbi->cur_victim_sec =3D secno;
+			else
+				set_bit(secno, dirty_i->victim_secmap);
 		}
+		*result =3D (p.min_segno / p.ofs_unit) * p.ofs_unit;
 	}
 	mutex_unlock(&dirty_i->seglist_lock);
=20
@@ -662,9 +665,11 @@ gc_more:
 	for (i =3D 0; i < sbi->segs_per_sec; i++)
 		do_garbage_collect(sbi, segno + i, &ilist, gc_type);
=20
-	if (gc_type =3D=3D FG_GC &&
-			get_valid_blocks(sbi, segno, sbi->segs_per_sec) =3D=3D 0)
+	if (gc_type =3D=3D FG_GC) {
+		sbi->cur_victim_sec =3D NULL_SEGNO;
 		nfree++;
+		WARN_ON(get_valid_blocks(sbi, segno, sbi->segs_per_sec));
+	}
=20
 	if (has_not_enough_free_secs(sbi, nfree))
 		goto gc_more;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index b3486f3..d5244f6 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -69,8 +69,9 @@ static void __remove_dirty_segment(struct f2fs_sb_info
*sbi, unsigned int segno,
 		if (test_and_clear_bit(segno,
 					dirty_i->dirty_segmap[dirty_type]))
 			dirty_i->nr_dirty[dirty_type]--;
-		clear_bit(segno, dirty_i->victim_segmap[FG_GC]);
-		clear_bit(segno, dirty_i->victim_segmap[BG_GC]);
+		if (get_valid_blocks(sbi, segno, sbi->segs_per_sec) =3D=3D 0)
+			clear_bit(GET_SECNO(sbi, segno),
+						dirty_i->victim_secmap);
 	}
 }
=20
@@ -296,13 +297,12 @@ static void write_sum_page(struct f2fs_sb_info
*sbi,
 	f2fs_put_page(page, 1);
 }
=20
-static unsigned int check_prefree_segments(struct f2fs_sb_info *sbi,
-					int ofs_unit, int type)
+static unsigned int check_prefree_segments(struct f2fs_sb_info *sbi,
int type)
 {
 	struct dirty_seglist_info *dirty_i =3D DIRTY_I(sbi);
 	unsigned long *prefree_segmap =3D dirty_i->dirty_segmap[PRE];
-	unsigned int segno, next_segno, i;
-	int ofs =3D 0;
+	unsigned int segno;
+	unsigned int ofs =3D 0;
=20
 	/*
 	 * If there is not enough reserved sections,
@@ -318,23 +318,30 @@ static unsigned int check_prefree_segments(struct
f2fs_sb_info *sbi,
 	if (IS_NODESEG(type))
 		return NULL_SEGNO;
 next:
-	segno =3D find_next_bit(prefree_segmap, TOTAL_SEGS(sbi), ofs++);
-	ofs =3D ((segno / ofs_unit) * ofs_unit) + ofs_unit;
+	segno =3D find_next_bit(prefree_segmap, TOTAL_SEGS(sbi), ofs);
+	ofs +=3D sbi->segs_per_sec;
+
 	if (segno < TOTAL_SEGS(sbi)) {
+		int i;
+
 		/* skip intermediate segments in a section */
-		if (segno % ofs_unit)
+		if (segno % sbi->segs_per_sec)
 			goto next;
=20
-		/* skip if whole section is not prefree */
-		next_segno =3D find_next_zero_bit(prefree_segmap,
-						TOTAL_SEGS(sbi), segno + 1);
-		if (next_segno - segno < ofs_unit)
+		/* skip if the section is currently used */
+		if (sec_usage_check(sbi, GET_SECNO(sbi, segno)))
 			goto next;
=20
+		/* skip if whole section is not prefree */
+		for (i =3D 1; i < sbi->segs_per_sec; i++)
+			if (!test_bit(segno + i, prefree_segmap))
+				goto next;
+
 		/* skip if whole section was not free at the last checkpoint */
-		for (i =3D 0; i < ofs_unit; i++)
-			if (get_seg_entry(sbi, segno)->ckpt_valid_blocks)
+		for (i =3D 0; i < sbi->segs_per_sec; i++)
+			if (get_seg_entry(sbi, segno + i)->ckpt_valid_blocks)
 				goto next;
+
 		return segno;
 	}
 	return NULL_SEGNO;
@@ -561,15 +568,13 @@ static void allocate_segment_by_default(struct
f2fs_sb_info *sbi,
 						int type, bool force)
 {
 	struct curseg_info *curseg =3D CURSEG_I(sbi, type);
-	unsigned int ofs_unit;
=20
 	if (force) {
 		new_curseg(sbi, type, true);
 		goto out;
 	}
=20
-	ofs_unit =3D need_SSR(sbi) ? 1 : sbi->segs_per_sec;
-	curseg->next_segno =3D check_prefree_segments(sbi, ofs_unit, type);
+	curseg->next_segno =3D check_prefree_segments(sbi, type);
=20
 	if (curseg->next_segno !=3D NULL_SEGNO)
 		change_curseg(sbi, type, false);
@@ -1558,14 +1563,13 @@ static void init_dirty_segmap(struct
f2fs_sb_info *sbi)
 	}
 }
=20
-static int init_victim_segmap(struct f2fs_sb_info *sbi)
+static int init_victim_secmap(struct f2fs_sb_info *sbi)
 {
 	struct dirty_seglist_info *dirty_i =3D DIRTY_I(sbi);
-	unsigned int bitmap_size =3D f2fs_bitmap_size(TOTAL_SEGS(sbi));
+	unsigned int bitmap_size =3D f2fs_bitmap_size(TOTAL_SECS(sbi));
=20
-	dirty_i->victim_segmap[FG_GC] =3D kzalloc(bitmap_size, GFP_KERNEL);
-	dirty_i->victim_segmap[BG_GC] =3D kzalloc(bitmap_size, GFP_KERNEL);
-	if (!dirty_i->victim_segmap[FG_GC] || !dirty_i->victim_segmap[BG_GC])
+	dirty_i->victim_secmap =3D kzalloc(bitmap_size, GFP_KERNEL);
+	if (!dirty_i->victim_secmap)
 		return -ENOMEM;
 	return 0;
 }
@@ -1592,7 +1596,7 @@ static int build_dirty_segmap(struct f2fs_sb_info
*sbi)
 	}
=20
 	init_dirty_segmap(sbi);
-	return init_victim_segmap(sbi);
+	return init_victim_secmap(sbi);
 }
=20
 /*
@@ -1679,18 +1683,10 @@ static void discard_dirty_segmap(struct
f2fs_sb_info *sbi,
 	mutex_unlock(&dirty_i->seglist_lock);
 }
=20
-void reset_victim_segmap(struct f2fs_sb_info *sbi)
-{
-	unsigned int bitmap_size =3D f2fs_bitmap_size(TOTAL_SEGS(sbi));
-	memset(DIRTY_I(sbi)->victim_segmap[FG_GC], 0, bitmap_size);
-}
-
-static void destroy_victim_segmap(struct f2fs_sb_info *sbi)
+static void destroy_victim_secmap(struct f2fs_sb_info *sbi)
 {
 	struct dirty_seglist_info *dirty_i =3D DIRTY_I(sbi);
-
-	kfree(dirty_i->victim_segmap[FG_GC]);
-	kfree(dirty_i->victim_segmap[BG_GC]);
+	kfree(dirty_i->victim_secmap);
 }
=20
 static void destroy_dirty_segmap(struct f2fs_sb_info *sbi)
@@ -1705,7 +1701,7 @@ static void destroy_dirty_segmap(struct
f2fs_sb_info *sbi)
 	for (i =3D 0; i < NR_DIRTY_TYPE; i++)
 		discard_dirty_segmap(sbi, i);
=20
-	destroy_victim_segmap(sbi);
+	destroy_victim_secmap(sbi);
 	SM_I(sbi)->dirty_info =3D NULL;
 	kfree(dirty_i);
 }
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index fea9245..c1782bd 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -10,6 +10,7 @@
  */
 /* constant macro */
 #define NULL_SEGNO			((unsigned int)(~0))
+#define NULL_SECNO			((unsigned int)(~0))
=20
 /* V: Logical segment # in volume, R: Relative segment # in main area
*/
 #define GET_L2R_SEGNO(free_i, segno)	(segno - free_i->start_segno)
@@ -214,7 +215,7 @@ struct dirty_seglist_info {
 	unsigned long *dirty_segmap[NR_DIRTY_TYPE];
 	struct mutex seglist_lock;		/* lock for segment bitmaps */
 	int nr_dirty[NR_DIRTY_TYPE];		/* # of dirty segments */
-	unsigned long *victim_segmap[2];	/* BG_GC, FG_GC */
+	unsigned long *victim_secmap;		/* background GC victims */
 };
=20
 /* victim selection function for cleaning and SSR */
@@ -616,3 +617,10 @@ static inline block_t sum_blk_addr(struct
f2fs_sb_info *sbi, int base, int type)
 		le32_to_cpu(F2FS_CKPT(sbi)->cp_pack_total_block_count)
 				- (base + 1) + type;
 }
+
+static inline bool sec_usage_check(struct f2fs_sb_info *sbi, unsigned
int secno)
+{
+	if (IS_CURSEC(sbi, secno) || (sbi->cur->victim_sec =3D=3D secno))
+		return true;
+	return false;
+}
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 252890e..728c20a 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -26,6 +26,7 @@
=20
 #include "f2fs.h"
 #include "node.h"
+#include "segment.h"
 #include "xattr.h"
=20
 static struct kmem_cache *f2fs_inode_cachep;
@@ -458,6 +459,7 @@ static void init_sb_info(struct f2fs_sb_info *sbi)
 	sbi->root_ino_num =3D le32_to_cpu(raw_super->root_ino);
 	sbi->node_ino_num =3D le32_to_cpu(raw_super->node_ino);
 	sbi->meta_ino_num =3D le32_to_cpu(raw_super->meta_ino);
+	sbi->cur_victim_sec =3D NULL_SECNO;
=20
 	for (i =3D 0; i < NR_COUNT_TYPE; i++)
 		atomic_set(&sbi->nr_pages[i], 0);
--=20
1.8.1.3.566.gaa39828



--=20
Jaegeuk Kim
Samsung

--=-e1mtXHC+3LMe3ZiDc9MH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRW+MfAAoJEEAUqH6CSFDSSgIP/1+hYdaXM82SbucOiusBw+yf
aaa1TiLbM4owztGmWchpALn+B2BLaH/ZRAoC9/ETMnOfMavILnnfv/NRatSPQyYk
3hs4g4Y+ERp/ZAruKGWFBRinov/INf+k6BGVZMUIUpuJYcdn5US0zbB9mutaf6/q
7omy4zwTs1q6Kmoom4zZRgduUdEdbpUXGw7n1omdCxQI+w9m8ewnyMIz2zR8JY/S
3OnYJglkOlXI00ZNdWtuHfztviLeA8AY0+xeUexoZBjIAWuwWlDzeo1p5Ixk7bg8
uiGT7270lHmDdEnFMxQuUh4k4VnDy/2gEYRCRhwzhH14gpa6IiBNuLWEMQZilGwk
PyFRBjy7vRfkqZK5ET/dKfTrFPqTqgignpfne7W2WWYIYOfmbHjNU2HA6DKtlM4m
KFGqR8V3hg6oSPHmHGRdb3jH08ATXKe8cN8aweQIyzyEx4dOtss4K0kVV3siAfWo
fSIRq3VHJziJobSOifrPc7/HjtVgKEG8CqNbtHdeQsiEHxmejD+TV1/DX5nkbTF7
xFP4pP7RrHBtOxZ5BdKQwgtfgNnpZxScA6pMJjccM4+zVcu/wLjuWu+57e1KpyCD
6uJsUnuIamBIVHO8TRzDKdQabHKj470jRDU/c6zw7qMRYB38hHmigwjM/tSW+Wr5
Mwdm58bIInMa0NIA5utM
=Jf7s
-----END PGP SIGNATURE-----

--=-e1mtXHC+3LMe3ZiDc9MH--

