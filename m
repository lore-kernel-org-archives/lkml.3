Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaBGG7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 01:59:49 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:46848 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaBGG7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 01:59:47 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7f156d00000276c-8b-52f484616357
Content-transfer-encoding: 8BIT
Message-id: <1391756297.25542.89.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH] f2fs: introduce ra_meta_pages to readahead
 CP/NAT/SIT pages
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Fri, 07 Feb 2014 15:58:17 +0900
In-reply-to: <000001cf1bd0$bec85020$3c58f060$@samsung.com>
References: <000001cf1bd0$bec85020$3c58f060$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t8zY93Eli9BBufeW1v8b/rIZnFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyli0fydjwUeHirWz
	xRsYDxh1MXJwSAiYSCxY6dTFyAlkiklcuLeerYuRi0NIYBmjRNOWWawQCROJlq4ORhBbSGA6
	o8TFn5ogNq+AoMSPyfdYQOYwC8hLHLmUDRJmFlCXmDRvETPEnJeMEtfn7WeDqNeV2HcYYqaw
	QKxE+8vPTCC9bALaEpv3G0CMV5R4u/8uWImIgJLEr/mLWCFmZkrMeT0ZzGYRUJXY0PacCcTm
	FLCSmNJ8gwWi11Lizf1usDP5BUQlDi/czgxxvpLE7vZOdpB7JAQOsUts7nnEDDFIQOLb5EMs
	kHCQldh0AKpeUuLgihssExglZiH5chbCl7OQfLmAkXkVo2hqQXJBcVJ6kbFecWJucWleul5y
	fu4mRkik9e9gvHvA+hBjMtDGicxSosn5wEjNK4k3NDYzsjA1MTU2Mrc0I01YSZz3/sOkICGB
	9MSS1OzU1ILUovii0pzU4kOMTBycUg2MTH8nPRdVUTGuP/K/svfvF4sZr7vU9hy9+/3nZj/v
	fXlnI/P9ZndXOUoav8j8q5P50U1GaElN8M38IvHKxQfm6Bj1izpqB5zgn1q7eP1chw+aguWf
	rXp8PYuvZRTnr2iq4WCrNVzxcK2+TMB/m4z+LUL5e+Z89t7pdEbeO3OGbrOi217/2iYlluKM
	REMt5qLiRADdd8oUygIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jQd3Eli9BBjfbzS3+N31ks7i0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWYs2r+TseCjQ8Xa2eINjAeMuhg5OSQETCRaujoYIWwxiQv31rOB2EIC0xkl
	Lv7UBLF5BQQlfky+x9LFyMHBLCAvceRSNkiYWUBdYtK8RcxdjFxA5S8ZJa7P288GUa8rse/w
	LFYQW1ggVqL95WcmkF42AW2JzfsNIMYrSrzdfxesRERASeLX/EWsEDMzJea8ngxmswioSmxo
	e84EYnMKWElMab7BAtFrKfHmfjfYyfwCohKHF25nhjhfSWJ3eyf7BEahWUiunoVw9SwkVy9g
	ZF7FKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERzJz6R2MK5ssDjEKMDBqMTDe2Lp5yAh1sSy
	4srcQ4wSHMxKIrw/G74ECfGmJFZWpRblxxeV5qQWH2JMBjp8IrOUaHI+MMnklcQbGpuYGVka
	mVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAOjQoZUlv5Mh4xZciGrizkiTYxc
	lrQ7u8Z/vPVeiOHFyYBrjO8uSbvVPTE+6Ft3sbBtSsLUvm7G8Lg3WyXtjzstCj9XY/A62sDi
	u6CAcZNFR2e0u26c3NVPDbcyDgkuqFyv2/3h4P1TdVnvZ5pvq5seHHHzVNw+O3vRpPuaCk6l
	nEw7dl1f26vEUpyRaKjFXFScCACImvqhKAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

Sorry for the delay.
When I tested this patch, a deadlock was occurred, so I couldn't afford
to look inside in more detail.
When I see again, there is a bug wrt blkno.
Please see below.

