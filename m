Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab3J1Mn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:43:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48103 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab3J1Mn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:43:56 -0400
X-AuditID: cbfee691-b7f866d000001b8c-79-526e5c0bc879
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1382964198.992.121.camel@kjgkr>
Subject: Re: [f2fs-dev 4/5] f2fs: Key functions to handle inline data
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Huajun Li <huajun.li.lee@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Weihong Xu <weihong.xu@intel.com>
Date: Mon, 28 Oct 2013 21:43:18 +0900
In-reply-to: <1382716919-23345-5-git-send-email-huajun.li.lee@gmail.com>
References: <1382716919-23345-1-git-send-email-huajun.li.lee@gmail.com>
 <1382716919-23345-5-git-send-email-huajun.li.lee@gmail.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t8zA13umLwggw1zuSxeHtK0OPOsg9Fi
	y5YYi6/9d9gsLi1yt9iz9ySLxeVdc9gsNp38xerA4bFz1l12j8V7XjJ5zDsZ6LF7wWcmj74t
	qxg9Pm+SC2CL4rJJSc3JLEst0rdL4Mr4fmYfa8ERpYp18zpZGhhXSncxcnBICJhIvJsu18XI
	CWSKSVy4t56ti5GLQ0hgGaPEwt7LbDA1J07mQsQXMUocm9PGBNLAKyAo8WPyPRYQm1lAXWLS
	vEXMELaIxJ1b3xghbG2JZQtfM0M0v2KUODP3PjNEs47E4Ylt7CC2sICrROfx4ywgy9iAGjbv
	NwAJCwkoSrzdf5cVxBYBmv/6xVxWkDnMArcYJR62HgFbzCKgKrH4xD8wm1PAQ+J80zyoZa2M
	Eke2vAJbxi8gKnF44XZmiDeVJHa3d7KDFEkI/GSXaDn5nQ1ikoDEt8mHWCBelpXYdACqXlLi
	4IobLBMYJWcheXoWkqdnIXl6FpKnFzCyrGIUTS1ILihOSi8y1StOzC0uzUvXS87P3cQIifGJ
	OxjvH7A+xJgMtH4is5Rocj4wReSVxBsamxlZmJqYGhuZW5qRJqwkzpv+KClISCA9sSQ1OzW1
	ILUovqg0J7X4ECMTB6dUA+OS8m+3PlbM/FWa6me5u441VujZeWFvrryAjca+s6Z45LTk6bRk
	nLi9+/GXicL/dlqvOaRqxL0wXKh7UaGmiNHcN99v/pmurLJeeJfL2W/2e96aVYqxNOhxugSL
	cxrvW7DvncVyzhfvH662fXjP5G2z6v0jvw9aV9pUpARc3SUj0fFO3N1e8poSS3FGoqEWc1Fx
	IgCDN2vlBwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jAV3umLwgg5YHLBYvD2lanHnWwWix
	ZUuMxdf+O2wWlxa5W+zZe5LF4vKuOWwWm07+YnXg8Ng56y67x+I9L5k85p0M9Ni94DOTR9+W
	VYwenzfJBbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gBdo6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMuN3/mq1gllLF
	78nLWRsY/0t1MXJwSAiYSJw4mdvFyAlkiklcuLeerYuRi0NIYBGjxLE5bUwgCV4BQYkfk++x
	gNQzC8hLHLmUDRJmFlCXmDRvETNE/StGiTNz7zND1OtIHJ7Yxg5iCwu4SnQePw7WyyagLbF5
	vwFIWEhAUeLt/rusILYI0JzXL+aygsxhFrjFKPGw9QgLSIJFQFVi8Yl/YDangIfE+aZ5UMta
	GSWObHkFtoxfQFTi8MLtzBAfKEnsbu9kn8AoNAvJ3bMQ7p6F5O4FjMyrGEVTC5ILipPScw31
	ihNzi0vz0vWS83M3MYLTwTOpHYwrGywOMQpwMCrx8G5YmxskxJpYVlyZe4hRgoNZSYTXwz4v
	SIg3JbGyKrUoP76oNCe1+BBjMtDlE5mlRJPzgakqryTe0NjEzMjSyMzCyMTcnDRhJXHeA63W
	gUIC6YklqdmpqQWpRTBbmDg4pRoYjzk+Mti+46G7wJ2wtMCTrBLcFnftHfUykkKuBDgEPZjw
	+PcPScmTUeW5H5gC+Wr+bTdcw78osPRjX7Ku7J3/5z91Ju+wF35yvGvyx1cSIqeM3Wt2vcn6
	uHUvh3e/6/n8t3EMTkf3tT24dFRV7FHXq9YptdsSvh6oFzU5/6tEO7vBcfa1nJW+SizFGYmG
	WsxFxYkAfMxiGEsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-10-26 (토), 00:01 +0800, Huajun Li:
> From: Huajun Li <huajun.li@intel.com>
> 
> Functions to implement inline data read/write, and move inline data to
> normal data block when file size exceeds inline data limitation.
> 
> Signed-off-by: Huajun Li <huajun.li@intel.com>
> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> Signed-off-by: Weihong Xu <weihong.xu@intel.com>
> ---
>  fs/f2fs/Makefile |    2 +-
>  fs/f2fs/f2fs.h   |    7 +++
>  fs/f2fs/inline.c |  144 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 152 insertions(+), 1 deletion(-)
>  create mode 100644 fs/f2fs/inline.c
> 

[snip]

> +static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
> +{
> +	int err;
> +	struct page *ipage;
> +	struct dnode_of_data dn;
> +	void *src_addr, *dst_addr;
> +	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> +

Here..	f2fs_lock_op(sbi);

> +	ipage = get_node_page(sbi, inode->i_ino);
> +	if (IS_ERR(ipage))
> +		return PTR_ERR(ipage);
> +

Need to move f2fs_lock_op prior to get_node_page.

> +	/* i_addr[0] is not used for inline data,

Coding style.
         /*
          * ...
          */

> +	 * so reserving new block will not destroy inline data */
> +	err = f2fs_reserve_block(inode, &dn, 0);
> +	if (err) {
> +		f2fs_put_page(ipage, 1);
> +		f2fs_unlock_op(sbi);
> +		return err;
> +	}

Need to move this too.

> +
> +	src_addr = inline_data_addr(ipage);
> +	dst_addr = page_address(page);
> +	zero_user_segment(page, 0, PAGE_CACHE_SIZE);

+ space for readability.

> +	/* Copy the whole inline data block */
> +	memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
> +	zero_user_segment(ipage, INLINE_DATA_OFFSET,
> +				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
> +	clear_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
> +	set_raw_inline(F2FS_I(inode),
> +			(struct f2fs_inode *)page_address(ipage));

   --> sync_inode_page()?

> +
> +	set_page_dirty(ipage);
> +	f2fs_put_page(ipage, 1);
> +	set_page_dirty(page);

Here...	f2fs_unlock_op(sbi);

Here, we need to consider data consistency.
Let's think about the below scenario.
1. inline_data was written.
2. sync_fs is done.
3. additional data were written.
  : this triggers f2fs_convert_inline_data(), produces a page, and then
unsets the inline flag.
4. checkpoint was done with updated inode page. Note that, checkpoint
doesn't guarantee any user data.
5. sudden power-off is occurred.
  -> Once power-off-recovery is done, we loose the inline_data which was
written successfully at step #2.

So, I think we need to do f2fs_sync_file() procedure at this moment.
Any idea?

> +
> +	return 0;
> +}
> +
> +int f2fs_convert_inline_data(struct inode *inode,
> +			     struct page *p, unsigned flags)
> +{
> +	int err;
> +	struct page *page;
> +
> +	if (p && !p->index) {
> +		page = p;
> +	} else {
> +		page = grab_cache_page_write_begin(inode->i_mapping, 0, flags);
> +		if (IS_ERR(page))
> +			return PTR_ERR(page);
> +	}
> +
> +	err = __f2fs_convert_inline_data(inode, page);
> +
> +	if (p && !p->index)
> +		f2fs_put_page(page, 1);
> +
> +	return err;
> +}
> +
> +int f2fs_write_inline_data(struct inode *inode,
> +			   struct page *page, unsigned size)
> +{
> +	void *src_addr, *dst_addr;
> +	struct page *ipage;
> +	struct dnode_of_data dn;
> +	int err;
> +
> +	set_new_dnode(&dn, inode, NULL, NULL, 0);
> +	err = get_dnode_of_data(&dn, 0, LOOKUP_NODE);
> +	if (err)
> +		return err;
> +	ipage = dn.inode_page;
> +
> +	src_addr = page_address(page);
> +	dst_addr = inline_data_addr(ipage);
> +
> +	zero_user_segment(ipage, INLINE_DATA_OFFSET,
> +				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
> +	memcpy(dst_addr, src_addr, size);
> +	if (!f2fs_has_inline_data(inode))
> +		set_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
> +	set_raw_inline(F2FS_I(inode),
> +			(struct f2fs_inode *)page_address(ipage));
> +	set_page_dirty(ipage);
> +
> +	if ((F2FS_I(inode)->i_xattr_nid && inode->i_blocks == 2) ||
> +		(!F2FS_I(inode)->i_xattr_nid && inode->i_blocks == 1)) {
> +		f2fs_put_dnode(&dn);
> +		return 0;
> +	}
> +
> +	/* Release the first data block if it is allocated */
> +	truncate_data_blocks_range(&dn, 1);
> +	f2fs_put_dnode(&dn);
> +
> +	return 0;
> +}

-- 
Jaegeuk Kim
Samsung

