Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbaELJmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:42:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26803 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbaELJmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:42:39 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-5d-5370978dcb62
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Brian Foster'" <bfoster@redhat.com>
Cc: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>,
        linux-fsdevel@vger.kernel.org,
        "'linux-ext4'" <linux-ext4@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>, xfs@oss.sgi.com
References: <003801cf6aa7$f1f87b70$d5e97250$@samsung.com>
 <20140509152440.GA32489@laptop.bfoster>
In-reply-to: <20140509152440.GA32489@laptop.bfoster>
Subject: RE: [PATCH v2 2/10] xfs: Add support FALLOC_FL_INSERT_RANGE for
 fallocate
Date: Mon, 12 May 2014 18:42:37 +0900
Message-id: <005601cf6dc6$82573820$8705a860$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQI8l/c+50jbPyrOUhhBFU208NvpTgGlw03dmlUskyA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsWyRsSkRLd3ekGwway/hhZLJ15itnj3ucpi
	y7F7jBYz591hs9iz9ySLxeVdc9gsWnt+slss6rvF6MDhcWqRhEfTmaPMHqsvbGX0eL/vKptH
	35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZRzY8py54Kdpxe8DB9gbGCdodDFycEgImEjsW5LY
	xcgJZIpJXLi3nq2LkYtDSGApo0TXxg3sMDXPz0pAxKczSsx+9IEFwvnLKHH30042kCI2AW2J
	P1tEQQaJCKhL3Jk3AayGWeATo8T6A5NYQGqEBJIltq/LBqnhBJr5deUcJhBbWCBEYs3D+2wg
	NouAqsS9q+2MIDavgKVE87ObrBC2oMSPyfdYQGxmAS2J9TuPM0HY8hKb17xlhnhAQWLH2deM
	EDdYSexbM4cZokZEYt+Ld4wg90gI/GWX2DT7MCPEMgGJb5MPsUA8KSux6QDUHEmJgytusExg
	lJiFZPUsJKtnIVk9C8mKBYwsqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzECY/n0v2f9Oxjv
	HrA+xJgMtH4is5Rocj4wFeSVxBsamxlZmJqYGhuZW5qRJqwkznv/YVKQkEB6YklqdmpqQWpR
	fFFpTmrxIUYmDk6pBkafnewLeXOkXV149bIvZ0WLbFl0/Pl1G/2OxvqtXspTCuT/WX6f7J6m
	IKZ40fgVo6Q2b+h9gR2eS+/sblwvtajs4sV9L0Qvd8Wd8zMs2Zf4/foU6WPnpp2c9H678+nf
	03bJzElcfCmhZOplwTVhD7e9dji7Z4N0OuvHfd+0XnzcfOFD8CEm9wAxJZbijERDLeai4kQA
	z/e8PvsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsVy+t9jQd3e6QXBBr3zNS2WTrzEbPHuc5XF
	lmP3GC1mzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	vi2rGD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hxYMtz5oKf
	phW/Dxxgb2CcoNHFyMEhIWAi8fysRBcjJ5ApJnHh3nq2LkYuDiGB6YwSsx99YIFw/jJK3P20
	kw2kgU1AW+LPFlGQBhEBdYk78yaA1TALfGKUWH9gEgtIjZBAssT2ddkgNZxA87+unMMEYgsL
	hEiseXifDcRmEVCVuHe1nRHE5hWwlGh+dpMVwhaU+DH5HguIzSygJbF+53EmCFteYvOat8wQ
	hypI7Dj7mhHiBiuJfWvmMEPUiEjse/GOcQKj0Cwko2YhGTULyahZSFoWMLKsYhRNLUguKE5K
	zzXSK07MLS7NS9dLzs/dxAhOFc+kdzCuarA4xCjAwajEw/uBoSBYiDWxrLgy9xCjBAezkgjv
	yYlAId6UxMqq1KL8+KLSnNTiQ4zJQJ9OZJYSTc4HprG8knhDYxMzI0sjc0MLI2Nz0oSVxHkP
	tloHCgmkJ5akZqemFqQWwWxh4uCUamDkzuWttVlf+33n9zXCC+brL74SqpTVGWtUvSsy47ZZ
	vlygK9M0s8W1EnfEzKZsX9bk9PHyZOsde6ccPOM+uera9G9Fv5R/BvKEc5x2cZt2wO3Pz986
	ui+SVxj3VXfmCH0t2XOZcfo1E7WvCp90OWJVcxmLOk7pOoSsLJ2nzlF7guVqkqrI8kglluKM
	REMt5qLiRADkg6ChWQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +xfs_bmap_split_extent(
> > +	struct xfs_inode	*ip,
> > +	xfs_fileoff_t		split_fsb,
> > +	xfs_extnum_t		*split_ext)
> > +{
> > +	struct xfs_mount        *mp = ip->i_mount;
> > +	struct xfs_trans	*tp;
> > +	struct xfs_bmap_free	free_list;
> > +	xfs_fsblock_t		firstfsb;
> > +	int			committed;
> > +	int			error;
> > +
> > +	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
> > +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
> > +			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
> > +
> > +	if (error) {
> > +		/*
> > +		 * Free the transaction structure.
> > +		 */
> > +		ASSERT(XFS_FORCED_SHUTDOWN(mp));
> 
Hi, Brian.
> As in the other patch, we're attempting to reserve fs blocks for the
> transaction, so ENOSPC is a possibility that I think the assert should
> accommodate.
How about removing the ASSERT completely as suggessted by Dave
in other thread?

> 
> > +		xfs_trans_cancel(tp, 0);
> > +		return error;
> > +	}
> > +

> > +
> > +		/*
> > +		 * Before shifting extent into hole, make sure that the hole
> > +		 * is large enough to accomodate the shift. This checking has
> > +		 * to be performed for all except the last extent.
> > +		 */
> > +		last_extent = (ifp->if_bytes / sizeof(xfs_bmbt_rec_t)) - 1;
> > +		if (last_extent != *current_ext) {
> > +			xfs_bmbt_get_all(xfs_iext_get_ext(ifp,
> > +						*current_ext + 1), &right);
> > +			if (startoff + got.br_blockcount > right.br_startoff) {
> > +				error = XFS_ERROR(EINVAL);
> > +				if (error)
> > +					goto del_cursor;
> > +			}
> > +		}
> > +
> > +		/* Check if we can merge 2 adjacent extents */
> > +		if (last_extent != *current_ext &&
> > +		    right.br_startoff == startoff + got.br_blockcount &&
> > +		    right.br_startblock ==
> > +				got.br_startblock + got.br_blockcount &&
> > +		    right.br_state == got.br_state &&
> > +		    right.br_blockcount + got.br_blockcount <= MAXEXTLEN) {
> > +			blockcount = right.br_blockcount + got.br_blockcount;
> > +
> > +			/* Make cursor point to the extent we will update */
> 
> The comment could be more clear about what we're doing in this case. For
> example:
> 
> /*
>  * Merge the current extent with the extent to the right. Remove the right
>  * extent, calculate a new block count for the current extent to cover the range
>  * of both and decrement the number of extents in the fork.
>  */
> 
> I'd also move the comment before the blockcount calculation.
okay, I will add it as your suggestion.
> 
> > +			if (cur) {
> > +				error = xfs_bmbt_lookup_eq(cur,
> > +							   right.br_startoff,
> > +							   right.br_startblock,
> > +							   right.br_blockcount,
> > +							   &i);
> > +				if (error)
> > +					goto del_cursor;
> > +				XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
> > +			}
> > +
> > +			xfs_iext_remove(ip, *current_ext + 1, 1, 0);
> > +			if (cur) {
> > +				error = xfs_btree_delete(cur, &i);
> > +				if (error)
> > +					goto del_cursor;
> > +				XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
> > +			}
> > +			XFS_IFORK_NEXT_SET(ip, whichfork,
> > +					XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
> > +
> > +		}
> > +
> > +		if (cur) {
> > +			error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
> > +						   got.br_startblock,
> > +						   got.br_blockcount,
> > +						   &i);
> > +			if (error)
> > +				goto del_cursor;
> > +			XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
> > +		}
> > +
> > +		if (got.br_blockcount < blockcount) {
> > +			xfs_bmbt_set_blockcount(gotp, blockcount);
> > +			got.br_blockcount = blockcount;
> > +		}
> 
> How about just 'if (blockcount)' so the algorithm is clear?
yes, more clear.
> 
> > +
> > +
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 97855c5..392b029 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -760,7 +760,8 @@ xfs_file_fallocate(
> >  	if (!S_ISREG(inode->i_mode))
> >  		return -EINVAL;
> >  	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
> > -		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
> > +		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
> > +		     FALLOC_FL_INSERT_RANGE))
> >  		return -EOPNOTSUPP;
> >
> >  	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> > @@ -790,6 +791,40 @@ xfs_file_fallocate(
> >  		error = xfs_collapse_file_space(ip, offset, len);
> >  		if (error)
> >  			goto out_unlock;
> > +	} else if (mode & FALLOC_FL_INSERT_RANGE) {
> > +		unsigned blksize_mask = (1 << inode->i_blkbits) - 1;
> > +		struct iattr iattr;
> > +
> > +		if (offset & blksize_mask || len & blksize_mask) {
> > +			error = -EINVAL;
> > +			goto out_unlock;
> > +		}
> > +
> > +		/* Check for wrap through zero */
> > +		if (inode->i_size + len > inode->i_sb->s_maxbytes) {
> > +			error = -EFBIG;
> > +			goto out_unlock;
> > +		}
> > +
> > +		/* Offset should be less than i_size */
> > +		if (offset >= i_size_read(inode)) {
> > +			error = -EINVAL;
> > +			goto out_unlock;
> > +		}
> > +
> > +		/*
> > +		 * The first thing we do is to expand file to
> > +		 * avoid data loss if there is error while shifting
> > +		 */
> > +		iattr.ia_valid = ATTR_SIZE;
> > +		iattr.ia_size = i_size_read(inode) + len;
> > +		error = xfs_setattr_size(ip, &iattr);
> > +		if (error)
> > +			goto out_unlock;
> 
> I don't necessarily know that it's problematic to do the setattr before
> the bmap fixup. We'll have a chance for partial completion of this
> operation either way. But I'm not a fan of the code duplication here.
> This also still skips the time update in the event of insert space
> failure, though perhaps that's not such a big deal if we're returning an
> error.
> 
> I think it would be better to leave things organized as before and
> introduce an error2 variable and a &nrshifts or some such parameter to
> xfs_insert_file_space() that initializes to 0 and returns the number of
> record shifts. The caller can then decide whether it's appropriate to
> break out immediately or do the inode size update and return the error.
> 
> Perhaps not the cleanest thing in the world, but also not the first
> place we would use 'error2' to manage error priorities (grep around for
> it)...
Yes, Right. I also thought such sequence at first. But we should consider
sudden power off and unplug device case during shifting extent.
While we are in the middle of shifitng extents and if there is sudden
power failure user can still think that data is lost as we won't get any
chance to update the file size in these cases.
Updating file size before the shifitng operation can start will prevent this.

Thanks.
> 
> Brian
> 
> > +
> > +		error = xfs_insert_file_space(ip, offset, len);
> > +		if (error)
> > +			goto out_unlock;
> >  	} else {
> >  		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
> >  		    offset + len > i_size_read(inode)) {

