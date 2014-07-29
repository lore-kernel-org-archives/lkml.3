Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaG2Amq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 20:42:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14468 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaG2Amo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 20:42:44 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-f8-53d6ee007e74
Date: Tue, 29 Jul 2014 09:41:11 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 07/11] f2fs: enable in-place-update for fdatasync
Message-id: <20140729004111.GA442@lcm>
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
 <1406328445-63707-7-git-send-email-jaegeuk@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <1406328445-63707-7-git-send-email-jaegeuk@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t8zY12Gd9eCDY5cUbZ4sn4Ws8WlRe4W
	e/aeZLG4vGsOmwOLx6ZVnWweuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK+Pwj6UsBQvEKyad
	us/cwPhEqIuRk0NCwETiy9wedghbTOLCvfVsXYxcHEICyxglzvZ3M8MUzdp+jREiMZ1R4sXm
	b1BVPxkl5l1dzARSxSKgKrFmy1s2EJtNQEui/fRaFhBbREBF4tCiy2ArmAUyJSb0vwCzhQUC
	JP5dXw5m8wqoScx5dwaolwNoaLXEjAPOEGFBiR+T77FAtGpJrN95nAnClpZ49HcGWCungLNE
	Z8MqsBpRoFVTTm4Du01CYBG7xJTGz2wQtwlIfJt8iAVkvoSArMSmA1CPSUocXHGDZQKj2Cwk
	62YhWTcLyboFjMyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MUJiqG8H480D1ocYk4FWTmSW
	Ek3OB8ZgXkm8obGZkYWpiamxkbmlGWnCSuK8ix4mBQkJpCeWpGanphakFsUXleakFh9iZOLg
	lGpgnKR0p1enNY7j1Pe2rU+jvwY/r1Hfe0zf4kHb2U8FHFLX/uyalWOW72ih7Hrq022ZQ7dv
	TJt6L0V0Zujkk501LpIRU601E/mOHL9fqv2k/m9V0Y3fK48d1TfX3n7bpdvFvOR5fcnqFcUd
	DTftxFcsnJvWvpT5/0PrUv6jFeknlu3XK4osn7JotxJLcUaioRZzUXEiAL55fUO3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jQV2Gd9eCDfb/lrN4sn4Ws8WlRe4W
	e/aeZLG4vGsOmwOLx6ZVnWweuxd8ZvL4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHj8I+lLAULxCsmnbrP3MD4RKiLkZNDQsBEYtb2a4wQtpjEhXvr2boYuTiE
	BKYzSrzY/A3K+ckoMe/qYiaQKhYBVYk1W96ygdhsAloS7afXsoDYIgIqEocWXWYHsZkFMiUm
	9L8As4UFAiT+XV8OZvMKqEnMeXcGqJcDaGi1xIwDzhBhQYkfk++xQLRqSazfeZwJwpaWePR3
	Blgrp4CzRGfDKrAaUaBVU05uY5vAKDALSfssJO2zkLQvYGRexSiaWpBcUJyUnmuoV5yYW1ya
	l66XnJ+7iREcoc+kdjCubLA4xCjAwajEw7th7rVgIdbEsuLK3EOMEhzMSiK885cAhXhTEiur
	Uovy44tKc1KLDzGaAgNjIrOUaHI+MHnklcQbGpuYGVkamVkYmZibK4nzHmi1DhQSSE8sSc1O
	TS1ILYLpY+LglGpgZLRk/CJR4DCl7OSuDZd+RFSndF69by53tjl/fU3HgwfmZ5Wqkzplatkd
	7P/kJCspvF6uPePRs0fX3rJmL5m3uZpZbJIYo2+SrNhju7Unot4H3TW1PXzw+/18E6v17U1N
	T0rvB25wWSBl+sgla98V+58OE45JLDN4zpMvfPk381qTmId+7uFLlViKMxINtZiLihMBGXEo
	/uYCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

On Fri, Jul 25, 2014 at 03:47:21PM -0700, Jaegeuk Kim wrote:
> This patch enforces in-place-updates only when fdatasync is requested.
> If we adopt this in-place-updates for the fdatasync, we can skip to write the
> recovery information.

But, as you know, random write occurs when changing into in-place-updates.
It will degrade write performance. Is there any case in-place-updates is
better, except recovery or high utilization?

Thanks

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/f2fs.h    | 1 +
>  fs/f2fs/file.c    | 7 +++++++
>  fs/f2fs/segment.h | 4 ++++
>  3 files changed, 12 insertions(+)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index ab36025..8f8685e 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -998,6 +998,7 @@ enum {
>  	FI_INLINE_DATA,		/* used for inline data*/
>  	FI_APPEND_WRITE,	/* inode has appended data */
>  	FI_UPDATE_WRITE,	/* inode has in-place-update data */
> +	FI_NEED_IPU,		/* used fo ipu for fdatasync */
>  };
>  
>  static inline void set_inode_flag(struct f2fs_inode_info *fi, int flag)
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 121689a..e339856 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -127,11 +127,18 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  		return 0;
>  
>  	trace_f2fs_sync_file_enter(inode);
> +
> +	/* if fdatasync is triggered, let's do in-place-update */
> +	if (datasync)
> +		set_inode_flag(fi, FI_NEED_IPU);
> +
>  	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
>  	if (ret) {
>  		trace_f2fs_sync_file_exit(inode, need_cp, datasync, ret);
>  		return ret;
>  	}
> +	if (datasync)
> +		clear_inode_flag(fi, FI_NEED_IPU);
>  
>  	/*
>  	 * if there is no written data, don't waste time to write recovery info.
> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
> index ee5c75e..55973f7 100644
> --- a/fs/f2fs/segment.h
> +++ b/fs/f2fs/segment.h
> @@ -486,6 +486,10 @@ static inline bool need_inplace_update(struct inode *inode)
>  	if (S_ISDIR(inode->i_mode))
>  		return false;
>  
> +	/* this is only set during fdatasync */
> +	if (is_inode_flag_set(F2FS_I(inode), FI_NEED_IPU))
> +		return true;
> +
>  	switch (SM_I(sbi)->ipu_policy) {
>  	case F2FS_IPU_FORCE:
>  		return true;
> -- 
> 1.8.5.2 (Apple Git-48)
> 
> 
> ------------------------------------------------------------------------------
> Want fast and easy access to all the code in your enterprise? Index and
> search up to 200,000 lines of code with a free copy of Black Duck
> Code Sight - the same software that powers the world's largest code
> search on Ohloh, the Black Duck Open Hub! Try it now.
> http://p.sf.net/sfu/bds
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
