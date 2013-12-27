Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab3L0JXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 04:23:18 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:36823 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab3L0JXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 04:23:15 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7f156d00000276c-b8-52bd47028c40
Content-transfer-encoding: 8BIT
Message-id: <1388136123.2101.310.camel@kjgkr>
Subject: Re: [PATCH] f2fs: fix build warning for f2fs_has_inline_data()
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Haicheng Li <haicheng.li@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Huajun Li <huajun.li@intel.com>
Date: Fri, 27 Dec 2013 18:22:03 +0900
In-reply-to: <1388126708-27839-1-git-send-email-haicheng.li@linux.intel.com>
References: <1388126708-27839-1-git-send-email-haicheng.li@linux.intel.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t8zY10m971BBjd/iVu8PKRp8f75emaL
	GwvKLM4862C0+Np/h83i0iJ3iz17T7JYXN41h82Bw2PnrLvsHov3vGTymHcy0GP3gs9MHn1b
	VjF6fN4kF8AWxWWTkpqTWZZapG+XwJXxbMNqxoLVAhVNHd2sDYwLeLsYOTkkBEwk5k9tYYKw
	xSQu3FvP1sXIxSEksIxR4trLo4wwRTu2XmaHSCxilPiz+RErSIJXQFDix+R7LF2MHBzMAvIS
	Ry5lg4SZBdQlJs1bxAxR/4pR4lIDyFSQel2JHw/XM4PUCwu4SzyfxQdisgloS2zebwBSISSg
	KPF2/12w6SJA1RPfzmYCGcMscJNR4uWcV+wgCRYBVYnG3olgRZwCPhLrjp5ghmj2llj+4x5Y
	Db+AqMThhduZIe5Xktjd3gl2v4TAT3aJf/d3MUIMEpD4NvkQ2P0SArISmw5A1UtKHFxxg2UC
	o8QsJF/OQvhyFpIvFzAyr2IUTS1ILihOSi8y1itOzC0uzUvXS87P3cQIidf+HYx3D1gfYkwG
	2jiRWUo0OR8Y73kl8YbGZkYWpiamxkbmlmakCSuJ895/mBQkJJCeWJKanZpakFoUX1Sak1p8
	iJGJg1OqgXF1QYrUodDPH0z/rZh0u9N/3qxjgU9eLNNYqdolf1avJkt8446G8Estyjtneb4M
	sXyw8qTlrtJXrwKahEtK1u0rfuq0+Jrsw2CRTy+jX71Q/928WsoyquXtStPg1iABJcePx9aL
	Sst94132+bXxBYffK3z6Y0zilynGLzh24gh/S/PiAGbluYuVWIozEg21mIuKEwEvjEJV7QIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jAV0m971BBpObhS1eHtK0eP98PbPF
	jQVlFmeedTBafO2/w2ZxaZG7xZ69J1ksLu+aw+bA4bFz1l12j8V7XjJ5zDsZ6LF7wWcmj74t
	qxg9Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAG6RkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8WzDasaC1QIV
	TR3drA2MC3i7GDk5JARMJHZsvcwOYYtJXLi3nq2LkYtDSGARo8SfzY9YQRK8AoISPybfY+li
	5OBgFpCXOHIpGyTMLKAuMWneImaI+leMEpcaQJpB6nUlfjxczwxSLyzgLvF8Fh+IySagLbF5
	vwFIhZCAosTb/XfBposAVU98O5sJZAyzwE1GiZdzXoHdwyKgKtHYOxGsiFPAR2Ld0RPMEM3e
	Est/3AOr4RcQlTi8cDszxP1KErvbO9knMArNQnL1LISrZyG5egEj8ypG0dSC5ILipPRcQ73i
	xNzi0rx0veT83E2M4GTwTGoH48oGi0OMAhyMSjy8Dhv2BAmxJpYVV+YeYpTgYFYS4W2y2Rsk
	xJuSWFmVWpQfX1Sak1p8iDEZ6PCJzFKiyfnARJVXEm9obGJmZGlkZmFkYm5OmrCSOO+BVutA
	IYH0xJLU7NTUgtQimC1MHJxSDYyqu6UvWM8LmmnWtYYlpiTrc5uxbYb+rYnn6p8mPXrQeD1p
	5dsn5+dFyke1lTNXJQpMvBn7PmfmbaMTWz77HqsQ2dva8bN9Wft0BeZQV8v3q70ttrRPT/fS
	2XJVKO5R2A3hGWc4JhQntqQwdPL8XHNvrU7Wk7+OJV86nvivfNUxtezeev3KR9uUWIozEg21
	mIuKEwE5yjd1SgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Could you refer the following patch that I sent?

Re: [PATCH 5/6] f2fs: add the number of inline_data files to status info

Thanks,

2013-12-27 (금), 14:45 +0800, Haicheng Li:
> This patch is to fix the issue reported by Fengguang Wu:
> > Note: the f2fs/linux-3.4 HEAD 22a48d188024830d61365ce97a0a8a0bedd494a9 builds fine.
> >       It only hurts bisectibility.
> >
> > All error/warnings:
> >
> >    In file included from fs/f2fs/data.c:22:0:
> >    fs/f2fs/data.c: In function 'f2fs_direct_IO':
> > >> fs/f2fs/f2fs.h:1302:12: error: inlining failed in call to
> > >> always_inline 'f2fs_has_inline_data': function body not available
> >     inline int f2fs_has_inline_data(struct inode *);
> ..snip..
> 
> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Huajun Li <huajun.li@intel.com>
> ---
>  fs/f2fs/f2fs.h   |    5 ++++-
>  fs/f2fs/inline.c |    5 -----
>  2 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 6991a28..e143ca1 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -1314,7 +1314,10 @@ extern const struct inode_operations f2fs_special_inode_operations;
>  /*
>   * inline.c
>   */
> -inline int f2fs_has_inline_data(struct inode *);
> +static inline int f2fs_has_inline_data(struct inode *inode)
> +{
> +	return is_inode_flag_set(F2FS_I(inode), FI_INLINE_DATA);
> +}
>  bool f2fs_may_inline(struct inode *);
>  int f2fs_read_inline_data(struct inode *, struct page *);
>  int f2fs_convert_inline_data(struct inode *, pgoff_t);
> diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
> index 0e940ce..bcc6f65 100644
> --- a/fs/f2fs/inline.c
> +++ b/fs/f2fs/inline.c
> @@ -13,11 +13,6 @@
>  
>  #include "f2fs.h"
>  
> -inline int f2fs_has_inline_data(struct inode *inode)
> -{
> -	return is_inode_flag_set(F2FS_I(inode), FI_INLINE_DATA);
> -}
> -
>  bool f2fs_may_inline(struct inode *inode)
>  {
>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);

-- 
Jaegeuk Kim
Samsung

