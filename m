Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaEWFPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 01:15:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:15348 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbaEWFPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 01:15:46 -0400
MIME-version: 1.0
Content-disposition: inline
Content-type: text/plain; charset=utf-8
X-AuditID: cbfee68f-b7fef6d000003970-bd-537ed97bd071
Content-transfer-encoding: 8BIT
Date: Fri, 23 May 2014 14:14:13 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <chao2.yu@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH] f2fs: avoid crash when trace
 f2fs_submit_page_mbio event in ra_sum_pages
Message-id: <20140523051413.GB26933@cm224.lee>
References: <005801cf70e7$66cb0090$346101b0$@samsung.com>
 <1400643406.12240.6.camel@kjgkr>
In-reply-to: <1400643406.12240.6.camel@kjgkr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zI93qm3XBBpd/mVn8b/rIZvFk/Sxm
	i0uL3C327D3JYnF51xw2B1aPTas62Tx2L/jM5NG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	R2a/ZS5YYFSxed58lgbGfepdjJwcEgImEsv6fzFD2GISF+6tZ+ti5OIQEljGKLHwwT/WLkYO
	sKIPM7JAaoQEFjFK9F9WA7F5BQQlfky+xwJSwiwgL3HkUjZImFlAWuLR3xnsEGF1iSlTciE6
	fzJKXFnpBWKzCKhKrFl1igXEZhPQkmg/vRbMFhFQkTi06DI7xJhORomGj3ogtrBAlsT+RY8Y
	IbbqSew+8Z8JYmaMxL8/V8Gu5xTQlfh/fRdYryjQnCknt4F9IiFwiF3iRetEJojFAhLfJh9i
	gfhKVmLTAajPJSUOrrjBMoFRfBaSx2YhPDYLyWOzEB5bwMiyilE0tSC5oDgpvchYrzgxt7g0
	L10vOT93EyMk9vp3MN49YH2IMRlo+URmKdHkfGDs5pXEGxqbGVmYmpgaG5lbmpEmrCTOe/9h
	UpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxlXhzBm90VEKqy5WKids6FZdtP/Bq1ktLlHx
	f4W0f3+ZuOF42qu4FbcMnVb6nlLimfertbYhct7+E07/d3r965ayDmN9m7zqwhf9f28nXI8o
	us/2Iv7+oUavC1frzts++PvkyBPzhjsKZfwzOy0u2/tfjwyoYfaZ+DC7zH6ncV3GtJXLpTJ/
	VCuxFGckGmoxFxUnAgCJtcrw0wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd3qm3XBBh+nGln8b/rIZvFk/Sxm
	i0uL3C327D3JYnF51xw2B1aPTas62Tx2L/jM5NG3ZRWjx+dNcgEsUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAe5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhHWMGUdmv2UuWGBUsXnefJYGxn3qXYwcHBICJhIfZmR1MXIC
	mWISF+6tZwOxhQQWMUr0X1YDsXkFBCV+TL7HAlLOLCAvceRSNkiYWUBa4tHfGewQYXWJKVNy
	ITp/MkpcWekFYrMIqEqsWXWKBcRmE9CSaD+9FswWEVCROLToMjvEmE5GiYaPeiC2sECWxP5F
	jxghtupJ7D7xnwliZozEvz9XmUFsTgFdif/Xd4H1igLNmXJyG9sERsFZSA6dhXDoLCSHzkI4
	dAEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Mh+Jr2DcVWDxSFGAQ5GJR7eB0x1wUKs
	iWXFlbmHGCU4mJVEeG9cAQrxpiRWVqUW5ccXleakFh9iTAb6eSKzlGhyPjDp5JXEGxqbmBlZ
	GplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDY7nAxO1iD4s8rRawPFp0w176
	dsbcizP8lrd+fPt/y6M7swrvJTyu2hEgHu5eECDS8DGibe6uDAYZV57WzfLNuavm8zQ4TTlr
	vH3zZg426wedQl91dI89ve7+IeznE8V9m8vlvdjEA69aGHCXBTZM1OlI2PHbxNdJiMOcPbZF
	6PKtdP/L+9TeKbEUZyQaajEXFScCAJbcoVAwAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 12:36:46PM +0900, Jaegeuk Kim wrote:
> Hi Chao,
> 
> 2014-05-16 (금), 17:14 +0800, Chao Yu:
> > Previously we allocate pages with no mapping in ra_sum_pages(), so we may
> > encounter a crash in event trace of f2fs_submit_page_mbio where we access
> > mapping data of the page.
> > 
> > We'd better allocate pages in bd_inode mapping and invalidate these pages after
> > we restore data from pages. It could avoid crash in above scenario.
> > 
> > Call Trace:
> >  [<f1031630>] ? ftrace_raw_event_f2fs_write_checkpoint+0x80/0x80 [f2fs]
> >  [<f10377bb>] f2fs_submit_page_mbio+0x1cb/0x200 [f2fs]
> >  [<f103c5da>] restore_node_summary+0x13a/0x280 [f2fs]
> >  [<f103e22d>] build_curseg+0x2bd/0x620 [f2fs]
> >  [<f104043b>] build_segment_manager+0x1cb/0x920 [f2fs]
> >  [<f1032c85>] f2fs_fill_super+0x535/0x8e0 [f2fs]
> >  [<c115b66a>] mount_bdev+0x16a/0x1a0
> >  [<f102f63f>] f2fs_mount+0x1f/0x30 [f2fs]
> >  [<c115c096>] mount_fs+0x36/0x170
> >  [<c1173635>] vfs_kern_mount+0x55/0xe0
> >  [<c1175388>] do_mount+0x1e8/0x900
> >  [<c1175d72>] SyS_mount+0x82/0xc0
> >  [<c16059cc>] sysenter_do_call+0x12/0x22
> > 
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/node.c |   49 ++++++++++++++++++++++++++++---------------------
> >  1 file changed, 28 insertions(+), 21 deletions(-)
> > 
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index 3d60d3d..b5cd814 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -1658,13 +1658,16 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
> >  
> >  /*
> >   * ra_sum_pages() merge contiguous pages into one bio and submit.
> > - * these pre-readed pages are linked in pages list.
> > + * these pre-readed pages are alloced in bd_inode's mapping tree.
> >   */
> > -static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
> > +static int ra_sum_pages(struct f2fs_sb_info *sbi, struct page **pages,
> >  				int start, int nrpages)
> >  {
> >  	struct page *page;
> > +	struct inode *inode = sbi->sb->s_bdev->bd_inode;

How about use sbi->meta_inode instead of bd_inode, then we can do
caching summary pages for further i/o.

> > +	struct address_space *mapping = inode->i_mapping;
> >  	int page_idx = start;
> > +	int alloced, readed;
> >  	struct f2fs_io_info fio = {
> >  		.type = META,
> >  		.rw = READ_SYNC | REQ_META | REQ_PRIO
> > @@ -1672,21 +1675,23 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
> >  
> >  	for (; page_idx < start + nrpages; page_idx++) {
> >  		/* alloc temporal page for read node summary info*/
> > -		page = alloc_page(GFP_F2FS_ZERO);
> > +		page = grab_cache_page(mapping, page_idx);
> >  		if (!page)
> >  			break;
> > -
> > -		lock_page(page);
> > -		page->index = page_idx;
> > -		list_add_tail(&page->lru, pages);
> > +		page_cache_release(page);
> 
> IMO, we don't need to do like this.
> Instead,
> 	for() {
> 		page = grab_cache_page();
> 		if (!page)
> 			break;
> 		page[page_idx] = page;
> 		f2fs_submit_page_mbio(sbi, page, &fio);
> 	}
> 	f2fs_submit_merged_bio(sbi, META, READ);
> 	return page_idx - start;
> 
> Afterwards, in restore_node_summry(),
> 	lock_page() will wait the end_io for read.
> 	...
> 	f2fs_put_page(pages[index], 1);
> 
> Thanks,
> 
> >  	}
> >  
> > -	list_for_each_entry(page, pages, lru)
> > -		f2fs_submit_page_mbio(sbi, page, page->index, &fio);
> > +	alloced = page_idx - start;
> > +	readed = find_get_pages_contig(mapping, start, alloced, pages);
> > +	BUG_ON(alloced != readed);
> > +
> > +	for (page_idx = 0; page_idx < readed; page_idx++)
> > +		f2fs_submit_page_mbio(sbi, pages[page_idx],
> > +					pages[page_idx]->index, &fio);
> >  
> >  	f2fs_submit_merged_bio(sbi, META, READ);
> >  
> > -	return page_idx - start;
> > +	return readed;
> >  }
> >  
> >  int restore_node_summary(struct f2fs_sb_info *sbi,
> > @@ -1694,11 +1699,11 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> >  {
> >  	struct f2fs_node *rn;
> >  	struct f2fs_summary *sum_entry;
> > -	struct page *page, *tmp;
> > +	struct inode *inode = sbi->sb->s_bdev->bd_inode;
> >  	block_t addr;
> >  	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> > -	int i, last_offset, nrpages, err = 0;
> > -	LIST_HEAD(page_list);
> > +	struct page *pages[bio_blocks];
> > +	int i, index, last_offset, nrpages, err = 0;
> >  
> >  	/* scan the node segment */
> >  	last_offset = sbi->blocks_per_seg;
> > @@ -1709,29 +1714,31 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> >  		nrpages = min(last_offset - i, bio_blocks);
> >  
> >  		/* read ahead node pages */
> > -		nrpages = ra_sum_pages(sbi, &page_list, addr, nrpages);
> > +		nrpages = ra_sum_pages(sbi, pages, addr, nrpages);
> >  		if (!nrpages)
> >  			return -ENOMEM;
> >  
> > -		list_for_each_entry_safe(page, tmp, &page_list, lru) {
> > +		for (index = 0; index < nrpages; index++) {
> >  			if (err)
> >  				goto skip;
> >  
> > -			lock_page(page);
> > -			if (unlikely(!PageUptodate(page))) {
> > +			lock_page(pages[index]);
> > +			if (unlikely(!PageUptodate(pages[index]))) {
> >  				err = -EIO;
> >  			} else {
> > -				rn = F2FS_NODE(page);
> > +				rn = F2FS_NODE(pages[index]);
> >  				sum_entry->nid = rn->footer.nid;
> >  				sum_entry->version = 0;
> >  				sum_entry->ofs_in_node = 0;
> >  				sum_entry++;
> >  			}
> > -			unlock_page(page);
> > +			unlock_page(pages[index]);
> >  skip:
> > -			list_del(&page->lru);
> > -			__free_pages(page, 0);
> > +			page_cache_release(pages[index]);
> >  		}
> > +
> > +		invalidate_mapping_pages(inode->i_mapping, addr,
> > +							addr + nrpages);
> >  	}
> >  	return err;
> >  }
> 
> -- 
> Jaegeuk Kim



> ------------------------------------------------------------------------------
> "Accelerate Dev Cycles with Automated Cross-Browser Testing - For FREE
> Instantly run your Selenium tests across 300+ browser/OS combos.
> Get unparalleled scalability from the best Selenium testing platform available
> Simple to use. Nothing to install. Get started now for free."
> http://p.sf.net/sfu/SauceLabs

> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

