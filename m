Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab3LZLiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 06:38:20 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:55067 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3LZLiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 06:38:18 -0500
X-AuditID: cbfee68f-b7f156d00000276c-93-52bc1523919c
Message-id: <1388057821.2101.307.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH v2] f2fs: introduce F2FS_INODE macro to get
 f2fs_inode
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Thu, 26 Dec 2013 20:37:01 +0900
In-reply-to: <000101cf021c$72cdbf20$58693d60$@samsung.com>
References: <1388045841-32165-1-git-send-email-jaegeuk.kim@samsung.com>
 <000101cf021c$72cdbf20$58693d60$@samsung.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t8zQ11l0T1BBm2XhC3+N31ks7i0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZUx4/pq14IhFxa31
	lQ2MT3W7GDk4JARMJJ7szOti5AQyxSQu3FvP1sXIxSEksIxRYt2bBjaIhInEvLM7mSAS0xkl
	jty/xgzhvGKU2Pn/ARNIFa+ArsTRny0sILawQLjEmpYpLCAb2AS0JTbvNwAJCwkoSrzdf5cV
	xBYRUJL4NX8RmM0skCkx5/VkMJtFQFViQ99ZsMWcAlYS7/++Z4LoLZfY9OcEM4jNLyAqcXjh
	dmaIXnWJSfMWMUMcqiSxu72THSIuL7F5zVtmiNMEJX5MvscCcrOEwD52iecndrJBLBOQ+Db5
	EAskJGQlNh2AmiMpcXDFDZYJjBKzkKyYhWTsLCRjFzAyr2IUTS1ILihOSi8y1itOzC0uzUvX
	S87P3cQIibf+HYx3D1gfYkwGWjmRWUo0OR8Yr3kl8YbGZkYWpiamxkbmlmakCSuJ895/mBQk
	JJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbGU59DhSNHFEwWePYyYetyR3f9CRmeCafTztaae
	c1r+xDUoSPMvjp5j/G3DHx7RTxoHjDhbZrb9PZM18/eyT0qu83s+vwjRq3VxY1nWctX6b4Pa
	mTV24avubLnwkFGetVz4dV34VJFp619vP1/Atlb0TXG5x+59IlMyeGeb+tRKG3+9eYflyDMl
	luKMREMt5qLiRABlgSgRzQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jQV1l0T1BBps6+C3+N31ks7i0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWZMeP6ateCIRcWt9ZUNjE91uxg5OSQETCTmnd3JBGGLSVy4t56ti5GLQ0hg
	OqPEkfvXmCGcV4wSO/8/AKviFdCVOPqzhQXEFhYIl1jTMgXI5uBgE9CW2LzfACQsJKAo8Xb/
	XVYQW0RASeLX/EVgNrNApsSc15PBbBYBVYkNfWfZQGxOASuJ93/fM0H0lkts+nOCGcTmFxCV
	OLxwOzNEr7rEpHmLmCEOVZLY3d7JDhGXl9i85i0zxGmCEj8m32OZwCg0C0nLLCRls5CULWBk
	XsUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHM/PpHcwrmqwOMQowMGoxMPbobs7SIg1say4
	MvcQowQHs5II76R3QCHelMTKqtSi/Pii0pzU4kOMyUDfTWSWEk3OB6aavJJ4Q2MTMyNLIzML
	IxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgjN5XOPtDXvqnHQb1+5Zv9PdfUzit
	aMrSs22K3xY7Hl/zdjPXOakMvflbEsov354ZMqVk1ePqN0WLLbyjlgXurX6VGsUtV5ajd+Ym
	k3Guy3f7hZE53b5p9hHdk5Psc2u/NOoZCLt871bye7rML//3puM7TJfkuLHcuL9n5q3fcgX/
	rDVKue7GKbEUZyQaajEXFScCAGqunDUrAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Nice catch. :)

Change log from v1:
 o handle recover_inode_page too

>From 58bfaf44df58082c72882b235cae611c975537d4 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date: Thu, 26 Dec 2013 16:30:41 +0900
Subject: [PATCH] f2fs: introduce F2FS_INODE macro to get f2fs_inode

This patch introduces F2FS_INODE that returns struct f2fs_inode * from
the inode
page.
By using this macro, we can remove unnecessary casting codes like below.

   struct f2fs_inode *ri = &F2FS_NODE(inode_page)->i;
