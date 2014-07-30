Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbaG3B6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:58:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11447 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbaG3B6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:58:02 -0400
X-AuditID: cbfee68f-b7fa26d0000039a0-5e-53d851278e8c
Date: Wed, 30 Jul 2014 10:56:31 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 07/11] f2fs: enable in-place-update for fdatasync
Message-id: <20140730015631.GA24081@lcm>
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
 <1406328445-63707-7-git-send-email-jaegeuk@kernel.org>
 <20140729004111.GA442@lcm> <20140729122215.GB84378@jaegeuk-mac02>
 <20140729235455.GB442@lcm> <20140730010821.GA98706@jaegeuk-mac02>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20140730010821.GA98706@jaegeuk-mac02>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t8zI131wBvBBp0XrSyerJ/FbHFpkbvF
	nr0nWSwu75rD5sDisWlVJ5vH7gWfmTw+b5ILYI7isklJzcksSy3St0vgyjjx6jtTwRvtir93
	XrE2MM5V7GLk5JAQMJH4dnQRO4QtJnHh3nq2LkYuDiGBZYwSrcea2WCKDt/czQSRWMQoMfv9
	eWYI5yejxM/mD8wgVSwCqhJbe7+zgNhsAloS7afXgtkiAioShxZdBlvBLJApMaH/BZgtLBAg
	8e/6cjCbV0BD4sfJI1BDm5kkzrdeZIJICEr8mHyPBaJZS2L9zuNMELa0xKO/M4CaOTg4BYwl
	Np9KAgmLAu2acnIb2AsSAsvYJS73/WSDOE5A4tvkQywg9RICshKbDjBDfCYpcXDFDZYJjGKz
	kGybhWTbLCTbFjAyr2IUTS1ILihOSi8y1itOzC0uzUvXS87P3cQIiaL+HYx3D1gfYkwGWjmR
	WUo0OR8YhXkl8YbGZkYWpiamxkbmlmakCSuJ895/mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJ
	g1OqgdGhJ2Red4Vae0xY/+c9tfEtJdL/uBOmmk9ZevZVnqr5913FzE1lgsFsIvIPZihf5rQL
	+hJ05XHp2e6wSzmXdIM4v/2XZNknaSX8mGHzxo+1nfdm6e1RztxSIcUxpfiHSWxamom7ZpFR
	wuXDoXLbVpkrWNx47fDHrFtx1aGWhsvb1tw0YO64psRSnJFoqMVcVJwIAP/e00G4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jAV31wBvBBtMumVk8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hx4tV3poI32hV/77xibWCcq9jFyMkhIWAicfjmbiYIW0ziwr31bF2MXBxC
	AosYJWa/P88M4fxklPjZ/IEZpIpFQFVia+93FhCbTUBLov30WjBbREBF4tCiy+wgNrNApsSE
	/hdgtrBAgMS/68vBbF4BDYkfJ49ADW1mkjjfepEJIiEo8WPyPRaIZi2J9TuPM0HY0hKP/s4A
	aubg4BQwlth8KgkkLAq0a8rJbWwTGAVmIemehaR7FpLuBYzMqxhFUwuSC4qT0nMN9YoTc4tL
	89L1kvNzNzGCY/SZ1A7GlQ0WhxgFOBiVeHhn/L8eLMSaWFZcmXuIUYKDWUmE96vcjWAh3pTE
	yqrUovz4otKc1OJDjKbA0JjILCWanA9MH3kl8YbGJmZGlkZmFkYm5uZK4rwHWq0DhQTSE0tS
	s1NTC1KLYPqYODilGhijbBa/i3/seMT1n/CMVbxRPHyHKo7aa7JJ5Ss38kz1WnU69zPboc88
	BrHXbz+bKrfe9UGXgP8Mo6bs4Jt+8x/2dffclp/jevLwkwmle3NS/8+YbnE6VIAnWXXuvZjX
	ul13WkI3H/01P/9AHIMR47WFlV8UHVVWOOt0JC7fJ1pzsXiFYoT1Bk0lluKMREMt5qLiRAAW
	7C3l5wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 06:08:21PM -0700, Jaegeuk Kim wrote:
> On Wed, Jul 30, 2014 at 08:54:55AM +0900, Changman Lee wrote:
> > On Tue, Jul 29, 2014 at 05:22:15AM -0700, Jaegeuk Kim wrote:
> > > Hi Changman,
> > > 
> > > On Tue, Jul 29, 2014 at 09:41:11AM +0900, Changman Lee wrote:
> > > > Hi Jaegeuk,
> > > > 
> > > > On Fri, Jul 25, 2014 at 03:47:21PM -0700, Jaegeuk Kim wrote:
> > > > > This patch enforces in-place-updates only when fdatasync is requested.
> > > > > If we adopt this in-place-updates for the fdatasync, we can skip to write the
> > > > > recovery information.
> > > > 
> > > > But, as you know, random write occurs when changing into in-place-updates.
> > > > It will degrade write performance. Is there any case in-place-updates is
> > > > better, except recovery or high utilization?
> > > 
> > > As I described, you can easily imagine, if users requested small amount of data
> > > writes with fdatasync, we should do data writes + node writes.
> > > But, if we can do in-place-update, we don't need to write node blocks.
> > > Surely it triggers random writes, however, the amount of data is preety small
> > > and the device handles them very fast by its inside cache, so that it can
> > > enhance the performance.
> > > 
> > > Thanks,
> > 
> > Partially agree. Sometimes, I see that SSR shows lower performance than
> > IPU. One of the reasons might be node writes.
> 
> What did you mean? That's why I consider IPU eagarly instead of SSR and LFS
> under the very strict cases.
> 

