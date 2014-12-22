Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaLVCEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 21:04:32 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:12228 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785AbaLVCEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 21:04:30 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-7d-54977c2c7090
Date: Mon, 22 Dec 2014 11:03:17 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Chao Yu <chao2.yu@samsung.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] f2fs: add extent cache base on rb-tree
Message-id: <20141222020317.GB3335@lcm>
References: <001f01d01b79$954f0140$bfed03c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <001f01d01b79$954f0140$bfed03c0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e+Zvq5OzfQQg4NNUhb/mz6yWTxZP4vZ
	4tIid4vLu+awObB4bFrVyeaxe8FnJo++LasYPT5vkgtgieKySUnNySxLLdK3S+DK+HZkCVPB
	tx2MFRM+dbE1MD6azNjFyMkhIWAisezaWzYIW0ziwr31QDYXh5DAMkaJM1tuM8EUXbl+ixki
	sYhR4tedFVDOT6CqP1tZQapYBFQl5s3Zyw5iswloSbSfXssCYosIKEn8mr8IqIaDg1kgR2JP
	Qy6IKSxgL/HylSdIBa+AusT9Z0eYQWwhAUuJb4efskLEBSV+TL4HNoUZaOL6nceZIGxpiUd/
	Z4Bt4hSwkri+/RvYM6ICKhJTTm4De0BCYB27xLSfV9ggThOQ+Db5EAvIXgkBWYlNB5gh/pKU
	OLjiBssERrFZSNbNQrJuFpJ1CxiZVzGKphYkFxQnpReZ6BUn5haX5qXrJefnbmKExNOEHYz3
	DlgfYhTgYFTi4U3ImB4ixJpYVlyZe4jRFOiKicxSosn5wKjNK4k3NDYzsjA1MTU2Mrc0UxLn
	fS31M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD4yoXlyKjwzsOv+s7qPd729ZpB57c/2fk
	s/cLw/ZH3GtLnhtsZ1YqcWhg21kY0VRSI7sl5rroR2muVb0lT89+nhJzer9p74f/shwyy6y+
	f8q4MzubdZa8r0urzf6VOqz9pucsOtmL/XY+a/+xQ0ZopiJvyoH9RzVaLpxZ65HBdWfT/XBV
	hQ1t+kosxRmJhlrMRcWJAGf2wdaiAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t9jAV2dmukhBvuaRCz+N31ks3iyfhaz
	xaVF7haXd81hc2Dx2LSqk81j94LPTB59W1YxenzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjHmPHtyBKmgm87GCsmfOpia2B8NJmxi5GTQ0LAROLK9VvMELaYxIV7
	69m6GLk4hAQWMUr8urOCGcL5yShx5s9WVpAqFgFViXlz9rKD2GwCWhLtp9eygNgiAkoSv+Yv
	Aqrh4GAWyJHY05ALYgoL2Eu8fOUJUsEroC5x/9kRsF1CApYS3w4/ZYWIC0r8mHwPbAoz0MT1
	O48zQdjSEo/+zgDbxClgJXF9+zewm0UFVCSmnNzGNoFRYBaS9llI2mchaV/AyLyKUTS1ILmg
	OCk910ivODG3uDQvXS85P3cTIzhan0nvYFzVYHGIUYCDUYmHlzNteogQa2JZcWXuIUYJDmYl
	Ed57/kAh3pTEyqrUovz4otKc1OJDjKbAsJjILCWanA9MJHkl8YbGJmZGlkZmFkYm5uZK4rxK
	9m0hQgLpiSWp2ampBalFMH1MHJxSDYwSNZaRWknqm0SL3Hi+spRm8bF9vNNXdkn64P56ZanK
	Ro4NSu8idnJP1DykkXQnV/JYMWOcto4/n/mptLMs/R86L0Z8v5j4Pth8mq/A5TPFzT/YXFZO
	XnsnSklyYZhhSMTTStsCgR+X5i3/fUs7/LdxUG340tP13x/Vc+gcZ7lQPN89wLbLQ4mlOCPR
	UIu5qDgRAHal0MfsAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yu,

Good approach.
As you know, however, f2fs breaks extent itself due to COW.
Unlike other filesystem like btrfs, minimum extent of f2fs could have 4KB granularity.
So we would have lots of extents per inode and it could lead to overhead
to manage extents.

Anyway, mount option could be alternative for this patch.

