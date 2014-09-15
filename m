Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaIOCOh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 22:14:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33676 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbaIOCOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 22:14:34 -0400
X-AuditID: cbfee68d-f79c46d000000b84-54-54164b881c96
Date: Mon, 15 Sep 2014 11:13:15 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 04/10] f2fs: give an option to enable
 in-place-updates during fsync to users
Message-id: <20140915021251.GA2946@lcm>
References: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
 <1410732864-53069-4-git-send-email-jaegeuk@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <1410732864-53069-4-git-send-email-jaegeuk@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+ZgW6Ht1iIwf8lUhZP1s9itri0yN1i
	z96TLBaXd81hc2Dx2LSqk81j94LPTB6fN8kFMEdx2aSk5mSWpRbp2yVwZfz4MYW5oNG5YtrP
	e4wNjD+Muxg5OSQETCQ2PZrJDmGLSVy4t56ti5GLQ0hgGaPEjmffmWGKNp+/zgiRmM4ocfTr
	IXYI5yejxM4nZ8HaWQRUJSbcecIEYrMJaEm0n17LAmKLCKhIHFp0GayGWSBTYkL/CzBbWCBX
	4tauD6wgNq+AusS208fAbCGBaonuafvZIeKCEj8m32OB6NWSWL/zOBOELS3x6O8MsBpOAWeJ
	t5dugfWKAu2acnIb2AsSAsvYJaa/BnFAjhOQ+Db5ENAgDqCErMSmA1CfSUocXHGDZQKj2Cwk
	62YhWTcLyboFjMyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MUKiqHcH4+0D1ocYBTgYlXh4
	A84LhwixJpYVV+YeYjQFumIis5Rocj4wVvNK4g2NzYwsTE1MjY3MLc2UxHkVpX4GCwmkJ5ak
	ZqemFqQWxReV5qQWH2Jk4uCUamBcOFe1Zq7wxfXntk1O71Gf80xHhdlPVq/50H2GoFpel20M
	a0qL83k947dYiyvZXjsbz/hRr/EGW5imqdCzW42b0iZtPRuV46+dZFx+M3f2UtdZXuUWq862
	PskOuMSjOOFzzO5LrzI/KxwwuXIl9Y+D49aXCg/srBL6e6REV7RkBG/SuTlpVYYSS3FGoqEW
	c1FxIgAyOWCInQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jQd0Ob7EQg5aXohZP1s9itri0yN1i
	z96TLBaXd81hc2Dx2LSqk81j94LPTB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWb8+DGFuaDRuWLaz3uMDYw/jLsYOTkkBEwkNp+/zghhi0lcuLeerYuRi0NI
	YDqjxNGvh9ghnJ+MEjufnGUHqWIRUJWYcOcJE4jNJqAl0X56LQuILSKgInFo0WWwGmaBTIkJ
	/S/AbGGBXIlbuz6wgti8AuoS204fA7OFBKoluqftZ4eIC0r8mHyPBaJXS2L9zuNMELa0xKO/
	M8BqOAWcJd5eugXWKwq0a8rJbWwTGAVmIWmfhaR9FpL2BYzMqxhFUwuSC4qT0nMN9YoTc4tL
	89L1kvNzNzGCY/SZ1A7GlQ0WhxgFOBiVeHhXXBQOEWJNLCuuzD3EKMHBrCTCG+guFiLEm5JY
	WZValB9fVJqTWnyI0RQYGhOZpUST84HpI68k3tDYxMzI0sjMwsjE3FxJnPdAq3WgkEB6Yklq
	dmpqQWoRTB8TB6dUA+NGF6PszOn3C+TT3mbduRf6pe+p4zUl9ve7d+r1lqbN/jw1/dQWBa26
	RhveDZ8+r2J5nZV1xe+BwcSZupzJR/mvL+ha3Vl2tPtm/T+9v4qteRv4hCX/mt+RDj3DO3dH
	yvezZcHpzra+D6b1H+c9W9LKXSZ51+mJSu0V73eCzTIMGdf7zmv1mCixFGckGmoxFxUnAgAp
	V0vT5wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi JK,

I think it' nicer if this can be used as 'OR' with other policy
together. If so, we can also cover the weakness in high utilization.

Regard,
Changman