Okay, I understood your intention.
This discussion seems to be far from this thread a litte bit.
Background I told as above is that I got better number from IPU when I
tested fio under fragmentation by varmail and dd; and utilization about 93%.
The result of perf shows f2fs spends the most cpu time searching victim
in SSR mode. And f2fs had to write node data additionaly.
I think this condition could be one of the strict case as you told.

Thanks,

> > Anyway, if so, we should know total dirty pages for fdatasync and it's very
> > tunable according to a random write performance of device.
> 
> Agreed. We can do that either by comparing the number of dirty pages,
> additional data/node writes, and cost of checkpoint at the same time.
> And there is another thing is that we need to consider the number of
> waiting time for end_io.
> I'll look into this at some time.
> 
> Thanks,
> 
> > 
> > Thanks,
> > 
> > > 
> > > > 
> > > > Thanks
> > > > 
> > > > > 
> > > > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > > > ---
> > > > >  fs/f2fs/f2fs.h    | 1 +
> > > > >  fs/f2fs/file.c    | 7 +++++++
> > > > >  fs/f2fs/segment.h | 4 ++++
> > > > >  3 files changed, 12 insertions(+)
> > > > > 
> > > > > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > > > > index ab36025..8f8685e 100644
> > > > > --- a/fs/f2fs/f2fs.h
> > > > > +++ b/fs/f2fs/f2fs.h
> > > > > @@ -998,6 +998,7 @@ enum {
> > > > >  	FI_INLINE_DATA,		/* used for inline data*/
> > > > >  	FI_APPEND_WRITE,	/* inode has appended data */
> > > > >  	FI_UPDATE_WRITE,	/* inode has in-place-update data */
> > > > > +	FI_NEED_IPU,		/* used fo ipu for fdatasync */
> > > > >  };
> > > > >  
> > > > >  static inline void set_inode_flag(struct f2fs_inode_info *fi, int flag)
> > > > > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> > > > > index 121689a..e339856 100644
> > > > > --- a/fs/f2fs/file.c
> > > > > +++ b/fs/f2fs/file.c
> > > > > @@ -127,11 +127,18 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> > > > >  		return 0;
> > > > >  
> > > > >  	trace_f2fs_sync_file_enter(inode);
> > > > > +
> > > > > +	/* if fdatasync is triggered, let's do in-place-update */
> > > > > +	if (datasync)
> > > > > +		set_inode_flag(fi, FI_NEED_IPU);
> > > > > +
> > > > >  	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
> > > > >  	if (ret) {
> > > > >  		trace_f2fs_sync_file_exit(inode, need_cp, datasync, ret);
> > > > >  		return ret;
> > > > >  	}
> > > > > +	if (datasync)
> > > > > +		clear_inode_flag(fi, FI_NEED_IPU);
> > > > >  
> > > > >  	/*
> > > > >  	 * if there is no written data, don't waste time to write recovery info.
> > > > > diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
> > > > > index ee5c75e..55973f7 100644
> > > > > --- a/fs/f2fs/segment.h
> > > > > +++ b/fs/f2fs/segment.h
> > > > > @@ -486,6 +486,10 @@ static inline bool need_inplace_update(struct inode *inode)
> > > > >  	if (S_ISDIR(inode->i_mode))
> > > > >  		return false;
> > > > >  
> > > > > +	/* this is only set during fdatasync */
> > > > > +	if (is_inode_flag_set(F2FS_I(inode), FI_NEED_IPU))
> > > > > +		return true;
> > > > > +
> > > > >  	switch (SM_I(sbi)->ipu_policy) {
> > > > >  	case F2FS_IPU_FORCE:
> > > > >  		return true;
> > > > > -- 
> > > > > 1.8.5.2 (Apple Git-48)
> > > > > 
> > > > > 
> > > > > ------------------------------------------------------------------------------
> > > > > Want fast and easy access to all the code in your enterprise? Index and
> > > > > search up to 200,000 lines of code with a free copy of Black Duck
> > > > > Code Sight - the same software that powers the world's largest code
> > > > > search on Ohloh, the Black Duck Open Hub! Try it now.
> > > > > http://p.sf.net/sfu/bds
> > > > > _______________________________________________
> > > > > Linux-f2fs-devel mailing list
> > > > > Linux-f2fs-devel@lists.sourceforge.net
> > > > > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
