Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbbAGFqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 00:46:30 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:11152 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbbAGFq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 00:46:27 -0500
X-AuditID: cbfee68d-f79296d000004278-8c-54acc830fea5
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Brian Foster'" <bfoster@redhat.com>
Cc: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'linux-ext4'" <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>
References: <004001d02670$33d2f3c0$9b78db40$@samsung.com>
 <20150106163326.GF5874@bfoster.bfoster>
In-reply-to: <20150106163326.GF5874@bfoster.bfoster>
Subject: RE: [PATCH v7 2/11] xfs: Add support FALLOC_FL_INSERT_RANGE for
 fallocate
Date: Wed, 07 Jan 2015 14:46:24 +0900
Message-id: <001601d02a3d$459aaa00$d0cffe00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGESkTriDRlhjDJPxVyMllwKnynTAJYbCtInTjpXVA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsWyRsSkQNfgxJoQgxdLLCyWTrzEbPHuc5XF
	lmP3GC1mzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	vi2rGD0+b5ILYIvisklJzcksSy3St0vgyjhx5jlLwRHJivkX3jE1MG4X7mLk5JAQMJH4v+AF
	O4QtJnHh3nq2LkYuDiGBpYwS/05dYIUpOjR1DTNEYjqjxK7WD4wQzl9GiQXLepm6GDk42AS0
	Jf5sEQVpEBFQl7gzbwILSA2zwCdGiYdXDjCD1AgJJEv09qaB1HACDZ36+BgziC0sECLx/Usz
	C4jNIqAq0fpqLiOIzStgKbHvWQcLhC0o8WPyPTCbWUBLYv3O40wQtrzE5jVvmSEOVZDYcfY1
	I8QNVhLffnQwQtSISOx78Y4RouYnu8SrZxEQuwQkvk0+xAJymoSArMSmA1BjJCUOrrjBMoFR
	YhaSzbOQbJ6FZPMsJBsWMLKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAiM5tP/nvXuYLx9
	wPoQowAHoxIPb0HfmhAh1sSy4srcQ4ymQBdNZJYSTc4Hpoy8knhDYzMjC1MTU2Mjc0szJXFe
	RamfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYhVaqbMyvYTdZHZ9g9rDQsu/opRBl/vlT
	/z88s2rCzD0zN/HO6p2ge9aep/W0zTXOIycyGOrXaLyKKHm8Qlbz/45pjnluFlsKs3/LKmb4
	OxxZFR9w2oaBpWRH4+zL0a/YFjs9SVb1NX+xS8+b++/qqQdPZ17dlTw9VK2xoOZo2ZXtG7df
	5atPVWIpzkg01GIuKk4EAKVOxFrhAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jQV2DE2tCDF5/0bdYOvESs8W7z1UW
	W47dY7SYOe8Om8WevSdZLC7vmsNm0drzk91iUd8tRgcOj1OLJDyazhxl9lh9YSujx/t9V9k8
	+rasYvT4vEkugC2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+geJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGiTPPWQqO
	SFbMv/COqYFxu3AXIyeHhICJxKGpa5ghbDGJC/fWs3UxcnEICUxnlNjV+oERwvnLKLFgWS9T
	FyMHB5uAtsSfLaIgDSIC6hJ35k1gAalhFvjEKPHwygFmkBohgWSJ3t40kBpOoAVTHx8DWyAs
	ECLx/UszC4jNIqAq0fpqLiOIzStgKbHvWQcLhC0o8WPyPTCbWUBLYv3O40wQtrzE5jVvoQ5V
	kNhx9jUjxA1WEt9+dDBC1IhI7HvxjnECo9AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihOSs81
	0itOzC0uzUvXS87P3cQIThbPpHcwrmqwOMQowMGoxMNb0LcmRIg1say4MvcQowQHs5IIr1Un
	UIg3JbGyKrUoP76oNCe1+BCjKdCnE5mlRJPzgYksryTe0NjEzMjSyNzQwsjYXEmcV8m+LURI
	ID2xJDU7NbUgtQimj4mDU6qBcbJK4qrlM+/ksnP95f7Ndur4zbpHusJlfPNqyhZ901u77rf3
	83/LD4Wmi5/uV3t25dvhRFOFp35CW29+Zpwn/eTF7Y9vdK/Hll74ztV6kddqovkR8+MvF++L
	8RTZcOu64TO1n5M28efJKMs4x166VjvNKmj6x+sCqxkudX2WWZsZrjTLp+WyV7cSS3FGoqEW
	c1FxIgBCZEE3LAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Fri, Jan 02, 2015 at 06:40:54PM +0900, Namjae Jeon wrote:
> > This patch implements fallocate's FALLOC_FL_INSERT_RANGE for XFS.
> >
> > 1) Make sure that both offset and len are block size aligned.
> > 2) Update the i_size of inode by len bytes.
> > 3) Compute the file's logical block number against offset. If the computed
> >    block number is not the starting block of the extent, split the extent
> >    such that the block number is the starting block of the extent.
> > 4) Shift all the extents which are lying bewteen [offset, last allocated extent]
> >    towards right by len bytes. This step will make a hole of len bytes
> >    at offset.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > Cc: Brian Foster<bfoster@redhat.com>
> > ---
> 
> Hi Namjae,
Hi Brian,
> 
> Just a few small things...
> 

> > +	} else {
> > +		startoff = got.br_startoff + offset_shift_fsb;
> > +		/*
> > +		 * If this is not the last extent in the file, make sure there's
> > +		 * enough room between current extent and next extent for
> > +		 * accomodating the shift.
> 
> Spelling nit:	   accommodating
Okay, I will fix it.

> 
> > +		 */
> > +		if (*current_ext < (total_extents - 1)) {
> > +			contp = xfs_iext_get_ext(ifp, *current_ext + 1);
> > +			xfs_bmbt_get_all(contp, &cont);
> > +			if (startoff + got.br_blockcount > cont.br_startoff)
> > +				return -EINVAL;
> > +			if (xfs_bmse_can_merge(&got, &cont,  offset_shift_fsb))
> > +				WARN_ON_ONCE(1);
> 
> Ok, but a comment before the check would be nice should somebody have to
> look up the warning that fires here. E.g.,:
> 
> /*
>  * Unlike a left shift (which involves a hole punch), a right shift does
>  * not modify extent neighbors in any way. We should never find
>  * mergeable extents in this scenario. Check anyways and warn if we
>  * encounter two extents that could be one.
>  */
Okay, I will update it.

> > -	/*
> > -	 * There may be delalloc extents in the data fork before the range we
> > -	 * are collapsing out, so we cannot use the count of real extents here.
> > -	 * Instead we have to calculate it from the incore fork.
> > -	 */
> > -	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
> > -	while (nexts++ < num_exts && current_ext < total_extents) {
> > +	/* some sanity checking before we finally start shifting extents */
> > +	if ((SHIFT == SHIFT_LEFT && current_ext > stop_extent) ||
> > +	     (SHIFT == SHIFT_RIGHT && current_ext < stop_extent)) {
> > +		error = EIO;
> > +		goto del_cursor;
> > +	}
> 
> If stop_extent is consistently exclusive now, we probably need to use >=
> and <= here (e.g., 'stop_extent' should never be shifted).
You're Right. I will fix it.
> 
> > +

> > +del_cursor:
> > +	if (cur) {
> > +		cur->bc_private.b.allocated = 0;
> > +		xfs_btree_del_cursor(cur,
> > +				error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> > +	}
> > +	xfs_trans_log_inode(tp, ip, logflags);
> 
> 	if (logflags)
> 		xfs_trans_log_inode(tp, ip, logflags);
Okay.
> 
> Otherwise, the rest looks pretty good. I'll try to do some testing with
> it soon.
Thanks very much for your review!!
> 
> Brian
> 