On Sun, Sep 14, 2014 at 03:14:18PM -0700, Jaegeuk Kim wrote:
> If user wrote F2FS_IPU_FSYNC:4 in /sys/fs/f2fs/ipu_policy, f2fs_sync_file
> only starts to try in-place-updates.
> And, if the number of dirty pages is over /sys/fs/f2fs/min_fsync_blocks, it
> keeps out-of-order manner. Otherwise, it triggers in-place-updates.
> 
> This may be used by storage showing very high random write performance.
> 
> For example, it can be used when,
> 
> Seq. writes (Data) + wait + Seq. writes (Node)
> 
> is pretty much slower than,
> 
> Rand. writes (Data)
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  Documentation/ABI/testing/sysfs-fs-f2fs |  7 +++++++
>  Documentation/filesystems/f2fs.txt      |  9 ++++++++-
>  fs/f2fs/f2fs.h                          |  1 +
>  fs/f2fs/file.c                          |  7 +++----
>  fs/f2fs/segment.c                       |  3 ++-
>  fs/f2fs/segment.h                       | 14 ++++++++++----
>  fs/f2fs/super.c                         |  2 ++
>  7 files changed, 33 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/testing/sysfs-fs-f2fs
> index 62dd725..6f9157f 100644
> --- a/Documentation/ABI/testing/sysfs-fs-f2fs
> +++ b/Documentation/ABI/testing/sysfs-fs-f2fs
> @@ -44,6 +44,13 @@ Description:
>  		 Controls the FS utilization condition for the in-place-update
>  		 policies.
>  
> +What:		/sys/fs/f2fs/<disk>/min_fsync_blocks
> +Date:		September 2014
> +Contact:	"Jaegeuk Kim" <jaegeuk@kernel.org>
> +Description:
> +		 Controls the dirty page count condition for the in-place-update
> +		 policies.
> +
>  What:		/sys/fs/f2fs/<disk>/max_small_discards
>  Date:		November 2013
>  Contact:	"Jaegeuk Kim" <jaegeuk.kim@samsung.com>
> diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
> index a2046a7..d010da8 100644
> --- a/Documentation/filesystems/f2fs.txt
> +++ b/Documentation/filesystems/f2fs.txt
> @@ -194,13 +194,20 @@ Files in /sys/fs/f2fs/<devname>
>                                updates in f2fs. There are five policies:
>                                 0: F2FS_IPU_FORCE, 1: F2FS_IPU_SSR,
>                                 2: F2FS_IPU_UTIL,  3: F2FS_IPU_SSR_UTIL,
> -                               4: F2FS_IPU_DISABLE.
> +                               4: F2FS_IPU_FSYNC, 5: F2FS_IPU_DISABLE.
>  
>   min_ipu_util                 This parameter controls the threshold to trigger
>                                in-place-updates. The number indicates percentage
>                                of the filesystem utilization, and used by
>                                F2FS_IPU_UTIL and F2FS_IPU_SSR_UTIL policies.
>  
> + min_fsync_blocks             This parameter controls the threshold to trigger
> +                              in-place-updates when F2FS_IPU_FSYNC mode is set.
> +			      The number indicates the number of dirty pages
> +			      when fsync needs to flush on its call path. If
> +			      the number is less than this value, it triggers
> +			      in-place-updates.
> +
>   max_victim_search	      This parameter controls the number of trials to
>  			      find a victim segment when conducting SSR and
>  			      cleaning operations. The default value is 4096
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 2756c16..4f84d2a 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -386,6 +386,7 @@ struct f2fs_sm_info {
>  
>  	unsigned int ipu_policy;	/* in-place-update policy */
>  	unsigned int min_ipu_util;	/* in-place-update threshold */
> +	unsigned int min_fsync_blocks;	/* threshold for fsync */
>  
>  	/* for flush command control */
>  	struct flush_cmd_control *cmd_control_info;
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 77426c7..af06e22 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -154,12 +154,11 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  	trace_f2fs_sync_file_enter(inode);
>  
>  	/* if fdatasync is triggered, let's do in-place-update */
> -	if (datasync)
> +	if (get_dirty_pages(inode) <= SM_I(sbi)->min_fsync_blocks)
>  		set_inode_flag(fi, FI_NEED_IPU);
> -
>  	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
> -	if (datasync)
> -		clear_inode_flag(fi, FI_NEED_IPU);
> +	clear_inode_flag(fi, FI_NEED_IPU);
> +
>  	if (ret) {
>  		trace_f2fs_sync_file_exit(inode, need_cp, datasync, ret);
>  		return ret;
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index e158d63..c6f627b 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -1928,8 +1928,9 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
>  	sm_info->ssa_blkaddr = le32_to_cpu(raw_super->ssa_blkaddr);
>  	sm_info->rec_prefree_segments = sm_info->main_segments *
>  					DEF_RECLAIM_PREFREE_SEGMENTS / 100;
> -	sm_info->ipu_policy = F2FS_IPU_DISABLE;
> +	sm_info->ipu_policy = F2FS_IPU_FSYNC;
>  	sm_info->min_ipu_util = DEF_MIN_IPU_UTIL;
> +	sm_info->min_fsync_blocks = DEF_MIN_FSYNC_BLOCKS;
>  
>  	INIT_LIST_HEAD(&sm_info->discard_list);
>  	sm_info->nr_discards = 0;
> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
> index bed0dc9..013aed2 100644
> --- a/fs/f2fs/segment.h
> +++ b/fs/f2fs/segment.h
> @@ -472,15 +472,20 @@ static inline int utilization(struct f2fs_sb_info *sbi)
>   * F2FS_IPU_UTIL - if FS utilization is over threashold,
>   * F2FS_IPU_SSR_UTIL - if SSR mode is activated and FS utilization is over
>   *                     threashold,
> + * F2FS_IPU_FSYNC - activated in fsync path only for high performance flash
> + *                     storages. IPU will be triggered only if the # of dirty
> + *                     pages over min_fsync_blocks.
>   * F2FS_IPUT_DISABLE - disable IPU. (=default option)
>   */
>  #define DEF_MIN_IPU_UTIL	70
> +#define DEF_MIN_FSYNC_BLOCKS	8
>  
>  enum {
>  	F2FS_IPU_FORCE,
>  	F2FS_IPU_SSR,
>  	F2FS_IPU_UTIL,
>  	F2FS_IPU_SSR_UTIL,
> +	F2FS_IPU_FSYNC,
>  	F2FS_IPU_DISABLE,
>  };
>  
> @@ -492,10 +497,6 @@ static inline bool need_inplace_update(struct inode *inode)
>  	if (S_ISDIR(inode->i_mode))
>  		return false;
>  
> -	/* this is only set during fdatasync */
> -	if (is_inode_flag_set(F2FS_I(inode), FI_NEED_IPU))
> -		return true;
> -
>  	switch (SM_I(sbi)->ipu_policy) {
>  	case F2FS_IPU_FORCE:
>  		return true;
> @@ -511,6 +512,11 @@ static inline bool need_inplace_update(struct inode *inode)
>  		if (need_SSR(sbi) && utilization(sbi) > SM_I(sbi)->min_ipu_util)
>  			return true;
>  		break;
> +	case F2FS_IPU_FSYNC:
> +		/* this is only set during fdatasync */
> +		if (is_inode_flag_set(F2FS_I(inode), FI_NEED_IPU))
> +			return true;
> +		break;
>  	case F2FS_IPU_DISABLE:
>  		break;
>  	}
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index b5af9be..ed4095e 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -190,6 +190,7 @@ F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, reclaim_segments, rec_prefree_segments);
>  F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, max_small_discards, max_discards);
>  F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, ipu_policy, ipu_policy);
>  F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, min_ipu_util, min_ipu_util);
> +F2FS_RW_ATTR(SM_INFO, f2fs_sm_info, min_fsync_blocks, min_fsync_blocks);
>  F2FS_RW_ATTR(NM_INFO, f2fs_nm_info, ram_thresh, ram_thresh);
>  F2FS_RW_ATTR(F2FS_SBI, f2fs_sb_info, max_victim_search, max_victim_search);
>  F2FS_RW_ATTR(F2FS_SBI, f2fs_sb_info, dir_level, dir_level);
> @@ -204,6 +205,7 @@ static struct attribute *f2fs_attrs[] = {
>  	ATTR_LIST(max_small_discards),
>  	ATTR_LIST(ipu_policy),
>  	ATTR_LIST(min_ipu_util),
> +	ATTR_LIST(min_fsync_blocks),
>  	ATTR_LIST(max_victim_search),
>  	ATTR_LIST(dir_level),
>  	ATTR_LIST(ram_thresh),
> -- 
> 1.8.5.2 (Apple Git-48)
> 
> 
> ------------------------------------------------------------------------------
> Want excitement?
> Manually upgrade your production database.
> When you want reliability, choose Perforce
> Perforce version control. Predictably reliable.
> http://pubads.g.doubleclick.net/gampad/clk?id=157508191&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