-> struct f2fs_inode *ri = F2FS_INODE(inode_page);

Reviewed-by: Chao Yu <chao2.yu@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/dir.c      |  8 ++++----
 fs/f2fs/f2fs.h     |  5 +++++
 fs/f2fs/inode.c    |  8 ++------
 fs/f2fs/node.c     | 30 +++++++++++++++---------------
 fs/f2fs/recovery.c |  6 ++----
 5 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index f0b4630..6da77e5 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -261,12 +261,12 @@ void f2fs_set_link(struct inode *dir, struct
f2fs_dir_entry *de,
 
 static void init_dent_inode(const struct qstr *name, struct page
*ipage)
 {
-	struct f2fs_node *rn;
+	struct f2fs_inode *ri;
 
 	/* copy name info. to this inode page */
-	rn = F2FS_NODE(ipage);
-	rn->i.i_namelen = cpu_to_le32(name->len);
-	memcpy(rn->i.i_name, name->name, name->len);
+	ri = F2FS_INODE(ipage);
+	ri->i_namelen = cpu_to_le32(name->len);
+	memcpy(ri->i_name, name->name, name->len);
 	set_page_dirty(ipage);
 }
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index ba91186..1a06f0a 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -498,6 +498,11 @@ static inline struct f2fs_node *F2FS_NODE(struct
page *page)
 	return (struct f2fs_node *)page_address(page);
 }
 
