Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaEMBXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 21:23:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63135 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaEMBXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 21:23:05 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-60-537173f50f51
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Brian Foster'" <bfoster@redhat.com>
Cc: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>,
        linux-fsdevel@vger.kernel.org,
        "'linux-ext4'" <linux-ext4@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>, xfs@oss.sgi.com
References: <003801cf6aa7$f1f87b70$d5e97250$@samsung.com>
 <20140509152440.GA32489@laptop.bfoster>
 <005601cf6dc6$82573820$8705a860$@samsung.com>
 <20140512112541.GA62831@bfoster.bfoster>
In-reply-to: <20140512112541.GA62831@bfoster.bfoster>
Subject: RE: [PATCH v2 2/10] xfs: Add support FALLOC_FL_INSERT_RANGE for
 fallocate
Date: Tue, 13 May 2014 10:23:00 +0900
Message-id: <001a01cf6e49$e168e650$a43ab2f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQI8l/c+50jbPyrOUhhBFU208NvpTgGlw03dAgzqMasB2HRhxZo3CUIg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsWyRsSkWPdrcWGwweEFwhZLJ15itnj3ucpi
	y7F7jBYz591hs9iz9ySLxeVdc9gsWnt+slss6rvF6MDhcWqRhEfTmaPMHqsvbGX0eL/vKptH
	35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZdyccIq94K1hRfORnSwNjH9Uuhg5OSQETCS+3j7B
	CmGLSVy4t56ti5GLQ0hgKaPE7BW3WWCKzv7+xAZiCwlMZ5S4flEHougvo0Tn0olA3RwcbALa
	En+2iILUiAioS9yZN4EFpIZZ4BOjxPoDk1ggmvcxSkx4LwticwqYSpzZfBxsqLBAiMSah/fB
	bBYBVYlV1w8xgdi8ApYSa+5OYYewBSV+TL4HNodZQEti/c7jTBC2vMTmNW+ZIQ5VkNhx9jUj
	xBFuEvd+3maFqBGR2PfiHSPIQRICP9klzt28ygyxTEDi2+RDLCAPSAjISmw6ADVHUuLgihss
	ExglZiFZPQvJ6llIVs9CsmIBI8sqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjMB4Pv3v2YQd
	jPcOWB9iTAZaP5FZSjQ5H5gO8kriDY3NjCxMTUyNjcwtzUgTVhLnVXuUFCQkkJ5YkpqdmlqQ
	WhRfVJqTWnyIkYmDU6qBsSr6es7yB5MvbkgQTfv67Uci+8uqmZl+XL4TGbQaf51iVpgluu7D
	mVt7133KD99dZp2i/2JZScK8Y9uvXfJK0LixvvsYf62f54o1VXlmbdN7ToVKXOvbemDlc4EJ
	f7hXCkyvD/jocHWhX+0kl7ozTjIfXjDknnEO/XqlwYGBb9/hgN5thzd4L1ZiKc5INNRiLipO
	BAD4sfQ3/QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jQd2vxYXBBq0PuC2WTrzEbPHuc5XF
	lmP3GC1mzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	vi2rGD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hxc8Ip9oK3
	hhXNR3ayNDD+Ueli5OSQEDCROPv7ExuELSZx4d56MFtIYDqjxPWLOl2MXED2X0aJzqUTWbsY
	OTjYBLQl/mwRBakREVCXuDNvAgtIDbPAJ0aJ9QcmsUA072OUmPBeFsTmFDCVOLP5ONhQYYEQ
	iTUP74PZLAKqEquuH2ICsXkFLCXW3J3CDmELSvyYfA9sDrOAlsT6nceZIGx5ic1r3jJDHKog
	sePsa0aII9wk7v28zQpRIyKx78U7xgmMQrOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddQ
	rzgxt7g0L10vOT93EyM4WTyT2sG4ssHiEKMAB6MSD+9P48JgIdbEsuLK3EOMEhzMSiK8XUFA
	Id6UxMqq1KL8+KLSnNTiQ4zJQJ9OZJYSTc4HJrK8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtFoH
	CgmkJ5akZqemFqQWwWxh4uCUamBcHmTVsipWRPEe4zH+2dHHTz4LNg97xNxV6fR0WkT+vkMR
	Nl+m3TB89UJqZ4gUn4nvJV3vsyvvFdfXCgss/DIp8sji4/9bL4R/jvVQsji2aGvFvC3KAT+2
	f6h7O9Um/UtG2EaBKZF2uS1FWwTsL6ZelLHfn8q8tVXcO8AsW9yM4eGTMw+duw8psRRnJBpq
	MRcVJwIAKoAjWloDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Mon, May 12, 2014 at 06:42:37PM +0900, Namjae Jeon wrote:
> >
> > > > +xfs_bmap_split_extent(
> > > > +	struct xfs_inode	*ip,
> > > > +	xfs_fileoff_t		split_fsb,
> > > > +	xfs_extnum_t		*split_ext)
> > > > +{
> > > > +	struct xfs_mount        *mp = ip->i_mount;
> > > > +	struct xfs_trans	*tp;
> > > > +	struct xfs_bmap_free	free_list;
> > > > +	xfs_fsblock_t		firstfsb;
> > > > +	int			committed;
> > > > +	int			error;
> > > > +
> > > > +	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
> > > > +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
> > > > +			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
> > > > +
> > > > +	if (error) {
> > > > +		/*
> > > > +		 * Free the transaction structure.
> > > > +		 */
> > > > +		ASSERT(XFS_FORCED_SHUTDOWN(mp));
> > >
> > Hi, Brian.
> > > As in the other patch, we're attempting to reserve fs blocks for the
> > > transaction, so ENOSPC is a possibility that I think the assert should
> > > accommodate.
> > How about removing the ASSERT completely as suggessted by Dave
> > in other thread?
> >
> 
> Yeah, that works too. If Dave prefers to just remove these asserts
> that's fine with me. I just wanted to make sure we aren't adding
> spurious asserts for valid failures.
Okay.
> 
> > >
> ...
> > > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > > index 97855c5..392b029 100644
> > > > --- a/fs/xfs/xfs_file.c
> > > > +++ b/fs/xfs/xfs_file.c
> > > > @@ -760,7 +760,8 @@ xfs_file_fallocate(
> > > >  	if (!S_ISREG(inode->i_mode))
> > > >  		return -EINVAL;
> > > >  	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
> > > > -		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
> > > > +		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
> > > > +		     FALLOC_FL_INSERT_RANGE))
> > > >  		return -EOPNOTSUPP;
> > > >
> > > >  	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> > > > @@ -790,6 +791,40 @@ xfs_file_fallocate(
> > > >  		error = xfs_collapse_file_space(ip, offset, len);
> > > >  		if (error)
> > > >  			goto out_unlock;
> > > > +	} else if (mode & FALLOC_FL_INSERT_RANGE) {
> > > > +		unsigned blksize_mask = (1 << inode->i_blkbits) - 1;
> > > > +		struct iattr iattr;
> > > > +
> > > > +		if (offset & blksize_mask || len & blksize_mask) {
> > > > +			error = -EINVAL;
> > > > +			goto out_unlock;
> > > > +		}
> > > > +
> > > > +		/* Check for wrap through zero */
> > > > +		if (inode->i_size + len > inode->i_sb->s_maxbytes) {
> > > > +			error = -EFBIG;
> > > > +			goto out_unlock;
> > > > +		}
> > > > +
> > > > +		/* Offset should be less than i_size */
> > > > +		if (offset >= i_size_read(inode)) {
> > > > +			error = -EINVAL;
> > > > +			goto out_unlock;
> > > > +		}
> > > > +
> > > > +		/*
> > > > +		 * The first thing we do is to expand file to
> > > > +		 * avoid data loss if there is error while shifting
> > > > +		 */
> > > > +		iattr.ia_valid = ATTR_SIZE;
> > > > +		iattr.ia_size = i_size_read(inode) + len;
> > > > +		error = xfs_setattr_size(ip, &iattr);
> > > > +		if (error)
> > > > +			goto out_unlock;
> > >
> > > I don't necessarily know that it's problematic to do the setattr before
> > > the bmap fixup. We'll have a chance for partial completion of this
> > > operation either way. But I'm not a fan of the code duplication here.
> > > This also still skips the time update in the event of insert space
> > > failure, though perhaps that's not such a big deal if we're returning an
> > > error.
> > >
> > > I think it would be better to leave things organized as before and
> > > introduce an error2 variable and a &nrshifts or some such parameter to
> > > xfs_insert_file_space() that initializes to 0 and returns the number of
> > > record shifts. The caller can then decide whether it's appropriate to
> > > break out immediately or do the inode size update and return the error.
> > >
> > > Perhaps not the cleanest thing in the world, but also not the first
> > > place we would use 'error2' to manage error priorities (grep around for
> > > it)...
> > Yes, Right. I also thought such sequence at first. But we should consider
> > sudden power off and unplug device case during shifting extent.
> > While we are in the middle of shifitng extents and if there is sudden
> > power failure user can still think that data is lost as we won't get any
> > chance to update the file size in these cases.
> > Updating file size before the shifitng operation can start will prevent this.
> >
> > Thanks.
> 
> Hmm, fair point. That seems less critical to me than the general error
> sequence, but if we want to handle that case I think we could still fix
> the duplication in xfs_file_fallocate(). We could possibly factor out
> the common bits (update time and set size) into a helper, or what seems
> a bit cleaner on first thought, move the bulk of the (mode &
> FALLOC_FL_INSERT_RANGE) block to after the common part. Then the
> function looks something like this:
> 
> 	...
> 	xfs_ilock();
> 
> 	/* pre-inode fixup ops */
> 	if (mode & ...) {
> 		...
> 	} else if (mode & FALLOC_FL_INSERT_RANGE) {
> 		/* comment as to what's going on here :) */
> 
> 		/* error checks */
> 
> 		new_size = ...;
> 		do_file_insert = 1;
> 	}
> 	...
> 	xfs_trans_ichgtime();
> 	xfs_setattr_size();
> 	...
> 
> 	/*
> 	 * Some operations are performed after the inode size is updated. For
> 	 * example, insert range expands the address space of the file, shifts
> 	 * all subsequent extents over and allocates space into the hole.
> 	 * Updating the size first ensures that shifted extents aren't left
> 	 * hanging past EOF in the event of a crash or failure.
> 	 */
> 	if (do_file_insert) {
> 		/* alloc space */
> 		...
> 	}
> 	...
> 
> That seems a bit cleaner to me, but I'm not wedded to it. Thoughts? It
> might be worth soliciting some other thoughts/ideas before reworking it.
> Thanks.
Okay, I agree about your opinion.
And I would like to get some feedback from Dave before reworking.

Thanks for your valuable review!

> 
> Brian
> 
> > >
> > > Brian
> > >
> > > > +
> > > > +		error = xfs_insert_file_space(ip, offset, len);
> > > > +		if (error)
> > > > +			goto out_unlock;
> > > >  	} else {
> > > >  		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
> > > >  		    offset + len > i_size_read(inode)) {
> >

