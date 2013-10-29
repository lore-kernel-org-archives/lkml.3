Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab3J2A5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 20:57:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21465 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab3J2A46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 20:56:58 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7f836d000001b39-40-526f07d03b8f
Content-transfer-encoding: 8BIT
Message-id: <1383008170.14041.0.camel@kjgkr>
Subject: Re: [f2fs-dev 3/5] f2fs: Add a new function: f2fs_reserve_block()
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Huajun Li <huajun.li.lee@gmail.com>
Cc: linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Weihong Xu <weihong.xu@intel.com>
Date: Tue, 29 Oct 2013 09:56:10 +0900
In-reply-to: <CA+v9cxYx35Q=PS4wB52JSWj75T9xg_VYp9PySujZNhPWxj9jAA@mail.gmail.com>
References: <1382716919-23345-1-git-send-email-huajun.li.lee@gmail.com>
 <1382716919-23345-4-git-send-email-huajun.li.lee@gmail.com>
 <1382962607.992.104.camel@kjgkr> <1382963296.992.108.camel@kjgkr>
 <CA+v9cxYx35Q=PS4wB52JSWj75T9xg_VYp9PySujZNhPWxj9jAA@mail.gmail.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t8zI90L7PlBBmcW8lq8PKRpceZZB6PF
	li0xFl/777BZXFrkbrFn70kWi8u75rBZbDr5i9WBw2PnrLvsHov3vGTymHcy0GP3gs9MHn1b
	VjF6fN4kF8AWxWWTkpqTWZZapG+XwJWx5PdftoIr5hXLTwU1ME5Q7WLk5JAQMJFoPXOREcIW
	k7hwbz1bFyMXh5DAMkaJuWdXMsEV7XvPDpGYzijx4tc9FpAEr4CgxI/JIDYHB7OAvMSRS9kg
	YWYBdYlJ8xYxQ9S/YpR42TCPEaJeR+LEioNgQ4UFvCQevl3ABNLLJqAtsXm/AUhYSEBR4u3+
	u6wgtgjQnNcv5rJCzOxjklh2AKyVRUBVYvbUiWAjOQWCJfZ/XsYEsWsCk8Tae0/YQBL8AqIS
	hxduZ4Z4QElid3sn2AMSAl/ZJS49msQCMUlA4tvkQ2APSAjISmw6AFUvKXFwxQ2WCYwSs5C8
	OQvhzVlI3lzAyLyKUTS1ILmgOCm9yFivODG3uDQvXS85P3cTIyRe+3cw3j1gfYgxGWjjRGYp
	0eR8YLznlcQbGpsZWZiamBobmVuakSasJM57/2FSkJBAemJJanZqakFqUXxRaU5q8SFGJg5O
	qQbGhn99n7k2THh+dkt8ZqlZvN45wVol/2TpdfOSdnpFvzvI98bh85PJirU7tI0v9xWIWxa/
	KhP5WXPlWk2Her6HTmfRwvyra56dst6QtiHS8d3d81Gi01/HM1w7Lytj9eijRux5lQO/RZxa
	pTX+lDlvUYxdcsH9vX5JvFN0Qkzp8Udfldnmq7crsRRnJBpqMRcVJwIAgqDVEe0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jQd0L7PlBBi0v2S1eHtK0OPOsg9Fi
	y5YYi6/9d9gsLi1yt9iz9ySLxeVdc9gsNp38xerA4bFz1l12j8V7XjJ5zDsZ6LF7wWcmj74t
	qxg9Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAG6RkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYseT3X7aCK+YV
	y08FNTBOUO1i5OSQEDCRaN33nh3CFpO4cG89WxcjF4eQwHRGiRe/7rGAJHgFBCV+TAaxOTiY
	BeQljlzKBgkzC6hLTJq3iBmi/hWjxMuGeYwQ9ToSJ1YcZAKxhQW8JB6+XcAE0ssmoC2xeb8B
	SFhIQFHi7f67rCC2CNCc1y/mskLM7GOSWHYArJVFQFVi9tSJYCM5BYIl9n9exgSxawKTxNp7
	T9hAEvwCohKHF25nhnhASWJ3eyf7BEahWUjOnoVw9iwkZy9gZF7FKJpakFxQnJSea6RXnJhb
	XJqXrpecn7uJEZwMnknvYFzVYHGIUYCDUYmH14ItP0iINbGsuDL3EKMEB7OSCO/+zXlBQrwp
	iZVVqUX58UWlOanFhxiTgS6fyCwlmpwPTFR5JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJI
	TyxJzU5NLUgtgtnCxMEp1cCYk2TU47+nf9cbPg+2iE3bZHLSj231fPQ9+ZdMrGByRXqHyKX1
	3fv8VJ+IPO5YYych3xOcpfPq/mOn9598xcXfXC6X/6z0QvqBrNRyy7anu/57W0859f91XvgU
	0zczc999Kw88c4wncKps7PLerY3lLLrnJG6JywS/r0rWEI9qe6KxWS1ONk2JpTgj0VCLuag4
	EQAFtIgySgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huajun,

