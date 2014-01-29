Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbaA2Aqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 19:46:44 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:65232 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbaA2Aql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 19:46:41 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f266d00000287c-f1-52e84f6e21fb
Content-transfer-encoding: 8BIT
Message-id: <1390956313.25542.64.camel@kjgkr>
Subject: Re: [GIT PULL] Core block IO changes for 3.14
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Date: Wed, 29 Jan 2014 09:45:13 +0900
In-reply-to: <20140129110536.00ce3c9e580f747fd0f1d0e6@canb.auug.org.au>
References: <20140128224336.GF25989@kernel.dk>
 <20140128225229.GH25989@kernel.dk>
 <20140129110536.00ce3c9e580f747fd0f1d0e6@canb.auug.org.au>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zQ908/xdBBtsOcFusvtvPZnF51xw2
	i617r7JbPOp7y+7A4tF44wabx+WzpR4nZvxm8fi8SS6AJYrLJiU1J7MstUjfLoErY87yBvaC
	U+UVC878Z25gvBzTxcjJISFgItF7cDoLhC0mceHeerYuRi4OIYFljBKHXj9ghCna0LOEESIx
	nVFizaNnYAleAUGJH5PvAXVzcDALyEscuZQNEmYWUJeYNG8RM4gtJPCSUeLPaQeIcl2Jme1d
	YHFhATOJl5cvsYK0sgloS2zebwBRrijxdv9dsLAIUPjAbwGIiQUSX74cA+tkEVCVuPTpCtjJ
	nALuElP3b2eCuGwCo8Sxp71gRfwCohKHF25nhjhfSWJ3eyc7SJGEwCl2iSV/vjFBTBKQ+Db5
	ENj5EgKyEpsOQNVLShxccYMFaNwsJE/OQnhyFpInFzAyr2IUTS1ILihOSi8y0StOzC0uzUvX
	S87P3cQIibsJOxjvHbA+xJgMtHEis5Rocj4wbvNK4g2NzYwsTE1MjY3MLc1IE1YS51V7lBQk
	JJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXF1+gc/NiW2xkv9B2/flVxUM/VKaPLKuzveiQTq
	tuuctp/ixheQ+Sk879VvY8WMxWLpogJdT0+k75E/mSNszuWr9uPGO42y1MjlVqcWX/m1aLno
	5dZ9b1gmqk42iP/4ef2ny3feLtp3deu0KcuTq55VHRTh8TJwcPQ6/TruvGnabsnbeXOqrh9U
	YinOSDTUYi4qTgQARbHgD9ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQd08/xdBBls/sVqsvtvPZnF51xw2
	i617r7JbPOp7y+7A4tF44wabx+WzpR4nZvxm8fi8SS6AJaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMWPO8gb2glPlFQvO/GduYLwc08XIySEhYCKxoWcJI4QtJnHh3nq2
	LkYuDiGB6YwSax49A0vwCghK/Jh8j6WLkYODWUBe4silbJAws4C6xKR5i5hBbCGBl4wSf047
	QJTrSsxs7wKLCwuYSby8fIkVpJVNQFti834DiHJFibf774KFRYDCB34LQEwskPjy5RhYJ4uA
	qsSlT1dYQGxOAXeJqfu3M0FcNoFR4tjTXrAifgFRicMLtzNDnK8ksbu9k30Co9AsJEfPQjh6
	FpKjFzAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjupnUjsYVzZYHGIU4GBU4uFdcfF5
	kBBrYllxZe4hRgkOZiUR3umSL4KEeFMSK6tSi/Lji0pzUosPMSYDXT6RWUo0OR+YcPJK4g2N
	TcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgVFU7rDufKHXSrskCtKq
	PL89P2qnvzvzbeD+TGu2BQ/zog2frbrsURde8G6Zzbei2NP9H3Yulwg70VdWo/x2+a+1m9yb
	xFvPxMwyzixcdN9zw4t3S7k/Pd/QdVvSpVk5dYI+62GeCVP+qToebFhfPGe1CaPmzNeikcu8
	V6xhSjdfpKYR7ccTVarEUpyRaKjFXFScCAAx8EB7LgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens and Stephen,

In the case of f2fs, could you please check the following code changes?
It is based on the following commit from Linus tree.

commit d891ea23d5203e5c47439b2a174f86a00b356a6c
Merge: 08d21b5 125d725
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Jan 28 11:02:23 2014 -0800

    Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client

