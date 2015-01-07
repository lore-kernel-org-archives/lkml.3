Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbbAGFqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 00:46:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:11246 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbbAGFqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 00:46:44 -0500
X-AuditID: cbfee68d-f79296d000004278-67-54acc842f397
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Brian Foster'" <bfoster@redhat.com>
Cc: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'linux-ext4'" <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>
References: <003f01d02670$27a5e300$76f1a900$@samsung.com>
 <20150106163220.GE5874@bfoster.bfoster>
In-reply-to: <20150106163220.GE5874@bfoster.bfoster>
Subject: RE: [PATCH v7 1/11] fs: Add support FALLOC_FL_INSERT_RANGE for
 fallocate
Date: Wed, 07 Jan 2015 14:46:41 +0900
Message-id: <001701d02a3d$502c5a40$f0850ec0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQMZYERU/mVdyK/62rjG4RuYzFQmqAEhaC/EmhiYPBA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWyRsSkRNfpxJoQg74N8hZLJ15itnj3ucpi
	y7F7jBYz591hs9iz9ySLxeVdc9gsWnt+slss6rvF6MDhcWqRhEfTmaPMHqsvbGX0eL/vKptH
	35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZSz4N4WlYJNURcum/4wNjAdEuhg5OSQETCQ+tq1m
	grDFJC7cW88GYgsJLGWUmNTkDVMz8eUN1i5GLqD4IkaJmV/msUE4fxkl5vfOB3I4ONgEtCX+
	bBEFaRARUJe4M28CC0gNs8AnRomHVw4wQ0xNljiztJsVxOYEmvrpeQtYXFggWOLE7xZWkDks
	AqoSby4GgJi8ApYSR1Yng1TwCghK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aIOxUkdpx9zQhx
	gpXElrd7WCFqRCT2vXjHCFHzlV3i4JY4EJtFQEDi2+RDLCCrJARkJTYdgBojKXFwxQ2WCYwS
	s5BsnoVk8ywkm2ch2bCAkWUVo2hqQXJBcVJ6kaFecWJucWleul5yfu4mRmAkn/73rHcH4+0D
	1ocYBTgYlXh4C/rWhAixJpYVV+YeYjQFumgis5Rocj4wXeSVxBsamxlZmJqYGhuZW5opifMq
	Sv0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAoMZ0vntmr0E+46Kv/pYlqXgfKrv64+0Lz
	d/nCnumiG0/1cPBZR8TnVd5q2CM907Hlq4QD85czK74n7sqOTIx83xPXV2O/ZvKzzLeldX+e
	sd06lhakPFVkw3rlnew/ylY2fdApq/q7zrzs2WInhVevWcXlGEPyv6xft0jp74snOt1udw+b
	Sp1XYinOSDTUYi4qTgQAx3CPpd8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jAV2nE2tCDM7uFrNYOvESs8W7z1UW
	W47dY7SYOe8Om8WevSdZLC7vmsNm0drzk91iUd8tRgcOj1OLJDyazhxl9lh9YSujx/t9V9k8
	+rasYvT4vEkugC2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+geJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGgn9TWAo2
	SVW0bPrP2MB4QKSLkZNDQsBEYuLLG6wQtpjEhXvr2boYuTiEBBYxSsz8Mg/K+csoMb93PpDD
	wcEmoC3xZ4soSIOIgLrEnXkTWEBqmAU+MUo8vHKAGSQhJJAscWZpN9hUTqANn563gMWFBYIl
	TvxuYQWZwyKgKvHmYgCIyStgKXFkdTJIBa+AoMSPyfdYQGxmAS2J9TuPM0HY8hKb17xlhrhT
	QWLH2deMECdYSWx5u4cVokZEYt+Ld4wTGIVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnqu
	oV5xYm5xaV66XnJ+7iZGcKp4JrWDcWWDxSFGAQ5GJR7egr41IUKsiWXFlbmHGCU4mJVEeK06
	gUK8KYmVValF+fFFpTmpxYcYTYH+nMgsJZqcD0xjeSXxhsYmZkaWRuaGFkbG5krivEr2bSFC
	AumJJanZqakFqUUwfUwcnFINjIf1mQs/HOxxOHSLWV/P/aLz+sbPH5jV26+dsUn/9kT07OUq
	k9kyLt/lQxqnztTkL9AXq9t67vLDLh4PecdTdxUjlt74/cpQlv/mwkPPBBXCVX6YyLD6fD6Q
	XtZ+Yo3v0ooEk0fP19T3xRrbbJtlvYfd+E5aFIPDudTe+62/yoUu9kjapVjlK7EUZyQaajEX
	FScCAGGHJUArAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Jan 02, 2015 at 06:40:33PM +0900, Namjae Jeon wrote:
> > FALLOC_FL_INSERT_RANGE command is the opposite command of
> > FALLOC_FL_COLLAPSE_RANGE that is needed for advertisers or someone who want to
> > add some data in the middle of file. FALLOC_FL_INSERT_RANGE will create space
> > for writing new data within a file after shifting extents to right as given
> > length. and this command also has same limitation as FALLOC_FL_COLLAPSE_RANGE,
> > that is block boundary and use ftruncate(2) for crosses EOF.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > ---
> >  fs/open.c                   |  8 +++++++-
> >  include/uapi/linux/falloc.h | 15 +++++++++++++++
> >  2 files changed, 22 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/open.c b/fs/open.c
> > index 36662d0..74ed498 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -232,7 +232,8 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> >
> >  	/* Return error if mode is not supported */
> >  	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
> > -		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
> > +		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
> > +		     FALLOC_FL_INSERT_RANGE))
> >  		return -EOPNOTSUPP;
> >
> >  	/* Punch hole and zero range are mutually exclusive */
> > @@ -250,6 +251,11 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> >  	    (mode & ~FALLOC_FL_COLLAPSE_RANGE))
> >  		return -EINVAL;
> >
> > +	/* Insert range should only be used exclusively. */
> > +	if ((mode & FALLOC_FL_INSERT_RANGE) &&
> > +	    (mode & ~FALLOC_FL_INSERT_RANGE))
> > +		return -EINVAL;
> > +
> >  	if (!(file->f_mode & FMODE_WRITE))
> >  		return -EBADF;
> >
> > diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
> > index d1197ae..1f20723 100644
> > --- a/include/uapi/linux/falloc.h
> > +++ b/include/uapi/linux/falloc.h
> > @@ -41,4 +41,19 @@
> >   */
> >  #define FALLOC_FL_ZERO_RANGE		0x10
> >
> > +/*
> > + * FALLOC_FL_INSERT_RANGE is use to insert space within the file size without
> 
> 				used
> 
> > + * overwriting any existing data. The contents of the file beyond offset are
> > + * shifted towards right by len bytes to create a hole.  As such, this
> > + * operation will increase the size of the file by len bytes.
> 
> I suppose we should split this comment up into a few paragraphs similar
> to the collapse range comment it is based on. That means we split
> here...
> 
> > + * Different filesystems may implement different limitations on the granularity
> > + * of the operation. Most will limit operations to filesystem block size
> > + * boundaries, but this boundary may be larger or smaller depending on
> > + * the filesystem and/or the configuration of the filesystem or file.
> 
> ... and here.
> 
> Otherwise this looks fine to me.
Okay, I will fix them.
> 
> Brian
> 
> > + * Attempting to insert space using this flag at OR beyond the end of
> > + * the file is considered an illegal operation - just use ftruncate(2) or
> > + * fallocate(2) with mode 0 for such type of operations.
> > + */
> > +#define FALLOC_FL_INSERT_RANGE		0x20
> > +
> >  #endif /* _UAPI_FALLOC_H_ */
> > --
> > 1.7.11-rc0
> >

