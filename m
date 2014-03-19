Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbaCSIEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:04:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31916 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaCSIEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:04:01 -0400
X-AuditID: cbfee68f-b7f156d00000276c-52-53294f6d1a8a
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 3/5] f2fs: remove unnecessary threshold
Date: Wed, 19 Mar 2014 17:02:07 +0900
Message-id: <1395216129-13656-3-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1395216129-13656-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1395216129-13656-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t8zQ91cf81ggznfxSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgypgw7RB7wU3Biq49
	+5kbGJfwdTFyckgImEg0zvvHBGGLSVy4t54NxBYSWMYo8euiTxcjB1jNnZ1cIKaQwHRGiTcm
	XYxcQGYnk8TeDyfZQeJsAtoSm/cbgHSKCDBLLJh6nhGkhllgAqPE/0XvWUBqhAXMJR6fNAep
	YRFQlVjdfh9sE6+Au8SVtW+gLtCW2PZ8IiOIzSngIXHo5gVmiGvcJZ6+vcICMlNC4DebxN8n
	j9ggBglIfJt8iAXiTFmJTQeYIeZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UXGesWJucWleel6
	yfm5mxghodq/g/HuAetDjMlA4yYyS4km5wNDPa8k3tDYzMjC1MTU2Mjc0ow0YSVx3vsPk4KE
	BNITS1KzU1MLUovii0pzUosPMTJxcEo1MO678PC32rJ57nqfn/37fEH/yPXXUvP4nkfe149a
	75f0ds5XG/4W927nF/8dA2Z/f/9xh9K2jqxbigci7wdNXCyjLdGv38PidviWJ/ur38sWr3uV
	K6IukZd79bjZIYvZJgXSNT/doz+L6zVHf7fNO5KhaftFZ+bZVS5/bEx/qRg0Tzmyrd/n1mUl
	luKMREMt5qLiRADH7M88awIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t9jQd1cf81gg5f7hS2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8yYMO0Qe8FNwYquPfuZGxiX8HUxcnBICJhI3NnJ1cXICWSKSVy4t54NJCwk
	MJ1R4o1JFyMXkNnJJLH3w0l2kDibgLbE5v0GIOUiAswSC6aeZwSpYRaYwCjxf9F7FpAaYQFz
	iccnzUFqWARUJVa332cDsXkF3CWurH3DBLFKW2Lb84mMIDangIfEoZsXmEFsIaCap2+vsExg
	5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzgWnkntYFzZYHGIUYCDUYmH90CURrAQ
	a2JZcWXuIUYJDmYlEV7hu0Ah3pTEyqrUovz4otKc1OJDjMlAV01klhJNzgfGaV5JvKGxiZmR
	pZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MMZW+wkcVtm5q8zHYnPoao1l
	FhuYPI0q65v0AnkTbsj+uDFpw5T3+XZOecwHtt1fuH6B4pqC3T0SdaHG316+/ciRuoP/b4JR
	0iqXn0XROz++EdlyqHKda+8c/e9zU0wu3S9dvfV/yvQDp3sORJ3oPu4XttCBQ9nKxDshbp16
	h9c9xldh3kt21yixFGckGmoxFxUnAgCosCC+yQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NM_WOUT_THRESHOLD is now obsolete since f2fs starts to control on a basis
of the memory footprint.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/debug.c | 8 ++++----
 fs/f2fs/node.c  | 5 +----
 fs/f2fs/node.h  | 3 ---
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index b7111c4..b52c12c 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -250,10 +250,10 @@ static int stat_show(struct seq_file *s, void *v)
 			   si->ndirty_dent, si->ndirty_dirs);
 		seq_printf(s, "  - meta: %4d in %4d\n",
 			   si->ndirty_meta, si->meta_pages);
-		seq_printf(s, "  - NATs: %5d > %lu\n",
-			   si->nats, NM_WOUT_THRESHOLD);
-		seq_printf(s, "  - SITs: %5d\n  - free_nids: %5d\n",
-			   si->sits, si->fnids);
+		seq_printf(s, "  - NATs: %9d\n  - SITs: %9d\n",
+			   si->nats, si->sits);
+		seq_printf(s, "  - free_nids: %9d\n",
+			   si->fnids);
 		seq_puts(s, "\nDistribution of User Blocks:");
 		seq_puts(s, " [ valid | invalid | free ]\n");
 		seq_puts(s, "  [");
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 9cf524d..4f48aa3 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -224,7 +224,7 @@ int try_to_free_nats(struct f2fs_sb_info *sbi, int nr_shrink)
 {
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 
-	if (available_free_memory(nm_i, NAT_ENTRIES) || nr_shrink <= 0)
+	if (available_free_memory(nm_i, NAT_ENTRIES))
 		return 0;
 
 	write_lock(&nm_i->nat_tree_lock);
@@ -1828,9 +1828,6 @@ flush_now:
 	if (!flushed)
 		mutex_unlock(&curseg->curseg_mutex);
 	f2fs_put_page(page, 1);
-
-	/* 2) shrink nat caches if necessary */
-	try_to_free_nats(sbi, nm_i->nat_cnt - NM_WOUT_THRESHOLD);
 }
 
 static int init_node_manager(struct f2fs_sb_info *sbi)
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index c972154..c2015b7 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -20,9 +20,6 @@
 /* maximum readahead size for node during getting data blocks */
 #define MAX_RA_NODE		128
 
-/* maximum cached nat entries to manage memory footprint */
-#define NM_WOUT_THRESHOLD	(64 * NAT_ENTRY_PER_BLOCK)
-
 /* control the memory footprint threshold (10MB per 1GB ram) */
 #define DEF_RAM_THRESHOLD	10
 
-- 
1.8.4.474.g128a96c