---
 fs/f2fs/data.c              | 31 ++++++++++++++-----------------
 include/trace/events/f2fs.h |  4 ++--
 2 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 0ae5587..55ae30a 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -26,40 +26,37 @@
 
 static void f2fs_read_end_io(struct bio *bio, int err)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
+	struct bio_vec *bvec;
+	int i;
 
-	do {
+	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
 
-		if (--bvec >= bio->bi_io_vec)
-			prefetchw(&bvec->bv_page->flags);
-
-		if (unlikely(!uptodate)) {
+		if (unlikely(err)) {
 			ClearPageUptodate(page);
 			SetPageError(page);
 		} else {
 			SetPageUptodate(page);
 		}
 		unlock_page(page);
-	} while (bvec >= bio->bi_io_vec);
+	}
 
 	bio_put(bio);
 }
 
 static void f2fs_write_end_io(struct bio *bio, int err)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
-	struct f2fs_sb_info *sbi =
F2FS_SB(bvec->bv_page->mapping->host->i_sb);
+	struct f2fs_sb_info *sbi = NULL;
+	struct bio_vec *bvec;
+	int i;
 
-	do {
+	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
 
-		if (--bvec >= bio->bi_io_vec)
-			prefetchw(&bvec->bv_page->flags);
+		if (!sbi)
+			sbi = F2FS_SB(bvec->bv_page->mapping->host->i_sb);
 
-		if (unlikely(!uptodate)) {
+		if (unlikely(err)) {
 			SetPageError(page);
 			set_bit(AS_EIO, &page->mapping->flags);
 			set_ckpt_flags(sbi->ckpt, CP_ERROR_FLAG);
@@ -67,7 +64,7 @@ static void f2fs_write_end_io(struct bio *bio, int
err)
 		}
 		end_page_writeback(page);
 		dec_page_count(sbi, F2FS_WRITEBACK);
-	} while (bvec >= bio->bi_io_vec);
+	}
 
 	if (bio->bi_private)
 		complete(bio->bi_private);
