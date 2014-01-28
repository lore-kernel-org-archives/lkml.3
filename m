Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaA1Fzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 00:55:38 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:25279 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaA1Fzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 00:55:35 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7f156d00000276c-2b-52e746565533
Content-transfer-encoding: 8BIT
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 4/4] f2fs: fix a build warning
Date: Tue, 28 Jan 2014 14:54:07 +0900
Message-id: <1390888447-5258-4-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1390888447-5258-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1390888447-5258-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t8zI90wt+dBBlt/Clhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbH76kvGgn6Biq6e
	zUwNjBt5uxg5OSQETCTWzD3KCmGLSVy4t54NxBYSWMYo8fp1LUzN4pln2LsYuYDiixgl2mYf
	ZwRJ8AoISvyYfI+li5GDg1lAXuLIpWyQMLOAusSkeYuYIeqbmCSO/13IClLDJqAtsXm/AUiN
	iACzxIKp5xlBapgFJjBK/F/0ngUkISygJ3H8/TSwg1gEVCX2Pp3CArHLTWLbnzdsEAdpS2x7
	PhHsBk4Bd4nLH3+yg8wXAqp5P9EQZKaEwCZ2icsL+9gg5ghIfJt8COxOCQFZiU0HmCHGSEoc
	XHGDZQKj2Cwk38xC+GYWkm8WMDKvYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiJnv4djHcP
	WB9iTAbaOJFZSjQ5Hxh9eSXxhsZmRhamJqbGRuaWZqQJK4nz3n+YFCQkkJ5YkpqdmlqQWhRf
	VJqTWnyIkYmDU6qBMeuJvLz6+U6TWap6Descvoa+nrIli9PC7O83kwPeEc2e7uxzotsvdzw7
	I3M7XvNTwrb/Cjfs9kc0vXvoVq1610h7/6X+RWESQU4TfLYHvk6esVHlMXvjjkiD9JmVnnEN
	VsEuCy8W7v3eOXGiSkn++rlTw9vYA7ymvHj2LOUky2pWnXvXIy20lViKMxINtZiLihMBHPos
	17QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t9jAd0wt+dBBg928lpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ix++pLxoJ+gYquns1MDYwbebsYOTkkBEwkFs88ww5hi0lcuLeerYuRi0NI
	YBGjRNvs44wgCV4BQYkfk++xdDFycDALyEscuZQNEmYWUJeYNG8RM0R9E5PE8b8LWUFq2AS0
	JTbvNwCpERFgllgw9TwjSA2zwARGif+L3rOAJIQF9CSOv5/GCmKzCKhK7H06hQVil5vEtj9v
	2CAO0pbY9nwi2A2cAu4Slz/+ZAeZLwRU836i4QRGgVlIrpuFcN0sJNctYGRexSiaWpBcUJyU
	nmuoV5yYW1yal66XnJ+7iREcnc+kdjCubLA4xCjAwajEw9vR+SxIiDWxrLgy9xCjBAezkgjv
	2SlAId6UxMqq1KL8+KLSnNTiQ4zJQHdPZJYSTc4HJo68knhDYxMzI0sjMwsjE3Nz0oSVxHkP
	tFoHCgmkJ5akZqemFqQWwWxh4uCUamCMvZK8zSlJ9vNnBva7nszfzBLDnnx6V1C0K33et8mb
	Pn969SryU1BIbp9T3w4Vu8J3SztUrr3/6iGyZfKNJu1vi34uW6AidpHX3vkl48f3i8Uabu88
	K29bzB66ZVnspLlPPdeyr3x7eg6zzLlqxQfn397+FiZWqrpAKod9xl5JYwnF8s6Gr1NZlViK
	MxINtZiLihMB3PaF4hIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies flow a little bit to avoid the following build warnings.

src/fs/f2fs/recovery.c: In function ‘check_index_in_prev_nodes’:
src/fs/f2fs/recovery.c:288:51: warning: ‘sum.<U5390>.<U52f8>.ofs_in_node’ may
	be used uninitialized in this function [-Wmaybe-uninitialized]
src/fs/f2fs/recovery.c:260:23: warning: ‘sum.nid’ may be used uninitialized
	in this function [-Wmaybe-uninitialized]

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/recovery.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index f1b0b89..cdc4bdd 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -220,11 +220,11 @@ static int check_index_in_prev_nodes(struct f2fs_sb_info *sbi,
 	unsigned int segno = GET_SEGNO(sbi, blkaddr);
 	unsigned short blkoff = GET_SEGOFF_FROM_SEG0(sbi, blkaddr) &
 					(sbi->blocks_per_seg - 1);
+	struct f2fs_summary_block *sum_node;
 	struct f2fs_summary sum;
+	struct page *sum_page, *node_page;
 	nid_t ino, nid;
-	void *kaddr;
 	struct inode *inode;
-	struct page *node_page;
 	unsigned int offset;
 	block_t bidx;
 	int i;
@@ -238,18 +238,15 @@ static int check_index_in_prev_nodes(struct f2fs_sb_info *sbi,
 		struct curseg_info *curseg = CURSEG_I(sbi, i);
 		if (curseg->segno == segno) {
 			sum = curseg->sum_blk->entries[blkoff];
-			break;
+			goto got_it;
 		}
 	}
-	if (i > CURSEG_COLD_DATA) {
-		struct page *sum_page = get_sum_page(sbi, segno);
-		struct f2fs_summary_block *sum_node;
-		kaddr = page_address(sum_page);
-		sum_node = (struct f2fs_summary_block *)kaddr;
-		sum = sum_node->entries[blkoff];
-		f2fs_put_page(sum_page, 1);
-	}
 
+	sum_page = get_sum_page(sbi, segno);
+	sum_node = (struct f2fs_summary_block *)page_address(sum_page);
+	sum = sum_node->entries[blkoff];
+	f2fs_put_page(sum_page, 1);
+got_it:
 	/* Use the locked dnode page and inode */
 	nid = le32_to_cpu(sum.nid);
 	if (dn->inode->i_ino == nid) {
-- 
1.8.4.474.g128a96c

