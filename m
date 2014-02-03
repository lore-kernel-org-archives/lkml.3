Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaBCVi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:38:26 -0500
Received: from relay2.sgi.com ([192.48.179.30]:34057 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753897AbaBCViX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:38:23 -0500
Date: Mon, 3 Feb 2014 15:38:18 -0600
From: Ben Myers <bpm@sgi.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        sandeen@sandeen.net
Subject: Re: [GIT PULL] XFS update #2 for 3.14-rc1
Message-ID: <20140203213818.GA2258@sgi.com>
References: <20140129011209.253624266DC@whiskey.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140129011209.253624266DC@whiskey.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

On Tue, Jan 28, 2014 at 07:12:09PM -0600, Ben Myers wrote:
>    Please pull this xfs update for 3.14.  This is to allow logical sector sized
>    direct io on advanced format disks.

Could you pick this up for -rc2?

Thanks,
	Ben

> The following changes since commit bf3964c188d686424ff7b69a45941851b9f437f0:
> 
>   Merge branch 'xfs-extent-list-locking-fixes' into for-next (2014-01-09 16:03:18 -0600)
> 
> are available in the git repository at:
> 
> 
>   git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-v3.14-rc1-2
> 
> for you to fetch changes up to 7c71ee78031c248dca13fc94dea9a4cc217db6cf:
> 
>   xfs: allow logical-sector sized O_DIRECT (2014-01-24 11:55:42 -0600)
> 
> ----------------------------------------------------------------
> xfs: update #2 for v3.14-rc1
> 
> - allow logical sector sized direct io on 'advanced format' 4k/512 disk.
> 
> ----------------------------------------------------------------
> Eric Sandeen (3):
>       xfs: clean up xfs_buftarg
>       xfs: rename xfs_buftarg structure members
>       xfs: allow logical-sector sized O_DIRECT
> 
>  fs/xfs/xfs_buf.c   | 14 +++++++++-----
>  fs/xfs/xfs_buf.h   | 20 +++++++++++++++++---
>  fs/xfs/xfs_file.c  |  7 +++++--
>  fs/xfs/xfs_ioctl.c |  2 +-
>  4 files changed, 32 insertions(+), 11 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
