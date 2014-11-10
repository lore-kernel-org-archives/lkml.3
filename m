Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaKJD34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 22:29:56 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:43082 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaKJD3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 22:29:52 -0500
X-AuditID: cbfee691-f79b86d000004a5a-dc-5460312da676
Date: Mon, 10 Nov 2014 12:28:34 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 3/5] f2fs: control the memory footprint used by
	ino entries
Message-id: <20141110032834.GA14659@lcm>
References: <1415518569-20626-1-git-send-email-jaegeuk@kernel.org>
 <1415518569-20626-3-git-send-email-jaegeuk@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <1415518569-20626-3-git-send-email-jaegeuk@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+Zga6uYUKIwZfJ2hZP1s9itri0yN1i
	z96TLBaXd81hc2Dx2LSqk81j94LPTB6fN8kFMEdx2aSk5mSWpRbp2yVwZTxZlFBwS7bi49d+
	xgbG0+JdjJwcEgImEjNX3mSGsMUkLtxbz9bFyMUhJLCMUWLvzddsMEWnp00DKxISmA6UuOUO
	UfSTUaLt4ClGkASLgKrE2uU9TCA2m4CWRPvptSwgtoiAisShRZfZQWxmgUyJCf0vwGxhgRiJ
	j6+awIbyCmhI7Fw+kx1iQbXElLVPoeKCEj8m32OB6NWSWL/zOBOELS3x6O8MsHpOAWeJlYvu
	gcVFgXZNObkN7AMJgXnsEpfW7WGDOE5A4tvkQ0CDOIASshKbDkB9LClxcMUNlgmMYrOQrJuF
	ZN0sJOsWMDKvYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAiJoIk7GO8fsD7EKMDBqMTD6/A2
	PkSINbGsuDL3EKMp0BUTmaVEk/OBcZpXEm9obGZkYWpiamxkbmmmJM6rI/0zWEggPbEkNTs1
	tSC1KL6oNCe1+BAjEwenVAPjWtMHpT+dq46JNJVWrlayMcv+te9Vg/Q3v6e5ljwH/MTq8mzF
	pt+0P5xwYc1iRVkvpattiX8ilvO8+79mqdIjk4rLrA7Vk7XO9ye4nOtYLOZb3uAYPneBbcp5
	1dIlnMt+uqfkLwpb/mfqG2nh3dfTXxxIXFjQy+95hGumq5rHLF3tNeJu4TeUWIozEg21mIuK
	EwGmkpmemwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jQV1dw4QQg9t/1CyerJ/FbHFpkbvF
	nr0nWSwu75rD5sDisWlVJ5vH7gWfmTw+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8x4siih4JZsxcev/YwNjKfFuxg5OSQETCROT5vGDGGLSVy4t54NxBYSmM4o
	sfeWexcjF5D9k1Gi7eApRpAEi4CqxNrlPUwgNpuAlkT76bUsILaIgIrEoUWX2UFsZoFMiQn9
	L8BsYYEYiY+vmsAW8ApoSOxcPpMdYkG1xJS1T6HighI/Jt9jgejVkli/8zgThC0t8ejvDLB6
	TgFniZWL7oHFRYF2TTm5jW0Co8AsJO2zkLTPQtK+gJF5FaNoakFyQXFSeq6RXnFibnFpXrpe
	cn7uJkZwfD6T3sG4qsHiEKMAB6MSD6/D2/gQIdbEsuLK3EOMEhzMSiK8tf+BQrwpiZVVqUX5
	8UWlOanFhxhNgaExkVlKNDkfmDrySuINjU3MjCyNzCyMTMzNlcR5D7ZaBwoJpCeWpGanphak
	FsH0MXFwSjUw8gc+stDtdvcrb35z6tKTPx49Tlmz76uKPRTtPRJ2vFFMQSU4IO6imlHI1jdW
	Bip6ku23zSTYme5dYU6x65wnvF5T9u+MvWf0l4ltM9u6xVS8sGgZi53/ruslv9Yvynt4pP73
	sevq52P+nnCerPb506rM4MUyH7Icmi1WcE1ef5Ljs92Du0XJSizFGYmGWsxFxYkAgSMn1eUC	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2014 at 11:36:07PM -0800, Jaegeuk Kim wrote:
> This patch adds to control the memory footprint used by ino entries.
> This will conduct best effort, not strictly.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/node.c    | 28 ++++++++++++++++++++++------
>  fs/f2fs/node.h    |  3 ++-
>  fs/f2fs/segment.c |  3 ++-
>  3 files changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 44b8afe..4ea2c47 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -31,22 +31,38 @@ bool available_free_memory(struct f2fs_sb_info *sbi, int type)
>  {
>  	struct f2fs_nm_info *nm_i = NM_I(sbi);
>  	struct sysinfo val;
> +	unsigned long avail_ram;
>  	unsigned long mem_size = 0;
>  	bool res = false;
>  
>  	si_meminfo(&val);
> -	/* give 25%, 25%, 50% memory for each components respectively */
> +
> +	/* only uses low memory */
> +	avail_ram = val.totalram - val.totalhigh;
> +
> +	/* give 25%, 25%, 50%, 50% memory for each components respectively */

Hi Jaegeuk,

The memory usage of nm_i should be 100% but it's 125%.
Mistake or intended?

>  	if (type == FREE_NIDS) {
> -		mem_size = (nm_i->fcnt * sizeof(struct free_nid)) >> 12;
> -		res = mem_size < ((val.totalram * nm_i->ram_thresh / 100) >> 2);
> +		mem_size = (nm_i->fcnt * sizeof(struct free_nid)) >>
> +							PAGE_CACHE_SHIFT;
> +		res = mem_size < ((avail_ram * nm_i->ram_thresh / 100) >> 2);
>  	} else if (type == NAT_ENTRIES) {
> -		mem_size = (nm_i->nat_cnt * sizeof(struct nat_entry)) >> 12;
> -		res = mem_size < ((val.totalram * nm_i->ram_thresh / 100) >> 2);
> +		mem_size = (nm_i->nat_cnt * sizeof(struct nat_entry)) >>
> +							PAGE_CACHE_SHIFT;
> +		res = mem_size < ((avail_ram * nm_i->ram_thresh / 100) >> 2);
>  	} else if (type == DIRTY_DENTS) {
>  		if (sbi->sb->s_bdi->dirty_exceeded)
>  			return false;
>  		mem_size = get_pages(sbi, F2FS_DIRTY_DENTS);
> -		res = mem_size < ((val.totalram * nm_i->ram_thresh / 100) >> 1);
> +		res = mem_size < ((avail_ram * nm_i->ram_thresh / 100) >> 1);
> +	} else if (type == INO_ENTRIES) {
> +		int i;
> +
> +		if (sbi->sb->s_bdi->dirty_exceeded)
> +			return false;
> +		for (i = 0; i <= UPDATE_INO; i++)
> +			mem_size += (sbi->ino_num[i] * sizeof(struct ino_entry))
> +							>> PAGE_CACHE_SHIFT;
> +		res = mem_size < ((avail_ram * nm_i->ram_thresh / 100) >> 1);
>  	}
>  	return res;
>  }
> diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
> index acb71e5..d10b644 100644
> --- a/fs/f2fs/node.h
> +++ b/fs/f2fs/node.h
> @@ -106,7 +106,8 @@ static inline void raw_nat_from_node_info(struct f2fs_nat_entry *raw_ne,
>  enum mem_type {
>  	FREE_NIDS,	/* indicates the free nid list */
>  	NAT_ENTRIES,	/* indicates the cached nat entry */
> -	DIRTY_DENTS	/* indicates dirty dentry pages */
> +	DIRTY_DENTS,	/* indicates dirty dentry pages */
> +	INO_ENTRIES,	/* indicates inode entries */
>  };
>  
>  struct nat_entry_set {
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 16721b5d..e094675 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -276,7 +276,8 @@ void f2fs_balance_fs_bg(struct f2fs_sb_info *sbi)
>  {
>  	/* check the # of cached NAT entries and prefree segments */
>  	if (try_to_free_nats(sbi, NAT_ENTRY_PER_BLOCK) ||
> -				excess_prefree_segs(sbi))
> +			excess_prefree_segs(sbi) ||
> +			available_free_memory(sbi, INO_ENTRIES))
>  		f2fs_sync_fs(sbi->sb, true);
>  }
>  
> -- 
> 2.1.1
> 
> 
> ------------------------------------------------------------------------------
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
