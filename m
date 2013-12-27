Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab3L0EC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 23:02:27 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:62327 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab3L0EBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 23:01:46 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-16-52bcfb9e8228
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 5/6] f2fs: add the number of inline_data files to status info
Date: Fri, 27 Dec 2013 13:00:19 +0900
Message-id: <1388116820-15038-5-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1388116820-15038-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1388116820-15038-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zY915v/cEGXRPFbS4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PfUpmCFUoVj55/
	Ym1gPCPTxcjJISFgIrHpx3xWCFtM4sK99WxdjFwcQgLLGCU2/pjDClP04eI1ZojEdEaJVbNO
	MoMkhASamSTaZvJ2MXJwsAloS2zebwASFhFgllgw9TwjSD2zwARGif+L3rOA1AgL+EqcP+IP
	UsMioCrRcXUG2HxeAXeJO7MuQ+3Sltj2fCIjiM0p4CHR/vM+O8Qqd4mv6w8ygcyUEPjNJnF5
	6w4miEECEt8mHwKbLyEgK7HpADPEHEmJgytusExgFF7AyLCKUTS1ILmgOCm9yFCvODG3uDQv
	XS85P3cTIyRce3cw3j5gfYgxGWjcRGYp0eR8YLjnlcQbGpsZWZiamBobmVuakSasJM6b9DAp
	SEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAMjc4YU18zXp20UZoRIVQdUn/vZJ67rJn2yYtGC
	Mo9LEydMb5l9TeK7Wci7KLMbAtVLbHtfVWf+0uJdzTZHkl3r77nt94zYJq/n9P66+K3O9+vf
	+27v2CWYe+NJnOcNnmsfVj9N4/ry6AB3Z2PxFp5Lj/K9FkkWRierHPe1C9RWLF9m75zLZ1Sk
	xFKckWioxVxUnAgAK/h83W0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jQd15v/cEGfQt4bW4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHj31KZghVKFY+ef2JtYDwj08XIySEhYCLx4eI1ZghbTOLCvfVsXYxcHEIC
	0xklVs06CZYQEmhmkmibydvFyMHBJqAtsXm/AUhYRIBZYsHU84wg9cwCExgl/i96zwJSIyzg
	K3H+iD9IDYuAqkTH1RmsIDavgLvEnVmXWSF2aUtsez6REcTmFPCQaP95nx1ilbvE1/UHmSYw
	8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERwNz6R3MK5qsDjEKMDBqMTD67BhT5AQ
	a2JZcWXuIUYJDmYlEd7PV4BCvCmJlVWpRfnxRaU5qcWHGJOBrprILCWanA+M1LySeENjEzMj
	SyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYFSJ+VDLuFnoa2jB4+vsV9+I
	RRlWx2qIO9+b4sDYsXP13r9bjix5o2lzuSN2Qt0Tth3Xfnv6Wf25q/ao/VPRvFeTpPfqiK2S
	V5iuwPJw88ezf+e67VcQf36tbcMp6flGqxJXKfdHXG5ojJ4Ufoy51fHQTaaYjiP7KhzXSr5V
	mvf6h9Iu9gae6mVKLMUZiYZazEXFiQA2qdnaygIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the number of inline_data files into the status information.
Note that the number is reset whenever the filesystem is newly mounted.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/debug.c  |  3 +++
 fs/f2fs/f2fs.h   | 16 +++++++++++++++-
 fs/f2fs/inline.c |  2 ++
 fs/f2fs/inode.c  |  1 +
 4 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 61adbcb..711a0d4 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -45,6 +45,7 @@ static void update_general_status(struct f2fs_sb_info *sbi)
 	si->valid_count = valid_user_blocks(sbi);
 	si->valid_node_count = valid_node_count(sbi);
 	si->valid_inode_count = valid_inode_count(sbi);
+	si->inline_inode = sbi->inline_inode;
 	si->utilization = utilization(sbi);
 
 	si->free_segs = free_segments(sbi);
