Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaDQHr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 03:47:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27823 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaDQHrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 03:47:24 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-b7fcd6d00000315b-c0-534f870993d6
Content-transfer-encoding: 8BIT
Message-id: <1397720720.7727.28.camel@kjgkr>
Subject: Re: f2fs: BUG_ON() is triggered when mount valid f2fs filesystem
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Andrey Tsyvarev <tsyvarev@ispras.ru>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 17 Apr 2014 16:45:20 +0900
In-reply-to: <534F2A32.9030405@ispras.ru>
References: <52F320FC.50803@ispras.ru> <534BC29B.3020408@ispras.ru>
 <1397559864.7727.5.camel@kjgkr> <534E494C.7050909@ispras.ru>
 <1397691337.7727.18.camel@kjgkr> <534F2A32.9030405@ispras.ru>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t8zA13Odv9gg9bj1hY71u1kt7i0yN3i
	8q45bBbLL8c5sHjM+DeV0WP3gs9MHp83yQUwR3HZpKTmZJalFunbJXBltH2/y1bw3bxiwh25
	BsbNul2MnBwSAiYSp9edYYewxSQu3FvP1sXIxSEksIxRom/dEUaYoi9T/kElpjNKnPjfBtbB
	KyAo8WPyPZYuRg4OZgF5iSOXskHCzALqEpPmLWKGqH/FKHH84BRGiHodiXv7VjGD2MICnhIb
	p15hAullE9CW2LzfACQsJKAo8Xb/XVYQW0RAT+Ljq61MIHOYBRoZJda0bASbwyKgKvFh+V8W
	EJtTQFPi08ZVLBDLDjFKtPdsBUvwC4hKHF64nRniAyWJ3e2d7CBFEgKn2CXOtP6CmiQg8W3y
	IbAPJARkJTYdgKqXlDi44gbLBEaJWUj+nIXw5ywkfy5gZF7FKJpakFxQnJReZKhXnJhbXJqX
	rpecn7uJERJvvTsYbx+wPsSYDLRxIrOUaHI+MF7zSuINjc2MLExNTI2NzC3NSBNWEudNepgU
	JCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFR9aDr8Xd9ks++Ks6yjyhSTzTWyDA4rvXiRW7C
	ngiV24orBA5XTqmXmCe+qXD5hCOHGuvFkljjztasSz8fOP/kHRfmraZV16XsD2oqL/ryge3P
	33jhudv6Vn/x/L7CuWBTt1X2xhx5k/6q1I1132LCbMqXdCYVhRusWewVdvBLpFjft7Vie+yU
	WIozEg21mIuKEwHu2qPWzQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jQV3Odv9ggycXzSx2rNvJbnFpkbvF
	5V1z2CyWX45zYPGY8W8qo8fuBZ+ZPD5vkgtgjmpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443
	NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBWqakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zck
	CK7HyAANJKxjzGj7fpet4Lt5xYQ7cg2Mm3W7GDk5JARMJL5M+ccGYYtJXLi3Hsjm4hASmM4o
	ceJ/GztIgldAUOLH5HssXYwcHMwC8hJHLmWDhJkF1CUmzVvEDFH/ilHi+MEpjBD1OhL39q1i
	BrGFBTwlNk69wgTSyyagLbF5vwFIWEhAUeLt/rusILaIgJ7Ex1dbmUDmMAs0MkqsadkINodF
	QFXiw/K/LCA2p4CmxKeNq1gglh1ilGjv2QqW4BcQlTi8cDszxAdKErvbO9knMArNQnL3LIS7
	ZyG5ewEj8ypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Gh+Jr2DcVWDxSFGAQ5GJR5ezt9+
	wUKsiWXFlblAB3AwK4nwRtf6BwvxpiRWVqUW5ccXleakFh9iTAa6fCKzlGhyPjDR5JXEGxqb
	mBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDoyl37ZkPJbcnSYvNP7Mv
	dOuMqXWqawRfaqw4Nqn2/oL2RaZXd7A6yYbEXpkiFff0xsJJ3fEM92603mveyzj7ya0Vfe4Z
	KR6711f1ZrIsZFywpKxuTaJbT8OPRjtNq2fvhQ02PcoIifc7LZEqGBP/3/WZ0NZdog7H/87d
	+1L7duq+vD8zbbhrryixFGckGmoxFxUnAgBXu9oXKgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-04-16 (수), 18:11 -0700, Alexey Khoroshilov:
> Hi,
> 
> But would not ability to trigger BUG_ON by mounting a crafted image
> considered as an issue having security implications?

Sorry, I can't come up with you.
Could you please explain why this can be related to the security hole?
Did you mean it needs to avoid such the BUG_ONs if the image has
obsolete data being used before?

Thanks,

> 
> Regards,
> Alexey
> 
> 
> On 16.04.2014 16:35, Jaegeuk Kim wrote:
> > Hi,
> >
> > 2014-04-16 (수), 13:11 +0400, Andrey Tsyvarev:
> >> Hi,
> >>
> >> With this patch mounting of the image continues to fail (with similar 
> >> BUG_ON).
> >> But when image is formatted again (and steps mentioned in the previous 
> >> message are performed),
> >> mounting of it is now succeed.
> >>
> >> Is this is a true purpose of the patch?
> > Indeed. The patch solves there-in root cause.
> > But, if you're trying to use the failed image again, simply you can skip
> > the errorneous part by:
> >
> > # mount ... -o disable_roll_forward ...
> >
> > Once sync or umount whatever checkpoint is done after that, the image
> > will be mounted without "disable_roll_forward".
> >
> > Thanks,
> >
> >> 15.04.2014 15:04, Jaegeuk Kim пишет:
> >>> Hi,
> >>>
> >>> Thank you for the report.
> >>> I retrieved the fault image and found out that previous garbage data
> >>> wreak such the wrong behaviors.
> >>> So, I wrote the following patch that fills one zero-block at the
> >>> checkpoint procedure.
> >>> If the underlying device supports discard, I expect that it mostly
> >>> doesn't incur any performance regression significantly.
> >>>
> >>> Could you test this patch?
> >>>
> >>> >From 60588ceb7277aae2a79e7f67f5217d1256720d78 Mon Sep 17 00:00:00 2001
> >>> From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> >>> Date: Tue, 15 Apr 2014 13:57:55 +0900
> >>> Subject: [PATCH] f2fs: avoid to conduct roll-forward due to the remained
> >>>   garbage blocks
> >>>
> >>> The f2fs always scans the next chain of direct node blocks.
> >>> But some garbage blocks are able to be remained due to no discard
> >>> support or
> >>> SSR triggers.
> >>> This occasionally wreaks recovering wrong inodes that were used or
> >>> BUG_ONs
> >>> due to reallocating node ids as follows.
> >>>
> >>> When mount this f2fs image:
> >>> http://linuxtesting.org/downloads/f2fs_fault_image.zip
> >>> BUG_ON is triggered in f2fs driver (messages below are generated on
> >>> kernel 3.13.2; for other kernels output is similar):
> >>>
> >>> kernel BUG at fs/f2fs/node.c:215!
> >>>   Call Trace:
> >>>   [<ffffffffa032ebad>] recover_inode_page+0x1fd/0x3e0 [f2fs]
> >>>   [<ffffffff811446e7>] ? __lock_page+0x67/0x70
> >>>   [<ffffffff81089990>] ? autoremove_wake_function+0x50/0x50
> >>>   [<ffffffffa0337788>] recover_fsync_data+0x1398/0x15d0 [f2fs]
> >>>   [<ffffffff812b9e5c>] ? selinux_d_instantiate+0x1c/0x20
> >>>   [<ffffffff811cb20b>] ? d_instantiate+0x5b/0x80
> >>>   [<ffffffffa0321044>] f2fs_fill_super+0xb04/0xbf0 [f2fs]
> >>>   [<ffffffff811b861e>] ? mount_bdev+0x7e/0x210
> >>>   [<ffffffff811b8769>] mount_bdev+0x1c9/0x210
> >>>   [<ffffffffa0320540>] ? validate_superblock+0x210/0x210 [f2fs]
> >>>   [<ffffffffa031cf8d>] f2fs_mount+0x1d/0x30 [f2fs]
> >>>   [<ffffffff811b9497>] mount_fs+0x47/0x1c0
> >>>   [<ffffffff81166e00>] ? __alloc_percpu+0x10/0x20
> >>>   [<ffffffff811d4032>] vfs_kern_mount+0x72/0x110
> >>>   [<ffffffff811d6763>] do_mount+0x493/0x910
> >>>   [<ffffffff811615cb>] ? strndup_user+0x5b/0x80
> >>>   [<ffffffff811d6c70>] SyS_mount+0x90/0xe0
> >>>   [<ffffffff8166f8d9>] system_call_fastpath+0x16/0x1b
> >>>
> >>> Found by Linux File System Verification project (linuxtesting.org).
> >>>
> >>> Reported-by: Andrey Tsyvarev <tsyvarev@ispras.ru>
> >>> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> >>> ---
> >>>   fs/f2fs/checkpoint.c |  6 ++++++
> >>>   fs/f2fs/f2fs.h       |  1 +
> >>>   fs/f2fs/segment.c    | 17 +++++++++++++++--
> >>>   3 files changed, 22 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> >>> index 4aa521a..890e23d 100644
> >>> --- a/fs/f2fs/checkpoint.c
> >>> +++ b/fs/f2fs/checkpoint.c
> >>> @@ -762,6 +762,12 @@ static void do_checkpoint(struct f2fs_sb_info *sbi,
> >>> bool is_umount)
> >>>   	void *kaddr;
> >>>   	int i;
> >>>   
> >>> +	/*
> >>> +	 * This avoids to conduct wrong roll-forward operations and uses
> >>> +	 * metapages, so should be called prior to sync_meta_pages below.
> >>> +	 */
> >>> +	discard_next_dnode(sbi);
> >>> +
> >>>   	/* Flush all the NAT/SIT pages */
> >>>   	while (get_pages(sbi, F2FS_DIRTY_META))
> >>>   		sync_meta_pages(sbi, META, LONG_MAX);
> >>> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> >>> index 2ecac83..2c5a5da 100644
> >>> --- a/fs/f2fs/f2fs.h
> >>> +++ b/fs/f2fs/f2fs.h
> >>> @@ -1179,6 +1179,7 @@ int f2fs_issue_flush(struct f2fs_sb_info *);
> >>>   void invalidate_blocks(struct f2fs_sb_info *, block_t);
> >>>   void refresh_sit_entry(struct f2fs_sb_info *, block_t, block_t);
> >>>   void clear_prefree_segments(struct f2fs_sb_info *);
> >>> +void discard_next_dnode(struct f2fs_sb_info *);
> >>>   int npages_for_summary_flush(struct f2fs_sb_info *);
> >>>   void allocate_new_segments(struct f2fs_sb_info *);
> >>>   struct page *get_sum_page(struct f2fs_sb_info *, unsigned int);
> >>> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> >>> index 1e264e7..9993f94 100644
> >>> --- a/fs/f2fs/segment.c
> >>> +++ b/fs/f2fs/segment.c
> >>> @@ -335,13 +335,26 @@ static void locate_dirty_segment(struct
> >>> f2fs_sb_info *sbi, unsigned int segno)
> >>>   	mutex_unlock(&dirty_i->seglist_lock);
> >>>   }
> >>>   
> >>> -static void f2fs_issue_discard(struct f2fs_sb_info *sbi,
> >>> +static int f2fs_issue_discard(struct f2fs_sb_info *sbi,
> >>>   				block_t blkstart, block_t blklen)
> >>>   {
> >>>   	sector_t start = SECTOR_FROM_BLOCK(sbi, blkstart);
> >>>   	sector_t len = SECTOR_FROM_BLOCK(sbi, blklen);
> >>> -	blkdev_issue_discard(sbi->sb->s_bdev, start, len, GFP_NOFS, 0);
> >>>   	trace_f2fs_issue_discard(sbi->sb, blkstart, blklen);
> >>> +	return blkdev_issue_discard(sbi->sb->s_bdev, start, len, GFP_NOFS, 0);
> >>> +}
> >>> +
> >>> +void discard_next_dnode(struct f2fs_sb_info *sbi)
> >>> +{
> >>> +	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_WARM_NODE);
> >>> +	block_t blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
> >>> +
> >>> +	if (f2fs_issue_discard(sbi, blkaddr, 1)) {
> >>> +		struct page *page = grab_meta_page(sbi, blkaddr);
> >>> +		/* zero-filled page */
> >>> +		set_page_dirty(page);
> >>> +		f2fs_put_page(page, 1);
> >>> +	}
> >>>   }
> >>>   
> >>>   static void add_discard_addrs(struct f2fs_sb_info *sbi,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jaegeuk Kim
Samsung

