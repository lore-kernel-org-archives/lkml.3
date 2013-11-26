Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab3KZHqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 02:46:10 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:41371 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab3KZHqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 02:46:06 -0500
X-AuditID: cbfee68f-b7f336d00000481b-f1-529451b8e3ed
Message-id: <1385451905.2417.3.camel@kjgkr>
Subject: Re: [f2fs-dev][PATCH V2 0/6] f2fs: Enable f2fs support inline data
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Huajun Li <huajun.li.lee@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Huajun Li <huajun.li@intel.com>
Date: Tue, 26 Nov 2013 16:45:05 +0900
In-reply-to: <1384096401-25169-1-git-send-email-huajun.li.lee@gmail.com>
References: <1384096401-25169-1-git-send-email-huajun.li.lee@gmail.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zI90dgVOCDF7e5LV4eUjTYsuWGIuv
	/XfYLC4tcrfYs/cki8XlXXPYHNg8ds66y+6xeM9LJo/dCz4zefRtWcXo8XmTXABrFJdNSmpO
	Zllqkb5dAlfGz6O/WAt+yVb0b/vN3MA4U6KLkYNDQsBE4tEijS5GTiBTTOLCvfVsXYxcHEIC
	yxgl1u89xgqRMJE4dukSE0RiOqPE0tdnmSGcV4wSF1pPMoFU8QpoS7x8fokZxBYW8Ja40PWE
	BWQDG1B8834DkLCQgKLE2/13wYaKCKhLvH4xlxVkDrNAF6PEk1vdYL0sAqoST79eYATp5RTw
	kPi/QRGi113i2N+fYL38AqIShxduBytnBpozad4iZohDlSR2t3eyQ8TlJTavecsMcZqgxI/J
	91ggau6xS7xZkwaxSkDi2+RDLJCAkJXYdABqjKTEwRU3WCYwSsxCsmEWkqmzkExdwMi8ilE0
	tSC5oDgpvchYrzgxt7g0L10vOT93EyMkJvt3MN49YH2IMRlo5URmKdHkfGBM55XEGxqbGVmY
	mpgaG5lbmpEmrCTOe/9hUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxr1G/cqXVs5e1lCz
	SKDI3yt/m3KyoV5PhPmqU3uj3u5PzH0WnL5pdplm4MnTmVzPPufHG9pIbC1qvGCt+Ds2dY7w
	Nf6IZoFy1o73cfsd53zotDjnZXfkwNY9Xle/XN31zLeqPmXBGxGB1WLb+qY/0lwwnSn2UKn6
	9Q17a1KU77kZ2lusKGTYo8RSnJFoqMVcVJwIAAoqUhbfAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jQd0dgVOCDObe5bB4eUjTYsuWGIuv
	/XfYLC4tcrfYs/cki8XlXXPYHNg8ds66y+6xeM9LJo/dCz4zefRtWcXo8XmTXABrVAOjTUZq
	YkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QfiWFssScUqBQ
	QGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxs+jv1gLfslW9G/7zdzAOFOii5GTQ0LA
	ROLYpUtMELaYxIV769m6GLk4hASmM0osfX2WGcJ5xShxofUkWBWvgLbEy+eXmEFsYQFviQtd
	T1i6GDk42IDim/cbgISFBBQl3u6/ywpiiwioS7x+MZcVZA6zQBejxJNb3WC9LAKqEk+/XmAE
	6eUU8JD4v0ERotdd4tjfn2C9/AKiEocXbgcrZwaaM2neImaIQ5Ukdrd3skPE5SU2r3nLDHGa
	oMSPyfdYJjAKzULSMgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEf9M6kd
	jCsbLA4xCnAwKvHwSnRODhJiTSwrrsw9xCjBwawkwut6HyjEm5JYWZValB9fVJqTWnyIMRno
	uYnMUqLJ+cCElFcSb2hsYmZkaWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFIN
	jKnetr9ftgpNNm5elWbVZFSr5ckTX5y47PvG4HXhjk5Tpz2bFbd2QuG9G/639l4UFIv+s958
	1to7nr0XHqyK1t95lnv+92et3Zz2P0S/+Ox8YPFo48cX035dDo6dWrfsampzZEny2xdzvtSb
	hoR4XI/85PhC7ujvdWqzv/Q8mvb6s/jfuQ8enxJSYinOSDTUYi4qTgQALVn/QT4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huajun,

