Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaG2X42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:56:28 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37423 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbaG2X40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:56:26 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-1d-53d834a8d4b9
Date: Wed, 30 Jul 2014 08:54:55 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 07/11] f2fs: enable in-place-update for fdatasync
Message-id: <20140729235455.GB442@lcm>
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
 <1406328445-63707-7-git-send-email-jaegeuk@kernel.org>
 <20140729004111.GA442@lcm> <20140729122215.GB84378@jaegeuk-mac02>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20140729122215.GB84378@jaegeuk-mac02>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t8zQ90VJjeCDZ5dFrJ4sn4Ws8WlRe4W
	e/aeZLG4vGsOmwOLx6ZVnWweuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK+PAvV1sBccVKhoW
	TGZsYFwr2cXIySEhYCJxtv8IO4QtJnHh3nq2LkYuDiGBZYwS/Wf/M8EUrWvuZYJITGeUmNLc
	zQzh/GSUuDDhOmMXIwcHi4CqxL5twiANbAJaEu2n17KA2CICKhKHFl0G28AskCkxof8FmC0s
	ECDx7/pyMJtXQE1ift9kFoiZ+xkl5p46yQyREJT4MfkeC0SzlsT6nceZIGxpiUd/Z4A1cwoY
	S9xZswTMFgVaNuXkNrAXJASWsUtMO/EXbBCLgIDEt8mHWEAOlRCQldh0gBniM0mJgytusExg
	FJuFZN0sJOtmIVm3gJF5FaNoakFyQXFSepGRXnFibnFpXrpecn7uJkZIFPXtYLx5wPoQYzLQ
	yonMUqLJ+cAozCuJNzQ2M7IwNTE1NjK3NCNNWEmcd9HDpCAhgfTEktTs1NSC1KL4otKc1OJD
	jEwcnFINjJaG03T+i80SCvz2KGbO92amqO8nF9TPCBeffdholUnxenZbLblbX/yamzNikqsr
	Fhw1WrPALfN2hOLESwKvfi7bWH10SmC1bm144+SN0j22F9jnMHeWzX4oPJsv++kN8YLsPAHZ
	ldd4ouafbshiWR/gOnvTy/KfPpt25/wLswhnW3v0gYPhKyWW4oxEQy3mouJEALHjgr+4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jQd0VJjeCDTbd4LN4sn4Ws8WlRe4W
	e/aeZLG4vGsOmwOLx6ZVnWweuxd8ZvL4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHjwL1dbAXHFSoaFkxmbGBcK9nFyMkhIWAisa65lwnCFpO4cG89WxcjF4eQ
	wHRGiSnN3cwQzk9GiQsTrjN2MXJwsAioSuzbJgzSwCagJdF+ei0LiC0ioCJxaNFldhCbWSBT
	YkL/CzBbWCBA4t/15WA2r4CaxPy+ySwQM/czSsw9dZIZIiEo8WPyPRaIZi2J9TuPM0HY0hKP
	/s4Aa+YUMJa4s2YJmC0KtGzKyW1sExgFZiFpn4WkfRaS9gWMzKsYRVMLkguKk9JzjfSKE3OL
	S/PS9ZLzczcxgmP0mfQOxlUNFocYBTgYlXh4Z/y/HizEmlhWXJl7iFGCg1lJhPer3I1gId6U
	xMqq1KL8+KLSnNTiQ4ymwNCYyCwlmpwPTB95JfGGxiZmRpZGZhZGJubmSuK8B1utA4UE0hNL
	UrNTUwtSi2D6mDg4pRoY522e0Zi0J7DE8yarzuKu5FTGw4axs+4ef3JBbMOMJtYv9d2cMpPU
	7SUUkh+Y+ry+qTjhwsL9WdEeU96J3tQq6bnL+S3L//kFfeeu1gSlZ0f6I66eXHlC9OO/nMty
	2ssbb//ZVe5oE55t0fpAc5L2JcG18cFqvHNapukaMDdOn5q1dA3/Htd8JZbijERDLeai4kQA
	KNgXeucCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 05:22:15AM -0700, Jaegeuk Kim wrote:
> Hi Changman,
> 
> On Tue, Jul 29, 2014 at 09:41:11AM +0900, Changman Lee wrote:
> > Hi Jaegeuk,
> > 
> > On Fri, Jul 25, 2014 at 03:47:21PM -0700, Jaegeuk Kim wrote:
> > > This patch enforces in-place-updates only when fdatasync is requested.
> > > If we adopt this in-place-updates for the fdatasync, we can skip to write the
> > > recovery information.
> > 
> > But, as you know, random write occurs when changing into in-place-updates.
> > It will degrade write performance. Is there any case in-place-updates is
> > better, except recovery or high utilization?
> 
> As I described, you can easily imagine, if users requested small amount of data
> writes with fdatasync, we should do data writes + node writes.
> But, if we can do in-place-update, we don't need to write node blocks.
> Surely it triggers random writes, however, the amount of data is preety small
> and the device handles them very fast by its inside cache, so that it can
> enhance the performance.
> 
> Thanks,

Partially agree. Sometimes, I see that SSR shows lower performance than
IPU. One of the reasons might be node writes.
Anyway, if so, we should know total dirty pages for fdatasync and it's very
tunable according to a random write performance of device.

Thanks,

> 
> > 
> > Thanks
> > 
> > > 
> > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > ---
> > >  fs/f2fs/f2fs.h    | 1 +
> > >  fs/f2fs/file.c    | 7 +++++++
> > >  fs/f2fs/segment.h | 4 ++++
> > >  3 files changed, 12 insertions(+)
> > > 
> > > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > > index ab36025..8f8685e 100644
> > > --- a/fs/f2fs/f2fs.h
> > > +++ b/fs/f2fs/f2fs.h
> > > @@ -998,6 +998,7 @@ enum {
> > >  	FI_INLINE_DATA,		/* used for inline data*/
> > >  	FI_APPEND_WRITE,	/* inode has appended data */
> > >  	FI_UPDATE_WRITE,	/* inode has in-place-update data */
> > > +	FI_NEED_IPU,		/* used fo ipu for fdatasync */
> > >  };
> > >  
> > >  static inline void set_inode_flag(struct f2fs_inode_info *fi, int flag)
> > > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> > > index 121689a..e339856 100644
> > > --- a/fs/f2fs/file.c
> > > +++ b/fs/f2fs/file.c
> > > @@ -127,11 +127,18 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> > >  		return 0;
> > >  
> > >  	trace_f2fs_sync_file_enter(inode);
> > > +
> > > +	/* if fdatasync is triggered, let's do in-place-update */
> > > +	if (datasync)
> > > +		set_inode_flag(fi, FI_NEED_IPU);
> > > +
> > >  	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
> > >  	if (ret) {
> > >  		trace_f2fs_sync_file_exit(inode, need_cp, datasync, ret);
> > >  		return ret;
> > >  	}
> > > +	if (datasync)
> > > +		clear_inode_flag(fi, FI_NEED_IPU);
> > >  
> > >  	/*
> > >  	 * if there is no written data, don't waste time to write recovery info.
> > > diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
> > > index ee5c75e..55973f7 100644
> > > --- a/fs/f2fs/segment.h
> > > +++ b/fs/f2fs/segment.h
> > > @@ -486,6 +486,10 @@ static inline bool need_inplace_update(struct inode *inode)
> > >  	if (S_ISDIR(inode->i_mode))
> > >  		return false;
> > >  
> > > +	/* this is only set during fdatasync */
> > > +	if (is_inode_flag_set(F2FS_I(inode), FI_NEED_IPU))
> > > +		return true;
> > > +
> > >  	switch (SM_I(sbi)->ipu_policy) {
> > >  	case F2FS_IPU_FORCE:
> > >  		return true;
> > > -- 
> > > 1.8.5.2 (Apple Git-48)
> > > 
> > > 
> > > ------------------------------------------------------------------------------
> > > Want fast and easy access to all the code in your enterprise? Index and
> > > search up to 200,000 lines of code with a free copy of Black Duck
> > > Code Sight - the same software that powers the world's largest code
> > > search on Ohloh, the Black Duck Open Hub! Try it now.
> > > http://p.sf.net/sfu/bds
> > > _______________________________________________
> > > Linux-f2fs-devel mailing list
> > > Linux-f2fs-devel@lists.sourceforge.net
> > > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