+static inline struct f2fs_inode *F2FS_INODE(struct page *page)
+{
+	return &((struct f2fs_node *)page_address(page))->i;
+}
+
 static inline struct f2fs_nm_info *NM_I(struct f2fs_sb_info *sbi)
 {
 	return (struct f2fs_nm_info *)(sbi->nm_info);
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index d0eaa9f..a91f451 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -67,7 +67,6 @@ static int do_read_inode(struct inode *inode)
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct f2fs_inode_info *fi = F2FS_I(inode);
 	struct page *node_page;
-	struct f2fs_node *rn;
 	struct f2fs_inode *ri;
 
 	/* Check if ino is within scope */
@@ -81,8 +80,7 @@ static int do_read_inode(struct inode *inode)
 	if (IS_ERR(node_page))
 		return PTR_ERR(node_page);
 
-	rn = F2FS_NODE(node_page);
-	ri = &(rn->i);
+	ri = F2FS_INODE(node_page);
 
 	inode->i_mode = le16_to_cpu(ri->i_mode);
 	i_uid_write(inode, le32_to_cpu(ri->i_uid));
@@ -175,13 +173,11 @@ bad_inode:
 
 void update_inode(struct inode *inode, struct page *node_page)
 {
-	struct f2fs_node *rn;
 	struct f2fs_inode *ri;
 
 	f2fs_wait_on_page_writeback(node_page, NODE, false);
 
-	rn = F2FS_NODE(node_page);
-	ri = &(rn->i);
+	ri = F2FS_INODE(node_page);
 
 	ri->i_mode = cpu_to_le16(inode->i_mode);
 	ri->i_advise = F2FS_I(inode)->i_advise;
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e8fe52d..9405a17 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -684,7 +684,7 @@ int truncate_inode_blocks(struct inode *inode,
pgoff_t from)
 	int err = 0, cont = 1;
 	int level, offset[4], noffset[4];
 	unsigned int nofs = 0;
-	struct f2fs_node *rn;
+	struct f2fs_inode *ri;
 	struct dnode_of_data dn;
 	struct page *page;
 
@@ -701,7 +701,7 @@ restart:
 	set_new_dnode(&dn, inode, page, NULL, 0);
 	unlock_page(page);
 
-	rn = F2FS_NODE(page);
+	ri = F2FS_INODE(page);
 	switch (level) {
 	case 0:
 	case 1:
@@ -711,7 +711,7 @@ restart:
 		nofs = noffset[1];
 		if (!offset[level - 1])
 			goto skip_partial;
-		err = truncate_partial_nodes(&dn, &rn->i, offset, level);
+		err = truncate_partial_nodes(&dn, ri, offset, level);
 		if (err < 0 && err != -ENOENT)
 			goto fail;
 		nofs += 1 + NIDS_PER_BLOCK;
@@ -720,7 +720,7 @@ restart:
 		nofs = 5 + 2 * NIDS_PER_BLOCK;
 		if (!offset[level - 1])
 			goto skip_partial;
-		err = truncate_partial_nodes(&dn, &rn->i, offset, level);
+		err = truncate_partial_nodes(&dn, ri, offset, level);
 		if (err < 0 && err != -ENOENT)
 			goto fail;
 		break;
@@ -730,7 +730,7 @@ restart:
 
 skip_partial:
 	while (cont) {
-		dn.nid = le32_to_cpu(rn->i.i_nid[offset[0] - NODE_DIR1_BLOCK]);
+		dn.nid = le32_to_cpu(ri->i_nid[offset[0] - NODE_DIR1_BLOCK]);
 		switch (offset[0]) {
 		case NODE_DIR1_BLOCK:
 		case NODE_DIR2_BLOCK:
@@ -753,14 +753,14 @@ skip_partial:
 		if (err < 0 && err != -ENOENT)
 			goto fail;
 		if (offset[1] == 0 &&
-				rn->i.i_nid[offset[0] - NODE_DIR1_BLOCK]) {
+				ri->i_nid[offset[0] - NODE_DIR1_BLOCK]) {
 			lock_page(page);
 			if (unlikely(page->mapping != node_mapping)) {
 				f2fs_put_page(page, 1);
 				goto restart;
 			}
 			wait_on_page_writeback(page);
-			rn->i.i_nid[offset[0] - NODE_DIR1_BLOCK] = 0;
+			ri->i_nid[offset[0] - NODE_DIR1_BLOCK] = 0;
 			set_page_dirty(page);
 			unlock_page(page);
 		}
@@ -1533,7 +1533,7 @@ void recover_node_page(struct f2fs_sb_info *sbi,
struct page *page,
 int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
 {
 	struct address_space *mapping = sbi->node_inode->i_mapping;
-	struct f2fs_node *src, *dst;
+	struct f2fs_inode *src, *dst;
 	nid_t ino = ino_of_node(page);
 	struct node_info old_ni, new_ni;
 	struct page *ipage;
@@ -1549,14 +1549,14 @@ int recover_inode_page(struct f2fs_sb_info *sbi,
struct page *page)
 	SetPageUptodate(ipage);
 	fill_node_footer(ipage, ino, ino, 0, true);
 
-	src = F2FS_NODE(page);
-	dst = F2FS_NODE(ipage);
+	src = F2FS_INODE(page);
+	dst = F2FS_INODE(ipage);
 
-	memcpy(dst, src, (unsigned long)&src->i.i_ext - (unsigned
long)&src->i);
-	dst->i.i_size = 0;
-	dst->i.i_blocks = cpu_to_le64(1);
-	dst->i.i_links = cpu_to_le32(1);
-	dst->i.i_xattr_nid = 0;
+	memcpy(dst, src, (unsigned long)&src->i_ext - (unsigned long)src);
+	dst->i_size = 0;
+	dst->i_blocks = cpu_to_le64(1);
+	dst->i_links = cpu_to_le32(1);
+	dst->i_xattr_nid = 0;
 
 	new_ni = old_ni;
 	new_ni.ino = ino;
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 4d411a2..96e690b6 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -40,8 +40,7 @@ static struct fsync_inode_entry
*get_fsync_inode(struct list_head *head,
 
 static int recover_dentry(struct page *ipage, struct inode *inode)
 {
-	struct f2fs_node *raw_node = F2FS_NODE(ipage);
-	struct f2fs_inode *raw_inode = &(raw_node->i);
+	struct f2fs_inode *raw_inode = F2FS_INODE(ipage);
 	nid_t pino = le32_to_cpu(raw_inode->i_pino);
 	struct f2fs_dir_entry *de;
 	struct qstr name;
@@ -105,8 +104,7 @@ out:
 
 static int recover_inode(struct inode *inode, struct page *node_page)
 {
-	struct f2fs_node *raw_node = F2FS_NODE(node_page);
-	struct f2fs_inode *raw_inode = &(raw_node->i);
+	struct f2fs_inode *raw_inode = F2FS_INODE(node_page);
 
 	if (!IS_INODE(node_page))
 		return 0;
-- 
1.8.4.474.g128a96c



-- 
Jaegeuk Kim
Samsung