2014-01-28 (화), 10:28 +0800, Chao Yu:
> This patch help us to cleanup the readahead code by merging ra_{sit,nat}_pages
> function into ra_meta_pages.
> Additionally the new function is used to readahead cp block in
> recover_orphan_inodes.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/checkpoint.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/f2fs/f2fs.h       |   10 +++++++
>  fs/f2fs/node.c       |   38 +-----------------------
>  fs/f2fs/segment.c    |   43 +---------------------------
>  4 files changed, 90 insertions(+), 79 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index 293d048..a1986c3 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -75,6 +75,82 @@ out:
>  	return page;
>  }
>  
> +inline int get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
> +{
> +	switch (type) {
> +	case META_NAT:
> +		return NM_I(sbi)->max_nid / NAT_ENTRY_PER_BLOCK;
> +	case META_SIT:
> +		return SIT_BLK_CNT(sbi);
> +	case META_CP:
> +		return 0;
> +	default:
> +		BUG();
> +	}
> +}
> +
> +/*
> + * Readahead CP/NAT/SIT pages
> + */
> +int ra_meta_pages(struct f2fs_sb_info *sbi, int start, int nrpages, int type)
> +{
> +	struct address_space *mapping = sbi->meta_inode->i_mapping;

	We don't need to do this. Instead, we can use META_MAPPING(sbi) below.

> +	struct page *page;
> +	block_t blk_addr, prev_blk_addr = 0;
> +	int blkno = start;
> +	int max_blks = get_max_meta_blks(sbi, type);

	block_t prev_blk_addr = 0;
	struct page *page;
	int blkno = start;
	int max_blks = get_max_meta_blks(sbi, type);

> +	struct f2fs_io_info fio = {
> +		.type = META,
> +		.rw = READ_SYNC | REQ_META | REQ_PRIO
> +	};
> +
> +	for (blkno = start; blkno < start + nrpages; blkno++) {

	for (; nrpages-- > 0; blkno++) {
		block_t blk_addr;

 --> In the case of META_NAT, blkno becomes 0 if it hits max_blks.
     So, we should not use *blkno < start + nrpages*.

> +
> +		switch (type) {
> +		case META_NAT:
> +			/* get nat block addr */
> +			if (unlikely(blkno >= max_blks))
> +				blkno = 0;
> +			blk_addr = current_nat_addr(sbi,
> +					blkno * NAT_ENTRY_PER_BLOCK);
> +			break;
> +		case META_SIT:
> +			/* get sit block addr */
> +			if (unlikely(blkno >= max_blks))
> +				goto out;
> +			blk_addr = current_sit_addr(sbi,
> +					blkno * SIT_ENTRY_PER_BLOCK);
> +			if (blkno != start && prev_blk_addr + 1 != blk_addr)
> +				goto out;
> +			prev_blk_addr = blk_addr;
> +			break;
> +		case META_CP:
> +			/* get cp block addr */
> +			blk_addr = blkno;
> +			break;
> +		default:
> +			BUG();
> +		}
> +
> +		page = grab_cache_page(mapping, blk_addr);

		page = grab_cache_page(META_MAPPING(sbi), blk_addr);

> +		if (!page)
> +			continue;
> +		if (PageUptodate(page)) {
> +			mark_page_accessed(page);
> +			f2fs_put_page(page, 1);
> +			continue;
> +		}
> +
> +		f2fs_submit_page_mbio(sbi, page, blk_addr, &fio);
> +		mark_page_accessed(page);
> +		f2fs_put_page(page, 0);
> +	}
> +out:
> +	f2fs_submit_merged_bio(sbi, META, READ);
> +	return blkno - start;
> +}
> +
>  static int f2fs_write_meta_page(struct page *page,
>  				struct writeback_control *wbc)
>  {
> @@ -285,6 +361,8 @@ void recover_orphan_inodes(struct f2fs_sb_info *sbi)
>  	start_blk = __start_cp_addr(sbi) + 1;
>  	orphan_blkaddr = __start_sum_addr(sbi) - 1;
>  
> +	ra_meta_pages(sbi, start_blk, orphan_blkaddr, META_CP);
> +
>  	for (i = 0; i < orphan_blkaddr; i++) {
>  		struct page *page = get_meta_page(sbi, start_blk + i);
>  		struct f2fs_orphan_block *orphan_blk;
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index af51a0b..69ffc1b 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -88,6 +88,15 @@ enum {
>  	SIT_BITMAP
>  };
>  
> +/*
> + * For CP/NAT/SIT readahead
> + */
> +enum {
> +	META_CP,
> +	META_NAT,
> +	META_SIT
> +};
> +
>  /* for the list of orphan inodes */
>  struct orphan_inode_entry {
>  	struct list_head list;	/* list head */
> @@ -1158,6 +1167,7 @@ void destroy_segment_manager_caches(void);
>   */
>  struct page *grab_meta_page(struct f2fs_sb_info *, pgoff_t);
>  struct page *get_meta_page(struct f2fs_sb_info *, pgoff_t);
> +int ra_meta_pages(struct f2fs_sb_info *, int, int, int);
>  long sync_meta_pages(struct f2fs_sb_info *, enum page_type, long);
>  int acquire_orphan_inode(struct f2fs_sb_info *);
>  void release_orphan_inode(struct f2fs_sb_info *);
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index b0649b7..2f7ae6f 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -82,42 +82,6 @@ static struct page *get_next_nat_page(struct f2fs_sb_info *sbi, nid_t nid)
>  	return dst_page;
>  }
>  
> -/*
> - * Readahead NAT pages
> - */
> -static void ra_nat_pages(struct f2fs_sb_info *sbi, int nid)
> -{
> -	struct address_space *mapping = META_MAPPING(sbi);
> -	struct f2fs_nm_info *nm_i = NM_I(sbi);
> -	struct page *page;
> -	pgoff_t index;
> -	int i;
> -	struct f2fs_io_info fio = {
> -		.type = META,
> -		.rw = READ_SYNC | REQ_META | REQ_PRIO
> -	};
> -
> -
> -	for (i = 0; i < FREE_NID_PAGES; i++, nid += NAT_ENTRY_PER_BLOCK) {
> -		if (unlikely(nid >= nm_i->max_nid))
> -			nid = 0;
> -		index = current_nat_addr(sbi, nid);
> -
> -		page = grab_cache_page(mapping, index);
> -		if (!page)
> -			continue;
> -		if (PageUptodate(page)) {
> -			mark_page_accessed(page);
> -			f2fs_put_page(page, 1);
> -			continue;
> -		}
> -		f2fs_submit_page_mbio(sbi, page, index, &fio);
> -		mark_page_accessed(page);
> -		f2fs_put_page(page, 0);
> -	}
> -	f2fs_submit_merged_bio(sbi, META, READ);
> -}
> -
>  static struct nat_entry *__lookup_nat_cache(struct f2fs_nm_info *nm_i, nid_t n)
>  {
>  	return radix_tree_lookup(&nm_i->nat_root, n);
> @@ -1413,7 +1377,7 @@ static void build_free_nids(struct f2fs_sb_info *sbi)
>  		return;
>  
>  	/* readahead nat pages to be scanned */
> -	ra_nat_pages(sbi, nid);
> +	ra_meta_pages(sbi, NAT_BLOCK_OFFSET(nid), FREE_NID_PAGES, META_NAT);
>  
>  	while (1) {
>  		struct page *page = get_current_nat_page(sbi, nid);
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 7caac5f..4c2b35b 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -1583,47 +1583,6 @@ static int build_curseg(struct f2fs_sb_info *sbi)
>  	return restore_curseg_summaries(sbi);
>  }
>  
> -static int ra_sit_pages(struct f2fs_sb_info *sbi, int start, int nrpages)
> -{
> -	struct address_space *mapping = META_MAPPING(sbi);
> -	struct page *page;
> -	block_t blk_addr, prev_blk_addr = 0;
> -	int sit_blk_cnt = SIT_BLK_CNT(sbi);
> -	int blkno = start;
> -	struct f2fs_io_info fio = {
> -		.type = META,
> -		.rw = READ_SYNC | REQ_META | REQ_PRIO
> -	};
> -
> -	for (; blkno < start + nrpages && blkno < sit_blk_cnt; blkno++) {
> -
> -		blk_addr = current_sit_addr(sbi, blkno * SIT_ENTRY_PER_BLOCK);
> -
> -		if (blkno != start && prev_blk_addr + 1 != blk_addr)
> -			break;
> -		prev_blk_addr = blk_addr;
> -repeat:
> -		page = grab_cache_page(mapping, blk_addr);
> -		if (!page) {
> -			cond_resched();
> -			goto repeat;
> -		}
> -		if (PageUptodate(page)) {
> -			mark_page_accessed(page);
> -			f2fs_put_page(page, 1);
> -			continue;
> -		}
> -
> -		f2fs_submit_page_mbio(sbi, page, blk_addr, &fio);
> -
> -		mark_page_accessed(page);
> -		f2fs_put_page(page, 0);
> -	}
> -
> -	f2fs_submit_merged_bio(sbi, META, READ);
> -	return blkno - start;
> -}
> -
>  static void build_sit_entries(struct f2fs_sb_info *sbi)
>  {
>  	struct sit_info *sit_i = SIT_I(sbi);
> @@ -1635,7 +1594,7 @@ static void build_sit_entries(struct f2fs_sb_info *sbi)
>  	int nrpages = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
>  
>  	do {
> -		readed = ra_sit_pages(sbi, start_blk, nrpages);
> +		readed = ra_meta_pages(sbi, start_blk, nrpages, META_SIT);
>  
>  		start = start_blk * sit_i->sents_per_block;
>  		end = (start_blk + readed) * sit_i->sents_per_block;

-- 
Jaegeuk Kim
Samsung