2013-10-29 (화), 00:53 +0800, Huajun Li:
> Hi Jaegeuk,
> 
> Thanks for your kindly review and comments.
> 
> On Mon, Oct 28, 2013 at 8:28 PM, Jaegeuk Kim <jaegeuk.kim@samsung.com> wrote:
> > 2013-10-28 (월), 21:16 +0900, Jaegeuk Kim:
> > Hi,
> >
> >>
> >> 2013-10-26 (토), 00:01 +0800, Huajun Li:
> >> > From: Huajun Li <huajun.li@intel.com>
> >> >
> >> > Add the function f2fs_reserve_block() to easily reserve new blocks.
> >> >
> >> > Signed-off-by: Huajun Li <huajun.li@intel.com>
> >> > Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> >> > Signed-off-by: Weihong Xu <weihong.xu@intel.com>
> >> > ---
> >> >  fs/f2fs/data.c |   29 ++++++++++++++++++-----------
> >> >  fs/f2fs/f2fs.h |    1 +
> >> >  2 files changed, 19 insertions(+), 11 deletions(-)
> >> >
> >> > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> >> > index c8887d8..7b31911 100644
> >> > --- a/fs/f2fs/data.c
> >> > +++ b/fs/f2fs/data.c
> >> > @@ -64,6 +64,23 @@ int reserve_new_block(struct dnode_of_data *dn)
> >> >     return 0;
> >> >  }
> >> >
> >> > +int f2fs_reserve_block(struct inode *inode,
> >> > +                  struct dnode_of_data *dn, pgoff_t index)
> >>
> >
> > We don't need to get dnode_of_data from parameters, since it is
> > used by this function only.
> 
> After calling f2fs_reserve_block(), we need dn.data_blkaddr to check
> whether it is NEW_ADDR. So IMO, it's nice to keep this parameter.
> 

Ah, got it.
BTW, I found another flows we can clean up wrt this issue.
How about this?

---
 fs/f2fs/data.c | 51 +++++++++++++++++++++++----------------------------
 fs/f2fs/f2fs.h |  1 +
 fs/f2fs/file.c | 39 ++++++---------------------------------
 3 files changed, 30 insertions(+), 61 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index c8887d8..b8c4f76d 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -64,6 +64,22 @@ int reserve_new_block(struct dnode_of_data *dn)
        return 0;
 }
 