@@ -91,7 +88,7 @@ static struct bio *__bio_alloc(struct f2fs_sb_info
*sbi, block_t blk_addr,
 	bio = bio_alloc(GFP_NOIO, npages);
 
 	bio->bi_bdev = sbi->sb->s_bdev;
-	bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
+	bio->bi_iter.bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
 	bio->bi_end_io = is_read ? f2fs_read_end_io : f2fs_write_end_io;
 
 	return bio;
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 3b9f28d..67f38fa 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -629,8 +629,8 @@ DECLARE_EVENT_CLASS(f2fs__submit_bio,
 		__entry->dev		= sb->s_dev;
 		__entry->rw		= rw;
 		__entry->type		= type;
-		__entry->sector		= bio->bi_sector;
-		__entry->size		= bio->bi_size;
+		__entry->sector		= bio->bi_iter.bi_sector;
+		__entry->size		= bio->bi_iter.bi_size;
 	),
 
 	TP_printk("dev = (%d,%d), %s%s, %s, sector = %lld, size = %u",
-- 
1.8.4.474.g128a96c

Thanks,

2014-01-29 (수), 11:05 +1100, Stephen Rothwell:
> Hi all,
> 
> On Tue, 28 Jan 2014 15:52:29 -0700 Jens Axboe <axboe@kernel.dk> wrote:
> >
> > On Tue, Jan 28 2014, Jens Axboe wrote:
> > > 
> > > This is the pull request for the core block IO changes for 3.14. The
> > > major piece in here is the immutable bio_ve series from Kent, the rest
> > > is fairly minor. It was supposed to go in last round, but various issues
> > > pushed it to this release instead. The pull request contains:
> > > 
> > > 
> > > - Various smaller blk-mq fixes from different folks. Nothing major here,
> > >   just minor fixes and cleanups.
> > > 
> > > - Fix for a memory leak in the error path in the block ioctl code from
> > >   Christian Engelmayer.
> > > 
> > > - Header export fix from CaiZhiyong.
> > > 
> > > - Finally the immutable biovec changes from Kent Overstreet. This
> > >   enables some nice future work on making arbitrarily sized bios
> > >   possible, and splitting more efficient. Related fixes to immutable
> > >   bio_vecs:
> > > 
> > >         - dm-cache immutable fixup from Mike Snitzer.
> > >         - btrfs immutable fixup from Muthu Kumar.
> > > 
> > > - bio-integrity fix from Nic Bellinger, which is also going to stable.
> > > 
> > > 
> > > Please pull! There will be a bit of merge work for you, but it should be
> > > fairly straight forward. It's mostly related to changin:
> > > 
> > > bio->bi_sector  -> bio->bi_iter.bi_sector
> > > bio->bi_size    -> bio->bi_iter.bi_size
> > > 
> > > 
> > > git://git.kernel.dk/linux-block.git for-3.14/core
> > 
> > BTW, let me know if you want me to merge this. The above has been in
> > for-next since forever, and Stephen has carried a fix or two for new
> > merges.
> 
> The worst bit is the conflicts with the f2fs changes that have already
> been merged.  My current merge commit looks like this (though I don't
> remember getting any comments on my fixes):
> 
> da3f6c793c656a022453df8bf458d13e5a353beb
> diff --cc drivers/md/dm-thin.c
> index 726228b33a01,357eb272dbd9..faaf944597ab
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@@ -1258,8 -1262,8 +1264,8 @@@ static void process_bio_read_only(struc
>   	r = dm_thin_find_block(tc->td, block, 1, &lookup_result);
>   	switch (r) {
>   	case 0:
> - 		if (lookup_result.shared && (rw == WRITE) && bio->bi_size)
> + 		if (lookup_result.shared && (rw == WRITE) && bio->bi_iter.bi_size)
>  -			bio_io_error(bio);
>  +			handle_unserviceable_bio(tc->pool, bio);
>   		else {
>   			inc_all_io_entry(tc->pool, bio);
>   			remap_and_issue(tc, bio, lookup_result.block);
> diff --cc drivers/md/raid10.c
> index 8d39d63281b9,6d43d88657aa..33fc408e5eac
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@@ -1319,8 -1256,8 +1256,8 @@@ read_again
>   			/* Could not read all from this device, so we will
>   			 * need another r10_bio.
>   			 */
>  -			sectors_handled = (r10_bio->sectors + max_sectors
>  +			sectors_handled = (r10_bio->sector + max_sectors
> - 					   - bio->bi_sector);
> + 					   - bio->bi_iter.bi_sector);
>   			r10_bio->sectors = max_sectors;
>   			spin_lock_irq(&conf->device_lock);
>   			if (bio->bi_phys_segments == 0)
> diff --cc fs/btrfs/extent_io.c
> index fbe501d3bd01,bcb6f1b780d6..85bbd01f1271
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@@ -2375,12 -2332,15 +2375,13 @@@ int end_extent_writepage(struct page *p
>    */
>   static void end_bio_extent_writepage(struct bio *bio, int err)
>   {
> - 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
> + 	struct bio_vec *bvec;
>  -	struct extent_io_tree *tree;
>   	u64 start;
>   	u64 end;
> + 	int i;
>   
> - 	do {
> + 	bio_for_each_segment_all(bvec, bio, i) {
>   		struct page *page = bvec->bv_page;
>  -		tree = &BTRFS_I(page->mapping->host)->io_tree;
>   
>   		/* We always issue full-page reads, but if some block
>   		 * in a page fails to read, blk_update_request() will
> diff --cc fs/btrfs/inode.c
> index 1ef056837755,7ab0e94ad492..f0422a5efa78
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@@ -7016,10 -6891,11 +7013,11 @@@ static void btrfs_end_dio_bio(struct bi
>   	struct btrfs_dio_private *dip = bio->bi_private;
>   
>   	if (err) {
>  -		printk(KERN_ERR "btrfs direct IO failed ino %llu rw %lu "
>  -		      "sector %#Lx len %u err no %d\n",
>  +		btrfs_err(BTRFS_I(dip->inode)->root->fs_info,
>  +			  "direct IO failed ino %llu rw %lu sector %#Lx len %u err no %d",
>   		      btrfs_ino(dip->inode), bio->bi_rw,
> - 		      (unsigned long long)bio->bi_sector, bio->bi_size, err);
> + 		      (unsigned long long)bio->bi_iter.bi_sector,
> + 		      bio->bi_iter.bi_size, err);
>   		dip->errors = 1;
>   
>   		/*
> diff --cc fs/f2fs/data.c
> index 0ae558723506,a2c8de8ba6ce..25d675e6a138
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@@ -24,195 -24,6 +24,192 @@@
>   #include "segment.h"
>   #include <trace/events/f2fs.h>
>   
>  +static void f2fs_read_end_io(struct bio *bio, int err)
>  +{
> - 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
> - 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
> ++	struct bio_vec *bvec;
> ++	int i;
>  +
> - 	do {
> ++	bio_for_each_segment_all(bvec, bio, i) {
>  +		struct page *page = bvec->bv_page;
>  +
> - 		if (--bvec >= bio->bi_io_vec)
> - 			prefetchw(&bvec->bv_page->flags);
> - 
> - 		if (unlikely(!uptodate)) {
> ++		if (unlikely(err)) {
>  +			ClearPageUptodate(page);
>  +			SetPageError(page);
>  +		} else {
>  +			SetPageUptodate(page);
>  +		}
>  +		unlock_page(page);
> - 	} while (bvec >= bio->bi_io_vec);
> ++	}
>  +
>  +	bio_put(bio);
>  +}
>  +
>  +static void f2fs_write_end_io(struct bio *bio, int err)
>  +{
> - 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
> - 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
> - 	struct f2fs_sb_info *sbi = F2FS_SB(bvec->bv_page->mapping->host->i_sb);
> ++	struct bio_vec *bvec;
> ++	struct f2fs_sb_info *sbi = NULL;
> ++	int i;
>  +
> - 	do {
> ++	bio_for_each_segment_all(bvec, bio, i) {
>  +		struct page *page = bvec->bv_page;
>  +
> - 		if (--bvec >= bio->bi_io_vec)
> - 			prefetchw(&bvec->bv_page->flags);
> ++		if (!sbi)
> ++			sbi = F2FS_SB(bvec->bv_page->mapping->host->i_sb);
>  +
> - 		if (unlikely(!uptodate)) {
> ++		if (unlikely(err)) {
>  +			SetPageError(page);
>  +			set_bit(AS_EIO, &page->mapping->flags);
>  +			set_ckpt_flags(sbi->ckpt, CP_ERROR_FLAG);
>  +			sbi->sb->s_flags |= MS_RDONLY;
>  +		}
>  +		end_page_writeback(page);
>  +		dec_page_count(sbi, F2FS_WRITEBACK);
> - 	} while (bvec >= bio->bi_io_vec);
> ++	}
>  +
>  +	if (bio->bi_private)
>  +		complete(bio->bi_private);
>  +
>  +	if (!get_pages(sbi, F2FS_WRITEBACK) &&
>  +			!list_empty(&sbi->cp_wait.task_list))
>  +		wake_up(&sbi->cp_wait);
>  +
>  +	bio_put(bio);
>  +}
>  +
>  +/*
>  + * Low-level block read/write IO operations.
>  + */
>  +static struct bio *__bio_alloc(struct f2fs_sb_info *sbi, block_t blk_addr,
>  +				int npages, bool is_read)
>  +{
>  +	struct bio *bio;
>  +
>  +	/* No failure on bio allocation */
>  +	bio = bio_alloc(GFP_NOIO, npages);
>  +
>  +	bio->bi_bdev = sbi->sb->s_bdev;
> - 	bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
> ++	bio->bi_iter.bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
>  +	bio->bi_end_io = is_read ? f2fs_read_end_io : f2fs_write_end_io;
>  +
>  +	return bio;
>  +}
>  +
>  +static void __submit_merged_bio(struct f2fs_bio_info *io)
>  +{
>  +	struct f2fs_io_info *fio = &io->fio;
>  +	int rw;
>  +
>  +	if (!io->bio)
>  +		return;
>  +
>  +	rw = fio->rw;
>  +
>  +	if (is_read_io(rw)) {
>  +		trace_f2fs_submit_read_bio(io->sbi->sb, rw,
>  +						fio->type, io->bio);
>  +		submit_bio(rw, io->bio);
>  +	} else {
>  +		trace_f2fs_submit_write_bio(io->sbi->sb, rw,
>  +						fio->type, io->bio);
>  +		/*
>  +		 * META_FLUSH is only from the checkpoint procedure, and we
>  +		 * should wait this metadata bio for FS consistency.
>  +		 */
>  +		if (fio->type == META_FLUSH) {
>  +			DECLARE_COMPLETION_ONSTACK(wait);
>  +			io->bio->bi_private = &wait;
>  +			submit_bio(rw, io->bio);
>  +			wait_for_completion(&wait);
>  +		} else {
>  +			submit_bio(rw, io->bio);
>  +		}
>  +	}
>  +
>  +	io->bio = NULL;
>  +}
>  +
>  +void f2fs_submit_merged_bio(struct f2fs_sb_info *sbi,
>  +				enum page_type type, int rw)
>  +{
>  +	enum page_type btype = PAGE_TYPE_OF_BIO(type);
>  +	struct f2fs_bio_info *io;
>  +
>  +	io = is_read_io(rw) ? &sbi->read_io : &sbi->write_io[btype];
>  +
>  +	mutex_lock(&io->io_mutex);
>  +
>  +	/* change META to META_FLUSH in the checkpoint procedure */
>  +	if (type >= META_FLUSH) {
>  +		io->fio.type = META_FLUSH;
>  +		io->fio.rw = WRITE_FLUSH_FUA | REQ_META | REQ_PRIO;
>  +	}
>  +	__submit_merged_bio(io);
>  +	mutex_unlock(&io->io_mutex);
>  +}
>  +
>  +/*
>  + * Fill the locked page with data located in the block address.
>  + * Return unlocked page.
>  + */
>  +int f2fs_submit_page_bio(struct f2fs_sb_info *sbi, struct page *page,
>  +					block_t blk_addr, int rw)
>  +{
>  +	struct bio *bio;
>  +
>  +	trace_f2fs_submit_page_bio(page, blk_addr, rw);
>  +
>  +	/* Allocate a new bio */
>  +	bio = __bio_alloc(sbi, blk_addr, 1, is_read_io(rw));
>  +
>  +	if (bio_add_page(bio, page, PAGE_CACHE_SIZE, 0) < PAGE_CACHE_SIZE) {
>  +		bio_put(bio);
>  +		f2fs_put_page(page, 1);
>  +		return -EFAULT;
>  +	}
>  +
>  +	submit_bio(rw, bio);
>  +	return 0;
>  +}
>  +
>  +void f2fs_submit_page_mbio(struct f2fs_sb_info *sbi, struct page *page,
>  +			block_t blk_addr, struct f2fs_io_info *fio)
>  +{
>  +	enum page_type btype = PAGE_TYPE_OF_BIO(fio->type);
>  +	struct f2fs_bio_info *io;
>  +	bool is_read = is_read_io(fio->rw);
>  +
>  +	io = is_read ? &sbi->read_io : &sbi->write_io[btype];
>  +
>  +	verify_block_addr(sbi, blk_addr);
>  +
>  +	mutex_lock(&io->io_mutex);
>  +
>  +	if (!is_read)
>  +		inc_page_count(sbi, F2FS_WRITEBACK);
>  +
>  +	if (io->bio && (io->last_block_in_bio != blk_addr - 1 ||
>  +						io->fio.rw != fio->rw))
>  +		__submit_merged_bio(io);
>  +alloc_new:
>  +	if (io->bio == NULL) {
>  +		int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
>  +
>  +		io->bio = __bio_alloc(sbi, blk_addr, bio_blocks, is_read);
>  +		io->fio = *fio;
>  +	}
>  +
>  +	if (bio_add_page(io->bio, page, PAGE_CACHE_SIZE, 0) <
>  +							PAGE_CACHE_SIZE) {
>  +		__submit_merged_bio(io);
>  +		goto alloc_new;
>  +	}
>  +
>  +	io->last_block_in_bio = blk_addr;
>  +
>  +	mutex_unlock(&io->io_mutex);
>  +	trace_f2fs_submit_page_mbio(page, fio->rw, fio->type, blk_addr);
>  +}
>  +
>   /*
>    * Lock ordering for the change of data block address:
>    * ->data_page
> diff --cc include/trace/events/f2fs.h
> index 3b9f28dfc849,bd3ee4fbe7a7..67f38faac589
> --- a/include/trace/events/f2fs.h
> +++ b/include/trace/events/f2fs.h
> @@@ -627,16 -614,16 +627,16 @@@ DECLARE_EVENT_CLASS(f2fs__submit_bio
>   
>   	TP_fast_assign(
>   		__entry->dev		= sb->s_dev;
>  -		__entry->btype		= btype;
>  -		__entry->sync		= sync;
>  +		__entry->rw		= rw;
>  +		__entry->type		= type;
> - 		__entry->sector		= bio->bi_sector;
> - 		__entry->size		= bio->bi_size;
> + 		__entry->sector		= bio->bi_iter.bi_sector;
> + 		__entry->size		= bio->bi_iter.bi_size;
>   	),
>   
>  -	TP_printk("dev = (%d,%d), type = %s, io = %s, sector = %lld, size = %u",
>  +	TP_printk("dev = (%d,%d), %s%s, %s, sector = %lld, size = %u",
>   		show_dev(__entry),
>  -		show_block_type(__entry->btype),
>  -		__entry->sync ? "sync" : "no sync",
>  +		show_bio_type(__entry->rw),
>  +		show_block_type(__entry->type),
>   		(unsigned long long)__entry->sector,
>   		__entry->size)
>   );
> 

-- 
Jaegeuk Kim
Samsung

