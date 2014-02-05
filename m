Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaBEJvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:51:11 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:49066 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaBEJvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:51:07 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-b7fcd6d00000315b-49-52f209894ace
Content-transfer-encoding: 8BIT
Message-id: <1391593760.17537.6.camel@lcm>
Subject: Re: [f2fs-dev] [PATCH 2/4] f2fs: handle dirty segments inside
 refresh_sit_entry
From: Changman Lee <cm224.lee@samsung.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 05 Feb 2014 18:49:20 +0900
In-reply-to: <1390888447-5258-2-git-send-email-jaegeuk.kim@samsung.com>
References: <1390888447-5258-1-git-send-email-jaegeuk.kim@samsung.com>
 <1390888447-5258-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t8zI91Ozk9BBl8OyFhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAldF9rYOlYLt0xdQ5
	T9gbGDvFuxg5OSQETCQuHNvOBmGLSVy4tx7I5uIQEljGKNH5oZkFpujHnodMEInpjBIrey+y
	giR4BQQlfky+B1TEwcEsIC9x5FI2SJhZQF1i0rxFzBD1rxglHq/aClWvJXF/53mwocICURJr
	5x9gArHZgOLtp9eCxUUENCUeL9/MDDEoU2LO68lgvSwCqhJTbvWCXcop4C6xf/FKsHohgWZG
	ib7nURCHKknsbu9kh7BXsUtsOa8K0Ssg8W3yIbA7JQRkJTYdYIYokZQ4uOIGywRGsVlIvpmF
	8M0sJN8sYGRexSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRESP707GG8fsD7EmAy0cSKzlGhy
	PjD+8kriDY3NjCxMTUyNjcwtzUgTVhLnTXqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	MXei6KyD655eWilke6T3dYfcovtJHqrXJjVfrp3fl/zh5q8HiXHzy9z2WB5PfLZcq7t6YlFb
	YNvW19F7Hpx0+7iwwC+ng/ux71YVBeNULbH+hi5xe7t6d+kV9et05mwWLLCOlU8xnqDnqRqS
	uUD52z3VyP41mk0vBWftiTywgPfS8QSvR1+uK7EUZyQaajEXFScCAGm+WjS1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+xoG4n56cgg4OzJSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8zovtbBUrBdumLqnCfsDYyd4l2MnBwSAiYSP/Y8ZIKwxSQu3FvP1sXIxSEk
	MJ1RYmXvRVaQBK+AoMSPyfdYuhg5OJgF5CWOXMoGCTMLqEtMmreIGaL+FaPE41Vboeq1JO7v
	PM8CYgsLREmsnX8AbAEbULz99FqwuIiApsTj5ZuZIQZlSsx5PRmsl0VAVWLKrV42EJtTwF1i
	/+KVYPVCAs2MEn3PoyAOVZLY3d7JPoFRYBaS82YhnDcLyXkLGJlXMYqmFiQXFCel5xrqFSfm
	Fpfmpesl5+duYgTH5zOpHYwrGywOMQpwMCrx8BoIfwwSYk0sK67MPcQowcGsJMK7hfFTkBBv
	SmJlVWpRfnxRaU5q8SHGZKBjJzJLiSbnA1NHXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE
	0hNLUrNTUwtSi2C2MHFwSjUwMiwrNNZImH6Ytc6sju3fFga29hM/c1NeHSudtNXr06tfSRVS
	Dz71F8zUirnw4cbyPOnZpmKsT4J5liVKC9tESGyusJr+4IBp0xKhipMWredPPp6cz3tr7WWp
	S6tk7daa8Oh2va81qd8SrGi35rHzlJJKlmSLhl35pckiyZpdl1ja16mm/01WYinOSDTUYi4q
	TgQA/xNV3hMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I found some redundant code in  your patch.
I think that locate_dirty_segment(sbi, old_cursegno) equals to
locate_dirty_segment(sbi, GET_SEGNO(sbi, new)) in refresh_sit_entry.
Because *new_blkaddr is a block belonging to old_cursegno.
How do you think?