@@ -200,6 +201,8 @@ static int stat_show(struct seq_file *s, void *v)
 		seq_printf(s, "Other: %u)\n  - Data: %u\n",
 			   si->valid_node_count - si->valid_inode_count,
 			   si->valid_count - si->valid_node_count);
+		seq_printf(s, "  - Inline_data Inode: %u\n",
+			   si->inline_inode);
 		seq_printf(s, "\nMain area: %d segs, %d secs %d zones\n",
 			   si->main_area_segs, si->main_area_sections,
 			   si->main_area_zones);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index af35039..ef4073f 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -460,6 +460,7 @@ struct f2fs_sb_info {
 	unsigned int segment_count[2];		/* # of allocated segments */
 	unsigned int block_count[2];		/* # of allocated blocks */
 	int total_hit_ext, read_hit_ext;	/* extent cache hit ratio */
+	int inline_inode;			/* # of inline_data inodes */
 	int bg_gc;				/* background gc calls */
 	unsigned int n_dirty_dirs;		/* # of dir inodes */
 #endif
@@ -1201,7 +1202,7 @@ struct f2fs_stat_info {
 	int ndirty_node, ndirty_dent, ndirty_dirs, ndirty_meta;
 	int nats, sits, fnids;
 	int total_count, utilization;
-	int bg_gc;
+	int bg_gc, inline_inode;
 	unsigned int valid_count, valid_node_count, valid_inode_count;
 	unsigned int bimodal, avg_vblocks;
 	int util_free, util_valid, util_invalid;
@@ -1230,6 +1231,17 @@ static inline struct f2fs_stat_info *F2FS_STAT(struct f2fs_sb_info *sbi)
 #define stat_dec_dirty_dir(sbi)		((sbi)->n_dirty_dirs--)
 #define stat_inc_total_hit(sb)		((F2FS_SB(sb))->total_hit_ext++)
 #define stat_inc_read_hit(sb)		((F2FS_SB(sb))->read_hit_ext++)
+#define stat_inc_inline_inode(inode)					\
+	do {								\
+		if (f2fs_has_inline_data(inode))			\
+			((F2FS_SB(inode->i_sb))->inline_inode++);	\
+	} while (0)
+#define stat_dec_inline_inode(inode)					\
+	do {								\
+		if (f2fs_has_inline_data(inode))			\
+			((F2FS_SB(inode->i_sb))->inline_inode--);	\
+	} while (0)
+
 #define stat_inc_seg_type(sbi, curseg)					\
 		((sbi)->segment_count[(curseg)->alloc_type]++)
 #define stat_inc_block_count(sbi, curseg)				\
@@ -1273,6 +1285,8 @@ void f2fs_destroy_root_stats(void);
 #define stat_dec_dirty_dir(sbi)
 #define stat_inc_total_hit(sb)
 #define stat_inc_read_hit(sb)
+#define stat_inc_inline_inode(inode)
+#define stat_dec_inline_inode(inode)
 #define stat_inc_seg_type(sbi, curseg)
 #define stat_inc_block_count(sbi, curseg)
 #define stat_inc_seg_count(si, type)
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 1843bc7..048f601 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -113,6 +113,7 @@ static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
 	zero_user_segment(ipage, INLINE_DATA_OFFSET,
 				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
 	clear_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
+	stat_dec_inline_inode(inode);
 
 	sync_inode_page(&dn);
 	f2fs_put_page(ipage, 1);
@@ -165,6 +166,7 @@ int f2fs_write_inline_data(struct inode *inode,
 	if (!f2fs_has_inline_data(inode)) {
 		truncate_data_blocks_range(&dn, 1);
 		set_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
+		stat_inc_inline_inode(inode);
 	}
 
 	sync_inode_page(&dn);
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index a91f451..915f9a8 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -277,6 +277,7 @@ void f2fs_evict_inode(struct inode *inode)
 
 	f2fs_lock_op(sbi);
 	remove_inode_page(inode);
+	stat_dec_inline_inode(inode);
 	f2fs_unlock_op(sbi);
 
 	sb_end_intwrite(inode->i_sb);
-- 
1.8.4.474.g128a96c