On Fri, Dec 19, 2014 at 06:49:29PM +0800, Chao Yu wrote:
> Now f2fs have page-block mapping cache which can cache only one extent mapping
> between contiguous logical address and physical address.
> Normally, this design will work well because f2fs will expand coverage area of
> the mapping extent when we write forward sequentially. But when we write data
> randomly in Out-Place-Update mode, the extent will be shorten and hardly be
> expanded for most time as following reasons:
> 1.The short part of extent will be discarded if we break contiguous mapping in
> the middle of extent.
> 2.The new mapping will be added into mapping cache only at head or tail of the
> extent.
> 3.We will drop the extent cache when the extent became very fragmented.
> 4.We will not update the extent with mapping which we get from readpages or
> readpage.
> 
> To solve above problems, this patch adds extent cache base on rb-tree like other
> filesystems (e.g.: ext4/btrfs) in f2fs. By this way, f2fs can support another
> more effective cache between dnode page cache and disk. It will supply high hit
> ratio in the cache with fewer memory when dnode page cache are reclaimed in
> environment of low memory.
> 
> Todo:
> *introduce mount option for extent cache.
> *add shrink ability for extent cache.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/data.c  | 348 +++++++++++++++++++++++++++++++++++++++++---------------
>  fs/f2fs/debug.c |   2 +
>  fs/f2fs/f2fs.h  |  49 ++++----
>  fs/f2fs/inode.c |   5 +-
>  fs/f2fs/super.c |  11 +-
>  5 files changed, 291 insertions(+), 124 deletions(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 7ec697b..20592e2 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -24,6 +24,8 @@
>  #include "segment.h"
>  #include <trace/events/f2fs.h>
>  
> +struct kmem_cache *extent_info_cache;
> +
>  static void f2fs_read_end_io(struct bio *bio, int err)
>  {
>  	struct bio_vec *bvec;
> @@ -247,126 +249,264 @@ int f2fs_reserve_block(struct dnode_of_data *dn, pgoff_t index)
>  	return err;
>  }
>  
> -static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
> -					struct buffer_head *bh_result)
> +static struct extent_info *__insert_extent_cache(struct inode *inode,
> +				unsigned int fofs, unsigned int len, u32 blk)
>  {
> -	struct f2fs_inode_info *fi = F2FS_I(inode);
> -	pgoff_t start_fofs, end_fofs;
> -	block_t start_blkaddr;
> -
> -	if (is_inode_flag_set(fi, FI_NO_EXTENT))
> -		return 0;
> -
> -	read_lock(&fi->ext.ext_lock);
> -	if (fi->ext.len == 0) {
> -		read_unlock(&fi->ext.ext_lock);
> -		return 0;
> +	struct rb_root *root = &F2FS_I(inode)->ei_tree.root;
> +	struct rb_node *p = root->rb_node;
> +	struct rb_node *parent = NULL;
> +	struct extent_info *ei;
> +
> +	while (p) {
> +		parent = p;
> +		ei = rb_entry(parent, struct extent_info, rb_node);
> +
> +		if (fofs < ei->fofs)
> +			p = p->rb_left;
> +		else if (fofs >= ei->fofs + ei->len)
> +			p = p->rb_right;
> +		else
> +			f2fs_bug_on(F2FS_I_SB(inode), 1);
>  	}
>  
> -	stat_inc_total_hit(inode->i_sb);
> +	ei = kmem_cache_alloc(extent_info_cache, GFP_ATOMIC);
> +	ei->fofs = fofs;
> +	ei->blk = blk;
> +	ei->len = len;
> +
> +	rb_link_node(&ei->rb_node, parent, &p);
> +	rb_insert_color(&ei->rb_node, root);
> +	stat_inc_extent_count(inode->i_sb);
> +	return ei;
> +}
>  
> -	start_fofs = fi->ext.fofs;
> -	end_fofs = fi->ext.fofs + fi->ext.len - 1;
> -	start_blkaddr = fi->ext.blk_addr;
> +static bool __remove_extent_cache(struct inode *inode, unsigned int fofs,
> +							struct extent_info *cei)
> +{
> +	struct rb_root *root = &F2FS_I(inode)->ei_tree.root;
> +	struct rb_node *p = root->rb_node;
> +	struct extent_info *ei;
>  
> -	if (pgofs >= start_fofs && pgofs <= end_fofs) {
> -		unsigned int blkbits = inode->i_sb->s_blocksize_bits;
> -		size_t count;
> +	while (p) {
> +		ei = rb_entry(p, struct extent_info, rb_node);
>  
> -		clear_buffer_new(bh_result);
> -		map_bh(bh_result, inode->i_sb,
> -				start_blkaddr + pgofs - start_fofs);
> -		count = end_fofs - pgofs + 1;
> -		if (count < (UINT_MAX >> blkbits))
> -			bh_result->b_size = (count << blkbits);
> +		if (fofs < ei->fofs)
> +			p = p->rb_left;
> +		else if (fofs >= ei->fofs + ei->len)
> +			p = p->rb_right;
>  		else
> -			bh_result->b_size = UINT_MAX;
> +			goto found;
> +	}
> +	return true;
> +found:
> +	ei = rb_entry(p, struct extent_info, rb_node);
> +	cei->fofs = ei->fofs;
> +	cei->blk = ei->blk;
> +	cei->len = ei->len;
> +	rb_erase(&ei->rb_node, root);
> +	kmem_cache_free(extent_info_cache, ei);
> +	stat_dec_extent_count(inode->i_sb);
> +	return false;
> +}
>  
> -		stat_inc_read_hit(inode->i_sb);
> -		read_unlock(&fi->ext.ext_lock);
> -		return 1;
> +static void __try_merge_extent(struct inode *inode, struct extent_info *ei)
> +{
> +	struct rb_root *root = &F2FS_I(inode)->ei_tree.root;
> +	struct extent_info *pei = NULL;
> +	struct rb_node *node;
> +
> +	node = rb_prev(&ei->rb_node);
> +	if (node) {
> +		pei = rb_entry(node, struct extent_info, rb_node);
> +		if (ei->blk == pei->blk + pei->len) {

Shouldn't we check below together, too?
if (ei->fofs == pei->fofs + pei->len)

> +			ei->fofs = pei->fofs;
> +			ei->blk = pei->blk;
> +			ei->len += pei->len;
> +			rb_erase(&pei->rb_node, root);
> +			kmem_cache_free(extent_info_cache, pei);
> +			stat_dec_extent_count(inode->i_sb);
> +		}
> +	}
> +
> +	node = rb_next(&ei->rb_node);
> +	if (node) {
> +		pei = rb_entry(node, struct extent_info, rb_node);
> +		if (ei->blk + 1 == pei->blk) {
> +			ei->len += pei->len;
> +			rb_erase(&pei->rb_node, root);
> +			kmem_cache_free(extent_info_cache, pei);
> +			stat_dec_extent_count(inode->i_sb);
> +		}
>  	}
> -	read_unlock(&fi->ext.ext_lock);
> -	return 0;
>  }
>  
> -void update_extent_cache(block_t blk_addr, struct dnode_of_data *dn)
> +inline void get_extent_info(struct inode *inode, struct f2fs_extent *i_ext)
>  {
> -	struct f2fs_inode_info *fi = F2FS_I(dn->inode);
> -	pgoff_t fofs, start_fofs, end_fofs;
> -	block_t start_blkaddr, end_blkaddr;
> -	int need_update = true;
> +	struct f2fs_ei_tree *tree = &F2FS_I(inode)->ei_tree;
> +	struct extent_info *ei;
> +
> +	write_lock(&tree->ei_lock);
> +	ei = __insert_extent_cache(inode, le32_to_cpu(i_ext->fofs),
> +			le32_to_cpu(i_ext->len), le32_to_cpu(i_ext->blk_addr));
> +	tree->cached_ei = ei;
> +	write_unlock(&tree->ei_lock);
> +}
>  
> -	f2fs_bug_on(F2FS_I_SB(dn->inode), blk_addr == NEW_ADDR);
> -	fofs = start_bidx_of_node(ofs_of_node(dn->node_page), fi) +
> -							dn->ofs_in_node;
> +inline void set_raw_extent(struct f2fs_ei_tree *tree,
> +					struct f2fs_extent *i_ext)
> +{
> +	struct extent_info *ei = tree->cached_ei;
>  
> -	/* Update the page address in the parent node */
> -	__set_data_blkaddr(dn, blk_addr);
> +	read_lock(&tree->ei_lock);
> +	if (ei) {
> +		i_ext->fofs = cpu_to_le32(ei->fofs);
> +		i_ext->blk_addr = cpu_to_le32(ei->blk);
> +		i_ext->len = cpu_to_le32(ei->len);
> +	}
> +	read_unlock(&tree->ei_lock);
> +}
>  
> -	if (is_inode_flag_set(fi, FI_NO_EXTENT))
> -		return;
> +bool f2fs_lookup_extent_cache(struct inode *inode, pgoff_t pgofs,
> +							struct extent_info *ei)
> +{
> +	struct f2fs_ei_tree *tree = &F2FS_I(inode)->ei_tree;
> +	struct rb_node *node;
> +	struct extent_info *pei;
>  
> -	write_lock(&fi->ext.ext_lock);
> +	if (is_inode_flag_set(F2FS_I(inode), FI_NO_EXTENT))
> +		return false;
>  
> -	start_fofs = fi->ext.fofs;
> -	end_fofs = fi->ext.fofs + fi->ext.len - 1;
> -	start_blkaddr = fi->ext.blk_addr;
> -	end_blkaddr = fi->ext.blk_addr + fi->ext.len - 1;
> +	read_lock(&tree->ei_lock);
>  
> -	/* Drop and initialize the matched extent */
> -	if (fi->ext.len == 1 && fofs == start_fofs)
> -		fi->ext.len = 0;
> +	stat_inc_total_hit(inode->i_sb);
>  
> -	/* Initial extent */
> -	if (fi->ext.len == 0) {
> -		if (blk_addr != NULL_ADDR) {
> -			fi->ext.fofs = fofs;
> -			fi->ext.blk_addr = blk_addr;
> -			fi->ext.len = 1;
> -		}
> -		goto end_update;
> +	/* #1: find recently accessed extent info firstly */
> +	if (tree->cached_ei) {
> +		pei = tree->cached_ei;
> +		if (pgofs >= pei->fofs && pgofs < pei->fofs + pei->len)
> +			goto found;
>  	}
>  
> -	/* Front merge */
> -	if (fofs == start_fofs - 1 && blk_addr == start_blkaddr - 1) {
> -		fi->ext.fofs--;
> -		fi->ext.blk_addr--;
> -		fi->ext.len++;
> -		goto end_update;
> +	/* #2: find in rb tree */
> +	node = tree->root.rb_node;
> +	while (node) {
> +		pei = rb_entry(node, struct extent_info, rb_node);
> +		if (pgofs < pei->fofs)
> +			node = node->rb_left;
> +		else if (pgofs >= pei->fofs + pei->len)
> +			node = node->rb_right;
> +		else
> +			goto found;
>  	}
>  
> -	/* Back merge */
> -	if (fofs == end_fofs + 1 && blk_addr == end_blkaddr + 1) {
> -		fi->ext.len++;
> -		goto end_update;
> -	}
> +	read_unlock(&tree->ei_lock);
> +	return false;
> +found:
> +	ei->fofs = pei->fofs;
> +	ei->blk = pei->blk;
> +	ei->len = pei->len;
> +	stat_inc_read_hit(inode->i_sb);
> +	read_unlock(&tree->ei_lock);
> +	return true;
> +}
>  
> -	/* Split the existing extent */
> -	if (fi->ext.len > 1 &&
> -		fofs >= start_fofs && fofs <= end_fofs) {
> -		if ((end_fofs - fofs) < (fi->ext.len >> 1)) {
> -			fi->ext.len = fofs - start_fofs;
> -		} else {
> -			fi->ext.fofs = fofs + 1;
> -			fi->ext.blk_addr = start_blkaddr +
> -					fofs - start_fofs + 1;
> -			fi->ext.len -= fofs - start_fofs + 1;
> -		}
> -	} else {
> -		need_update = false;
> +void f2fs_update_extent_cache(struct inode *inode, pgoff_t fofs,
> +							block_t blk_addr)
> +{
> +	struct f2fs_ei_tree *tree = &F2FS_I(inode)->ei_tree;
> +	struct extent_info ei;
> +	struct extent_info *pei = NULL;
> +	unsigned int endofs;
> +
> +	if (is_inode_flag_set(F2FS_I(inode), FI_NO_EXTENT))
> +		return;
> +
> +	if (blk_addr == NEW_ADDR)
> +		return;
> +
> +	write_lock(&tree->ei_lock);
> +
> +	/* update old extent mapping */
> +	if (__remove_extent_cache(inode, fofs, &ei))
> +		goto add_extent;
> +	if (ei.len == 1)
> +		goto add_extent;
> +
> +	if (ei.fofs < fofs)
> +		__insert_extent_cache(inode, ei.fofs, fofs - ei.fofs, ei.blk);
> +
> +	endofs = ei.fofs + ei.len - 1;
> +	if (endofs > fofs)
> +		__insert_extent_cache(inode, fofs + 1, endofs - fofs,
> +						fofs - ei.fofs + ei.blk);
> +
> +add_extent:
> +	/* insert new mapping extent to rb tree */
> +	if (blk_addr) {
> +		pei = __insert_extent_cache(inode, fofs, 1, blk_addr);
> +		__try_merge_extent(inode, pei);
>  	}
>  
> -	/* Finally, if the extent is very fragmented, let's drop the cache. */
> -	if (fi->ext.len < F2FS_MIN_EXTENT_LEN) {
> -		fi->ext.len = 0;
> -		set_inode_flag(fi, FI_NO_EXTENT);
> -		need_update = true;
> +	if (pei)
> +		tree->cached_ei = pei;
> +
> +	write_unlock(&tree->ei_lock);
> +}
> +
> +void f2fs_free_extent_cache(struct inode *inode)
> +{
> +	struct f2fs_ei_tree *tree = &F2FS_I(inode)->ei_tree;
> +	struct rb_node *node, *next;
> +	struct extent_info *ei;
> +
> +	write_lock(&tree->ei_lock);
> +	node = rb_first(&tree->root);
> +	while (node) {
> +		next = rb_next(node);
> +		ei = rb_entry(node, struct extent_info, rb_node);
> +		rb_erase(node, &tree->root);
> +		kmem_cache_free(extent_info_cache, ei);
> +		stat_dec_extent_count(inode->i_sb);
> +		node = next;
>  	}
> -end_update:
> -	write_unlock(&fi->ext.ext_lock);
> -	if (need_update)
> -		sync_inode_page(dn);
> +	write_unlock(&tree->ei_lock);
> +}
> +
> +static void f2fs_map_bh(struct inode *inode, pgoff_t pgofs,
> +			struct extent_info *ei, struct buffer_head *bh_result)
> +{
> +	unsigned int blkbits = inode->i_sb->s_blocksize_bits;
> +	pgoff_t start_fofs, end_fofs;
> +	block_t start_blkaddr;
> +	size_t count;
> +
> +	start_fofs = ei->fofs;
> +	end_fofs = ei->fofs + ei->len - 1;
> +	start_blkaddr = ei->blk;
> +
> +	clear_buffer_new(bh_result);
> +	map_bh(bh_result, inode->i_sb,
> +			start_blkaddr + pgofs - start_fofs);
> +	count = end_fofs - pgofs + 1;
> +	if (count < (UINT_MAX >> blkbits))
> +		bh_result->b_size = (count << blkbits);
> +	else
> +		bh_result->b_size = UINT_MAX;
> +}
> +
> +void update_extent_cache(block_t blk_addr, struct dnode_of_data *dn)
> +{
> +	struct f2fs_inode_info *fi = F2FS_I(dn->inode);
> +	pgoff_t fofs;
> +
> +	f2fs_bug_on(F2FS_I_SB(dn->inode), blk_addr == NEW_ADDR);
> +	fofs = start_bidx_of_node(ofs_of_node(dn->node_page), fi) +
> +							dn->ofs_in_node;
> +
> +	/* Update the page address in the parent node */
> +	__set_data_blkaddr(dn, blk_addr);
> +
> +	f2fs_update_extent_cache(dn->inode, fofs, blk_addr);
>  	return;
>  }
>  
> @@ -603,12 +743,15 @@ static int __get_data_block(struct inode *inode, sector_t iblock,
>  	pgoff_t pgofs, end_offset;
>  	int err = 0, ofs = 1;
>  	bool allocated = false;
> +	struct extent_info ei;
>  
>  	/* Get the page offset from the block offset(iblock) */
>  	pgofs =	(pgoff_t)(iblock >> (PAGE_CACHE_SHIFT - blkbits));
>  
> -	if (check_extent_cache(inode, pgofs, bh_result))
> +	if (f2fs_lookup_extent_cache(inode, pgofs, &ei)) {
> +		f2fs_map_bh(inode, pgofs, &ei, bh_result);
>  		goto out;
> +	}
>  
>  	if (create) {
>  		f2fs_balance_fs(F2FS_I_SB(inode));
> @@ -628,6 +771,7 @@ static int __get_data_block(struct inode *inode, sector_t iblock,
>  
>  	if (dn.data_blkaddr != NULL_ADDR) {
>  		map_bh(bh_result, inode->i_sb, dn.data_blkaddr);
> +		f2fs_update_extent_cache(inode, pgofs, dn.data_blkaddr);
>  	} else if (create) {
>  		err = __allocate_data_block(&dn);
>  		if (err)
> @@ -672,6 +816,8 @@ get_next:
>  			allocated = true;
>  			blkaddr = dn.data_blkaddr;
>  		}
> +		if (!allocated)
> +			f2fs_update_extent_cache(inode, pgofs, blkaddr);
>  		/* Give more consecutive addresses for the readahead */
>  		if (blkaddr == (bh_result->b_blocknr + ofs)) {
>  			ofs++;
> @@ -1160,6 +1306,20 @@ static sector_t f2fs_bmap(struct address_space *mapping, sector_t block)
>  	return generic_block_bmap(mapping, block, get_data_block);
>  }
>  
> +int __init create_extent_cache(void)
> +{
> +	extent_info_cache = f2fs_kmem_cache_create("f2fs_extent_info_cache",
> +			sizeof(struct extent_info));
> +	if (!extent_info_cache)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +void destroy_extent_cache(void)
> +{
> +	kmem_cache_destroy(extent_info_cache);
> +}
> +
>  const struct address_space_operations f2fs_dblock_aops = {
>  	.readpage	= f2fs_read_data_page,
>  	.readpages	= f2fs_read_data_pages,
> diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
> index 91e8f69..115cec0 100644
> --- a/fs/f2fs/debug.c
> +++ b/fs/f2fs/debug.c
> @@ -35,6 +35,7 @@ static void update_general_status(struct f2fs_sb_info *sbi)
>  	/* validation check of the segment numbers */
>  	si->hit_ext = sbi->read_hit_ext;
>  	si->total_ext = sbi->total_hit_ext;
> +	si->ext_count = sbi->total_ext_count;
>  	si->ndirty_node = get_pages(sbi, F2FS_DIRTY_NODES);
>  	si->ndirty_dent = get_pages(sbi, F2FS_DIRTY_DENTS);
>  	si->ndirty_dirs = sbi->n_dirty_dirs;
> @@ -249,6 +250,7 @@ static int stat_show(struct seq_file *s, void *v)
>  		seq_printf(s, "  - node blocks : %d\n", si->node_blks);
>  		seq_printf(s, "\nExtent Hit Ratio: %d / %d\n",
>  			   si->hit_ext, si->total_ext);
> +		seq_printf(s, "\nExtent Node Count: %d\n", si->ext_count);
>  		seq_puts(s, "\nBalancing F2FS Async:\n");
>  		seq_printf(s, "  - inmem: %4d\n",
>  			   si->inmem_pages);
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index ec58bb2..dab6fdb 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -263,10 +263,16 @@ enum {
>  #define F2FS_MIN_EXTENT_LEN	16	/* minimum extent length */
>  
>  struct extent_info {
> -	rwlock_t ext_lock;	/* rwlock for consistency */
> -	unsigned int fofs;	/* start offset in a file */
> -	u32 blk_addr;		/* start block address of the extent */
> -	unsigned int len;	/* length of the extent */
> +	struct rb_node rb_node;		/* rb node located in rb-tree */
> +	unsigned int fofs;		/* start offset in a file */
> +	u32 blk;			/* start block address of the extent */
> +	unsigned int len;		/* length of the extent */
> +};
> +
> +struct f2fs_ei_tree {
> +	struct rb_root root;		/* root of extent info rb-tree */
> +	struct extent_info *cached_ei;	/* recently accessed extent */
> +	rwlock_t ei_lock;		/* rwlock for consistency */
>  };
>  
>  /*
> @@ -294,7 +300,8 @@ struct f2fs_inode_info {
>  	unsigned int clevel;		/* maximum level of given file name */
>  	nid_t i_xattr_nid;		/* node id that contains xattrs */
>  	unsigned long long xattr_ver;	/* cp version of xattr modification */
> -	struct extent_info ext;		/* in-memory extent cache entry */
> +	struct extent_info ext;
> +	struct f2fs_ei_tree ei_tree;	/* in-memory extent cache entry */
>  	struct dir_inode_entry *dirty_dir;	/* the pointer of dirty dir */
>  
>  	struct radix_tree_root inmem_root;	/* radix tree for inmem pages */
> @@ -302,26 +309,6 @@ struct f2fs_inode_info {
>  	struct mutex inmem_lock;	/* lock for inmemory pages */
>  };
>  
> -static inline void get_extent_info(struct extent_info *ext,
> -					struct f2fs_extent i_ext)
> -{
> -	write_lock(&ext->ext_lock);
> -	ext->fofs = le32_to_cpu(i_ext.fofs);
> -	ext->blk_addr = le32_to_cpu(i_ext.blk_addr);
> -	ext->len = le32_to_cpu(i_ext.len);
> -	write_unlock(&ext->ext_lock);
> -}
> -
> -static inline void set_raw_extent(struct extent_info *ext,
> -					struct f2fs_extent *i_ext)
> -{
> -	read_lock(&ext->ext_lock);
> -	i_ext->fofs = cpu_to_le32(ext->fofs);
> -	i_ext->blk_addr = cpu_to_le32(ext->blk_addr);
> -	i_ext->len = cpu_to_le32(ext->len);
> -	read_unlock(&ext->ext_lock);
> -}
> -
>  struct f2fs_nm_info {
>  	block_t nat_blkaddr;		/* base disk address of NAT */
>  	nid_t max_nid;			/* maximum possible node ids */
> @@ -590,6 +577,7 @@ struct f2fs_sb_info {
>  	unsigned int segment_count[2];		/* # of allocated segments */
>  	unsigned int block_count[2];		/* # of allocated blocks */
>  	int total_hit_ext, read_hit_ext;	/* extent cache hit ratio */
> +	int total_ext_count;                    /* extent cache node count */
>  	atomic_t inline_inode;			/* # of inline_data inodes */
>  	atomic_t inline_dir;			/* # of inline_dentry inodes */
>  	int bg_gc;				/* background gc calls */
> @@ -1462,12 +1450,17 @@ void f2fs_submit_page_mbio(struct f2fs_sb_info *, struct page *, block_t,
>  						struct f2fs_io_info *);
>  int reserve_new_block(struct dnode_of_data *);
>  int f2fs_reserve_block(struct dnode_of_data *, pgoff_t);
> +void set_raw_extent(struct f2fs_ei_tree *, struct f2fs_extent *);
> +void get_extent_info(struct inode *, struct f2fs_extent *);
> +void f2fs_free_extent_cache(struct inode *);
>  void update_extent_cache(block_t, struct dnode_of_data *);
>  struct page *find_data_page(struct inode *, pgoff_t, bool);
>  struct page *get_lock_data_page(struct inode *, pgoff_t);
>  struct page *get_new_data_page(struct inode *, struct page *, pgoff_t, bool);
>  int do_write_data_page(struct page *, struct f2fs_io_info *);
>  int f2fs_fiemap(struct inode *inode, struct fiemap_extent_info *, u64, u64);
> +int __init create_extent_cache(void);
> +void destroy_extent_cache(void);
>  
>  /*
>   * gc.c
> @@ -1495,7 +1488,7 @@ struct f2fs_stat_info {
>  	struct f2fs_sb_info *sbi;
>  	int all_area_segs, sit_area_segs, nat_area_segs, ssa_area_segs;
>  	int main_area_segs, main_area_sections, main_area_zones;
> -	int hit_ext, total_ext;
> +	int hit_ext, total_ext, ext_count;
>  	int ndirty_node, ndirty_dent, ndirty_dirs, ndirty_meta;
>  	int nats, sits, fnids;
>  	int total_count, utilization;
> @@ -1529,6 +1522,8 @@ static inline struct f2fs_stat_info *F2FS_STAT(struct f2fs_sb_info *sbi)
>  #define stat_dec_dirty_dir(sbi)		((sbi)->n_dirty_dirs--)
>  #define stat_inc_total_hit(sb)		((F2FS_SB(sb))->total_hit_ext++)
>  #define stat_inc_read_hit(sb)		((F2FS_SB(sb))->read_hit_ext++)
> +#define stat_inc_extent_count(sb)	((F2FS_SB(sb))->total_ext_count++)
> +#define stat_dec_extent_count(sb)	((F2FS_SB(sb))->total_ext_count--)
>  #define stat_inc_inline_inode(inode)					\
>  	do {								\
>  		if (f2fs_has_inline_data(inode))			\
> @@ -1593,6 +1588,8 @@ void f2fs_destroy_root_stats(void);
>  #define stat_dec_dirty_dir(sbi)
>  #define stat_inc_total_hit(sb)
>  #define stat_inc_read_hit(sb)
> +#define stat_inc_extent_count(sb)
> +#define stat_dec_extent_count(sb)
>  #define stat_inc_inline_inode(inode)
>  #define stat_dec_inline_inode(inode)
>  #define stat_inc_inline_dir(inode)
> diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
> index 196cc78..ae0dd9b 100644
> --- a/fs/f2fs/inode.c
> +++ b/fs/f2fs/inode.c
> @@ -137,7 +137,7 @@ static int do_read_inode(struct inode *inode)
>  	fi->i_pino = le32_to_cpu(ri->i_pino);
>  	fi->i_dir_level = ri->i_dir_level;
>  
> -	get_extent_info(&fi->ext, ri->i_ext);
> +	get_extent_info(inode, &ri->i_ext);
>  	get_inline_info(fi, ri);
>  
>  	/* check data exist */
> @@ -227,7 +227,7 @@ void update_inode(struct inode *inode, struct page *node_page)
>  	ri->i_links = cpu_to_le32(inode->i_nlink);
>  	ri->i_size = cpu_to_le64(i_size_read(inode));
>  	ri->i_blocks = cpu_to_le64(inode->i_blocks);
> -	set_raw_extent(&F2FS_I(inode)->ext, &ri->i_ext);
> +	set_raw_extent(&F2FS_I(inode)->ei_tree, &ri->i_ext);
>  	set_raw_inline(F2FS_I(inode), ri);
>  
>  	ri->i_atime = cpu_to_le64(inode->i_atime.tv_sec);
> @@ -335,6 +335,7 @@ void f2fs_evict_inode(struct inode *inode)
>  no_delete:
>  	stat_dec_inline_dir(inode);
>  	stat_dec_inline_inode(inode);
> +	f2fs_free_extent_cache(inode);
>  	invalidate_mapping_pages(NODE_MAPPING(sbi), inode->i_ino, inode->i_ino);
>  	if (xnid)
>  		invalidate_mapping_pages(NODE_MAPPING(sbi), xnid, xnid);
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index f71421d..f205493 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -381,7 +381,9 @@ static struct inode *f2fs_alloc_inode(struct super_block *sb)
>  	atomic_set(&fi->dirty_pages, 0);
>  	fi->i_current_depth = 1;
>  	fi->i_advise = 0;
> -	rwlock_init(&fi->ext.ext_lock);
> +	fi->ei_tree.root = RB_ROOT;
> +	fi->ei_tree.cached_ei = NULL;
> +	rwlock_init(&fi->ei_tree.ei_lock);
>  	init_rwsem(&fi->i_sem);
>  	INIT_RADIX_TREE(&fi->inmem_root, GFP_NOFS);
>  	INIT_LIST_HEAD(&fi->inmem_pages);
> @@ -1235,10 +1237,13 @@ static int __init init_f2fs_fs(void)
>  	err = create_checkpoint_caches();
>  	if (err)
>  		goto free_gc_caches;
> +	err = create_extent_cache();
> +	if (err)
> +		goto free_checkpoint_caches;
>  	f2fs_kset = kset_create_and_add("f2fs", NULL, fs_kobj);
>  	if (!f2fs_kset) {
>  		err = -ENOMEM;
> -		goto free_checkpoint_caches;
> +		goto free_extent_cache;
>  	}
>  	err = register_filesystem(&f2fs_fs_type);
>  	if (err)
> @@ -1249,6 +1254,8 @@ static int __init init_f2fs_fs(void)
>  
>  free_kset:
>  	kset_unregister(f2fs_kset);
> +free_extent_cache:
> +	destroy_extent_cache();
>  free_checkpoint_caches:
>  	destroy_checkpoint_caches();
>  free_gc_caches:
> -- 
> 2.1.2
> 