On 화, 2014-01-28 at 14:54 +0900, Jaegeuk Kim wrote:
> This patch cleans up the refresh_sit_entry to handle locate_dirty_segments.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/f2fs.h    |  1 +
>  fs/f2fs/segment.c | 19 ++++++++-----------
>  2 files changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 42903c3..6e9515d 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -1132,6 +1132,7 @@ void destroy_node_manager_caches(void);
>  void f2fs_balance_fs(struct f2fs_sb_info *);
>  void f2fs_balance_fs_bg(struct f2fs_sb_info *);
>  void invalidate_blocks(struct f2fs_sb_info *, block_t);
> +void refresh_sit_entry(struct f2fs_sb_info *, block_t, block_t);
>  void clear_prefree_segments(struct f2fs_sb_info *);
>  int npages_for_summary_flush(struct f2fs_sb_info *);
>  void allocate_new_segments(struct f2fs_sb_info *);
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 7caac5f..89aa503 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -434,12 +434,14 @@ static void update_sit_entry(struct f2fs_sb_info *sbi, block_t blkaddr, int del)
>  		get_sec_entry(sbi, segno)->valid_blocks += del;
>  }
>  
> -static void refresh_sit_entry(struct f2fs_sb_info *sbi,
> -			block_t old_blkaddr, block_t new_blkaddr)
> +void refresh_sit_entry(struct f2fs_sb_info *sbi, block_t old, block_t new)
>  {
> -	update_sit_entry(sbi, new_blkaddr, 1);
> -	if (GET_SEGNO(sbi, old_blkaddr) != NULL_SEGNO)
> -		update_sit_entry(sbi, old_blkaddr, -1);
> +	update_sit_entry(sbi, new, 1);
> +	if (GET_SEGNO(sbi, old) != NULL_SEGNO)
> +		update_sit_entry(sbi, old, -1);
> +
> +	locate_dirty_segment(sbi, GET_SEGNO(sbi, old));
> +	locate_dirty_segment(sbi, GET_SEGNO(sbi, new));
>  }
>  
>  void invalidate_blocks(struct f2fs_sb_info *sbi, block_t addr)
> @@ -886,12 +888,11 @@ void allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
>  	 * since SSR needs latest valid block information.
>  	 */
>  	refresh_sit_entry(sbi, old_blkaddr, *new_blkaddr);
> +	locate_dirty_segment(sbi, old_cursegno);
>  
>  	if (!__has_curseg_space(sbi, type))
>  		sit_i->s_ops->allocate_segment(sbi, type, false);
>  
> -	locate_dirty_segment(sbi, old_cursegno);
> -	locate_dirty_segment(sbi, GET_SEGNO(sbi, old_blkaddr));
>  	mutex_unlock(&sit_i->sentry_lock);
>  
>  	if (page && IS_NODESEG(type))
> @@ -992,9 +993,7 @@ void recover_data_page(struct f2fs_sb_info *sbi,
>  	__add_sum_entry(sbi, type, sum);
>  
>  	refresh_sit_entry(sbi, old_blkaddr, new_blkaddr);
> -
>  	locate_dirty_segment(sbi, old_cursegno);
> -	locate_dirty_segment(sbi, GET_SEGNO(sbi, old_blkaddr));
>  
>  	mutex_unlock(&sit_i->sentry_lock);
>  	mutex_unlock(&curseg->curseg_mutex);
> @@ -1045,9 +1044,7 @@ void rewrite_node_page(struct f2fs_sb_info *sbi,
>  	f2fs_submit_page_mbio(sbi, page, new_blkaddr, &fio);
>  	f2fs_submit_merged_bio(sbi, NODE, WRITE);
>  	refresh_sit_entry(sbi, old_blkaddr, new_blkaddr);
> -
>  	locate_dirty_segment(sbi, old_cursegno);
> -	locate_dirty_segment(sbi, GET_SEGNO(sbi, old_blkaddr));
>  
>  	mutex_unlock(&sit_i->sentry_lock);
>  	mutex_unlock(&curseg->curseg_mutex);


