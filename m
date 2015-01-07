Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbbAGFrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 00:47:42 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:42955 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbbAGFrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 00:47:39 -0500
X-AuditID: cbfee68f-f791c6d000004834-c2-54acc879ceee
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Brian Foster'" <bfoster@redhat.com>
Cc: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'linux-ext4'" <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>
References: <004801d02670$79bd5bf0$6d3813d0$@samsung.com>
 <20150106181309.GH5874@bfoster.bfoster>
In-reply-to: <20150106181309.GH5874@bfoster.bfoster>
Subject: RE: [PATCH v7 10/11]  xfstests: fsstress: Add fallocate insert range
 operation
Date: Wed, 07 Jan 2015 14:47:37 +0900
Message-id: <001801d02a3d$7125aad0$53710070$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQF7aq0fEPuRAIsLWu6pKDYha2hK7gIeNdzhnUydIbA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsWyRsSkSLfyxJoQg3un9CyWTrzEbPHuc5XF
	lmP3GC1mzrvDZrFn70kWi8u75rBZtPb8ZLdY1HeL0YHD49QiCY+mM0eZPVZf2Mro8X7fVTaP
	vi2rGD0+b5ILYIvisklJzcksSy3St0vgytj52LZgkUzF6kXPWBoY74l2MXJySAiYSMye9YcF
	whaTuHBvPVsXIxeHkMBSRonbR5cxwxTtbtzGCmILCUxnlLhyRQei6C+jRP+n74xdjBwcbALa
	En+2gA0VEVCXuDNvAgtIDbPAJ0aJh1cOMEM0J0vsfXoazOYEGrrw6A42EFtYIFLiws3rYAtY
	BFQlPrzeAVbDK2ApseDLNkYIW1Dix+R7YJcyC2hJrN95nAnClpfYvOYt1KEKEjvOvmaEOMJK
	4vym82wQNSIS+168YwQ5SELgI7vExqvN7BDLBCS+TT7EAvKAhICsxKYDUHMkJQ6uuMEygVFi
	FpLVs5CsnoVk9SwkKxYwsqxiFE0tSC4oTkovMtYrTswtLs1L10vOz93ECIzm0/+e9e9gvHvA
	+hCjAAejEg9vQd+aECHWxLLiytxDjKZAF01klhJNzgemjLySeENjMyMLUxNTYyNzSzMlcd6F
	Uj+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTCqmGqfSZ0TVLTy+2aDksubZm/VTHnNNe/C
	spT8ZjejlEhWca1/i1yv9vK+nJHdpKU1uT65Iyw73eRkZ188T4HGyi9XXJ81XxK4ntznGH5s
	ZhYfk8qhfzsVZ3hVL4q4qZ63TGXb3FqP/NIZjYukn8/mmhxjeykgo+Dq0y12TPypTBqdez5m
	9yqxFGckGmoxFxUnAgCP5dD64QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jQd3KE2tCDL5MUbNYOvESs8W7z1UW
	W47dY7SYOe8Om8WevSdZLC7vmsNm0drzk91iUd8tRgcOj1OLJDyazhxl9lh9YSujx/t9V9k8
	+rasYvT4vEkugC2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+geJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGzse2BYtk
	KlYvesbSwHhPtIuRk0NCwERid+M2VghbTOLCvfVsILaQwHRGiStXdLoYuYDsv4wS/Z++M3Yx
	cnCwCWhL/NkC1isioC5xZ94EFpAaZoFPjBIPrxxghmhOltj79DSYzQm0YOHRHWBDhQUiJS7c
	vA62jEVAVeLD6x1gNbwClhILvmxjhLAFJX5MvscCYjMLaEms33mcCcKWl9i85i0zxKEKEjvO
	vmaEOMJK4vym82wQNSIS+168Y5zAKDQLyahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nMN9YoT
	c4tL89L1kvNzNzGCU8UzqR2MKxssDjEKcDAq8fAW9K0JEWJNLCuuzD3EKMHBrCTCa9UJFOJN
	SaysSi3Kjy8qzUktPsRoCvTpRGYp0eR8YBrLK4k3NDYxM7I0Mje0MDI2VxLnVbJvCxESSE8s
	Sc1OTS1ILYLpY+LglGpgjJAx9DBh0311vF9dVtXOrnzLmxdWy/7JWRQy1TVuyOf6WiOw7Pgf
	5zcsq1l/K7beXr9SJkrquGrcB48NvyzWJignn/l0ad8cr/B3Kq4VZY8Kmufyce7ZWRfOeqru
	bNEHu0fSR76ItX04yX/siz6vz9PFNocVZ6XF/61afN/R4tSbmSflH2fvU2Ipzkg01GIuKk4E
	ACN5HbcrAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Fri, Jan 02, 2015 at 06:42:51PM +0900, Namjae Jeon wrote:
> > This commit adds insert operation support for fsstress, which is
> > meant to exercise fallocate FALLOC_FL_INSERT_RANGE support.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > ---
> 
> It might be nice to avoid setting FALLOC_FL_KEEP_SIZE for insert and
> collapse ops alike (see the only use of KEEP_SIZE in fsstress.c) to
> increase the likelihood of valid fallocate() calls. We currently set it
> randomly, but unconditionally across all fallocate ops.
> 
> That could be done in a separate patch, however, and this looks good to
> me:
Thank you! I will share a separate patch.

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  ltp/fsstress.c | 19 ++++++++++++++++---
> >  src/global.h   |  4 ++++
> >  2 files changed, 20 insertions(+), 3 deletions(-)
> >
> > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > index b56fe5c..aa3e0c3 100644
> > --- a/ltp/fsstress.c
> > +++ b/ltp/fsstress.c
> > @@ -72,6 +72,7 @@ typedef enum {
> >  	OP_PUNCH,
> >  	OP_ZERO,
> >  	OP_COLLAPSE,
> > +	OP_INSERT,
> >  	OP_READ,
> >  	OP_READLINK,
> >  	OP_RENAME,
> > @@ -170,6 +171,7 @@ void	mknod_f(int, long);
> >  void	punch_f(int, long);
> >  void	zero_f(int, long);
> >  void	collapse_f(int, long);
> > +void	insert_f(int, long);
> >  void	read_f(int, long);
> >  void	readlink_f(int, long);
> >  void	rename_f(int, long);
> > @@ -209,6 +211,7 @@ opdesc_t	ops[] = {
> >  	{ OP_PUNCH, "punch", punch_f, 1, 1 },
> >  	{ OP_ZERO, "zero", zero_f, 1, 1 },
> >  	{ OP_COLLAPSE, "collapse", collapse_f, 1, 1 },
> > +	{ OP_INSERT, "insert", insert_f, 1, 1 },
> >  	{ OP_READ, "read", read_f, 1, 0 },
> >  	{ OP_READLINK, "readlink", readlink_f, 1, 0 },
> >  	{ OP_RENAME, "rename", rename_f, 2, 1 },
> > @@ -2176,6 +2179,7 @@ struct print_flags falloc_flags [] = {
> >  	{ FALLOC_FL_NO_HIDE_STALE, "NO_HIDE_STALE"},
> >  	{ FALLOC_FL_COLLAPSE_RANGE, "COLLAPSE_RANGE"},
> >  	{ FALLOC_FL_ZERO_RANGE, "ZERO_RANGE"},
> > +	{ FALLOC_FL_INSERT_RANGE, "INSERT_RANGE"},
> >  	{ -1, NULL}
> >  };
> >
> > @@ -2227,10 +2231,11 @@ do_fallocate(int opno, long r, int mode)
> >  	off %= maxfsize;
> >  	len = (off64_t)(random() % (1024 * 1024));
> >  	/*
> > -	 * Collapse range requires off and len to be block aligned, make it
> > -	 * more likely to be the case.
> > +	 * Collapse/insert range requires off and len to be block aligned,
> > +	 * make it more likely to be the case.
> >  	 */
> > -	if ((mode & FALLOC_FL_COLLAPSE_RANGE) && (opno % 2)) {
> > +	if ((mode & (FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE)) &&
> > +		(opno % 2)) {
> >  		off = ((off + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
> >  		len = ((len + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
> >  	}
> > @@ -2656,6 +2661,14 @@ collapse_f(int opno, long r)
> >  }
> >
> >  void
> > +insert_f(int opno, long r)
> > +{
> > +#ifdef HAVE_LINUX_FALLOC_H
> > +	do_fallocate(opno, r, FALLOC_FL_INSERT_RANGE);
> > +#endif
> > +}
> > +
> > +void
> >  read_f(int opno, long r)
> >  {
> >  	char		*buf;
> > diff --git a/src/global.h b/src/global.h
> > index 8180f66..f63246b 100644
> > --- a/src/global.h
> > +++ b/src/global.h
> > @@ -172,6 +172,10 @@
> >  #define FALLOC_FL_ZERO_RANGE		0x10
> >  #endif
> >
> > +#ifndef FALLOC_FL_INSERT_RANGE
> > +#define FALLOC_FL_INSERT_RANGE		0x20
> > +#endif
> > +
> >  #endif /* HAVE_LINUX_FALLOC_H */
> >
> >  #endif /* GLOBAL_H */
> > --
> > 1.7.11-rc0
> >