Please adjust the following bug fixes in your patches.

---
 fs/f2fs/data.c   |  2 +-
 fs/f2fs/file.c   | 12 +++++++-----
 fs/f2fs/inline.c | 19 +++++++++++--------
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 2eed6e3..e44f0ba 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -534,8 +534,8 @@ static int get_data_block_ro(struct inode *inode,
sector_t iblock,
 
 static int f2fs_read_data_page(struct file *file, struct page *page)
 {
+	struct inode *inode = page->mapping->host;
 	int ret;
-	struct inode *inode = file->f_mapping->host;

>> The file pointer is NULL if this page contains file's symlink data,
which induces NULL pointer error.
 
 	/* If the file has inline data, try to read it directlly */
 	if (f2fs_has_inline_data(inode))
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index ffafcb9..52bb211 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -257,8 +257,7 @@ static int truncate_blocks(struct inode *inode, u64
from)
 	unsigned int blocksize = inode->i_sb->s_blocksize;
 	struct dnode_of_data dn;
 	pgoff_t free_from;
-	int count = 0;
-	int err;
+	int count = 0, err = 0;
 
 	trace_f2fs_truncate_blocks_enter(inode, from);
 
@@ -266,6 +265,10 @@ static int truncate_blocks(struct inode *inode, u64
from)
 			((from + blocksize - 1) >> (sbi->log_blocksize));
 
 	f2fs_lock_op(sbi);
+
+	if (f2fs_has_inline_data(inode))
+		goto done;
+

>> We don't need to do the below actions. Let's skip that.

 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err = get_dnode_of_data(&dn, free_from, LOOKUP_NODE);
 	if (err) {
@@ -291,9 +294,8 @@ static int truncate_blocks(struct inode *inode, u64
from)
 
 	f2fs_put_dnode(&dn);
 free_next:
-
-	if (!f2fs_has_inline_data(inode))
-		err = truncate_inode_blocks(inode, free_from);
+	err = truncate_inode_blocks(inode, free_from);
+done:
 	f2fs_unlock_op(sbi);
 
 	/* lastly zero out the first data page */
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index e9b33d7..6c301cc 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -48,13 +48,14 @@ int f2fs_read_inline_data(struct inode *inode,
struct page *page)
 	if (IS_ERR(ipage))
 		return PTR_ERR(ipage);
 
-	src_addr = inline_data_addr(ipage);
-	dst_addr = page_address(page);
-
 	zero_user_segment(page, INLINE_DATA_OFFSET,
 				INLINE_DATA_OFFSET + MAX_INLINE_DATA);
+
 	/* Copy the whole inline data block */
+	src_addr = inline_data_addr(ipage);
+	dst_addr = kmap(page);
 	memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
+	kunmap(page);

>> We should do kmap/kunmap for normal data pages.

 	f2fs_put_page(ipage, 1);
 
 	SetPageUptodate(page);
@@ -89,12 +90,13 @@ static int __f2fs_convert_inline_data(struct inode
*inode, struct page *page)
 		return err;
 	}
 
-	src_addr = inline_data_addr(ipage);
-	dst_addr = page_address(page);
 	zero_user_segment(page, 0, PAGE_CACHE_SIZE);
 
 	/* Copy the whole inline data block */
+	src_addr = inline_data_addr(ipage);
+	dst_addr = kmap(page);
 	memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
+	kunmap(page);

>> ditto.
 
 	/* write data page to try to make data consistent */
 	old_blk_addr = dn.data_blkaddr;
@@ -152,12 +154,13 @@ int f2fs_write_inline_data(struct inode *inode,
 		return err;
 	ipage = dn.inode_page;
 
-	src_addr = page_address(page);
-	dst_addr = inline_data_addr(ipage);
-
 	zero_user_segment(ipage, INLINE_DATA_OFFSET,
 				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
+
+	src_addr = kmap(page);
+	dst_addr = inline_data_addr(ipage);
 	memcpy(dst_addr, src_addr, size);
+	kunmap(page);

>> ditto.
 
 	/* Release the first data block if it is allocated */
 	if (!f2fs_has_inline_data(inode)) {
-- 
1.8.4.474.g128a96c



-- 
Jaegeuk Kim
Samsung