+int f2fs_reserve_block(struct dnode_of_data *dn, pgoff_t index)
+{
+       bool need_put = dn->inode_page ? false : true;
+       int err;
+
+       err = get_dnode_of_data(dn, index, ALLOC_NODE);
+       if (err)
+               return err;
+       if (dn->data_blkaddr == NULL_ADDR)
+               err = reserve_new_block(dn);
+
+       if (need_put)
+               f2fs_put_dnode(dn);
+       return err;
+}
+
 static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
                                        struct buffer_head *bh_result)
 {
@@ -300,19 +316,9 @@ struct page *get_new_data_page(struct inode *inode,
        int err;
 
        set_new_dnode(&dn, inode, npage, npage, 0);
-       err = get_dnode_of_data(&dn, index, ALLOC_NODE);
+       err = f2fs_reserve_block(&dn, index);
        if (err)
                return ERR_PTR(err);
-
-       if (dn.data_blkaddr == NULL_ADDR) {
-               if (reserve_new_block(&dn)) {
-                       if (!npage)
-                               f2fs_put_dnode(&dn);
-                       return ERR_PTR(-ENOSPC);
-               }
-       }
-       if (!npage)
-               f2fs_put_dnode(&dn);
 repeat:
        page = grab_cache_page(mapping, index);
        if (!page)
@@ -644,21 +650,15 @@ repeat:
        *pagep = page;
 
        f2fs_lock_op(sbi);
-
        set_new_dnode(&dn, inode, NULL, NULL, 0);
-       err = get_dnode_of_data(&dn, index, ALLOC_NODE);
-       if (err)
-               goto err;
-
-       if (dn.data_blkaddr == NULL_ADDR)
-               err = reserve_new_block(&dn);
-
-       f2fs_put_dnode(&dn);
-       if (err)
-               goto err;
-
+       err = f2fs_reserve_block(&dn, index);
        f2fs_unlock_op(sbi);
 
+       if (err) {
+               f2fs_put_page(page, 1);
+               return err;
+       }
+
        if ((len == PAGE_CACHE_SIZE) || PageUptodate(page))
                return 0;
 
@@ -691,11 +691,6 @@ out:
        SetPageUptodate(page);
        clear_cold_data(page);
        return 0;
-
-err:
-       f2fs_unlock_op(sbi);
-       f2fs_put_page(page, 1);
-       return err;
 }
 
 static int f2fs_write_end(struct file *file,
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index c9d394c..e77ca20 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1112,6 +1112,7 @@ void destroy_checkpoint_caches(void);
  * data.c
  */
 int reserve_new_block(struct dnode_of_data *);
+int f2fs_reserve_block(struct dnode_of_data *, pgoff_t);
 void update_extent_cache(block_t, struct dnode_of_data *);
 struct page *find_data_page(struct inode *, pgoff_t, bool);
 struct page *get_lock_data_page(struct inode *, pgoff_t);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 2d4190a..21ef0d1 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -33,7 +33,6 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct
*vma,
        struct page *page = vmf->page;
        struct inode *inode = file_inode(vma->vm_file);
        struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-       block_t old_blk_addr;
        struct dnode_of_data dn;
        int err;
 
@@ -44,24 +43,10 @@ static int f2fs_vm_page_mkwrite(struct
vm_area_struct *vma,
        /* block allocation */
        f2fs_lock_op(sbi);
        set_new_dnode(&dn, inode, NULL, NULL, 0);
-       err = get_dnode_of_data(&dn, page->index, ALLOC_NODE);
-       if (err) {
-               f2fs_unlock_op(sbi);
-               goto out;
-       }
-
-       old_blk_addr = dn.data_blkaddr;
-
-       if (old_blk_addr == NULL_ADDR) {
-               err = reserve_new_block(&dn);
-               if (err) {
-                       f2fs_put_dnode(&dn);
-                       f2fs_unlock_op(sbi);
-                       goto out;
-               }
-       }
-       f2fs_put_dnode(&dn);
+       err = f2fs_reserve_block(&dn, page->index);
        f2fs_unlock_op(sbi);
+       if (err)
+               goto out;
 
        file_update_time(vma->vm_file);
        lock_page(page);
@@ -531,22 +516,10 @@ static int expand_inode_data(struct inode *inode,
loff_t offset,
 
                f2fs_lock_op(sbi);
                set_new_dnode(&dn, inode, NULL, NULL, 0);
-               ret = get_dnode_of_data(&dn, index, ALLOC_NODE);
-               if (ret) {
-                       f2fs_unlock_op(sbi);
-                       break;
-               }
-
-               if (dn.data_blkaddr == NULL_ADDR) {
-                       ret = reserve_new_block(&dn);
-                       if (ret) {
-                               f2fs_put_dnode(&dn);
-                               f2fs_unlock_op(sbi);
-                               break;
-                       }
-               }
-               f2fs_put_dnode(&dn);
+               ret = f2fs_reserve_block(&dn, index);
                f2fs_unlock_op(sbi);
+               if (ret)
+                       break;
 
                if (pg_start == pg_end)
                        new_size = offset + len;
-- 
1.8.4.474.g128a96c

-- 
Jaegeuk Kim
Samsung

