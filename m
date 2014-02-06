Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbaBFVxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 16:53:39 -0500
Received: from relay2.sgi.com ([192.48.179.30]:60501 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756102AbaBFVxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 16:53:38 -0500
Date: Thu, 6 Feb 2014 15:53:32 -0600
From: Ben Myers <bpm@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: [GIT PULL] XFS fix for 3.14-rc2
Message-ID: <20140206215332.GQ1935@sgi.com>
References: <20140206173158.6A2A14266DC@whiskey.americas.sgi.com>
 <CA+55aFzxUtHWL1hPcNv-zUXFWzrZtKAsh_ZVotfFUvH1hqDrMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzxUtHWL1hPcNv-zUXFWzrZtKAsh_ZVotfFUvH1hqDrMg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 01:34:53PM -0800, Linus Torvalds wrote:
> I have no idea why you keep re-sending this.
> 
> It got merged a week ago. See commit f1499382f114.

Ok, there it is.  Sorry for the noise.

Thanks,
	Ben	

> On Thu, Feb 6, 2014 at 9:31 AM, Ben Myers <bpm@sgi.com> wrote:
> > Hi Linus,
> >
> >    Please pull this xfs update for 3.14.  This is to allow logical sector sized
> >    direct io on advanced format disks.  Eric expressed a desire to get this fix
> >    in 3.14 because this bug affects some virtualization packages.
> >
> > Thanks,
> >         Ben
> >
> > The following changes since commit bf3964c188d686424ff7b69a45941851b9f437f0:
> >
> >   Merge branch 'xfs-extent-list-locking-fixes' into for-next (2014-01-09 16:03:18 -0600)
> >
> > are available in the git repository at:
> >
> >
> >   git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-v3.14-rc1-2
> >
> > for you to fetch changes up to 7c71ee78031c248dca13fc94dea9a4cc217db6cf:
> >
> >   xfs: allow logical-sector sized O_DIRECT (2014-01-24 11:55:42 -0600)
> >
> > ----------------------------------------------------------------
> > xfs: update #2 for v3.14-rc1
> >
> > - allow logical sector sized direct io on 'advanced format' 4k/512 disk.
> >
> > ----------------------------------------------------------------
> > Eric Sandeen (3):
> >       xfs: clean up xfs_buftarg
> >       xfs: rename xfs_buftarg structure members
> >       xfs: allow logical-sector sized O_DIRECT
> >
> >  fs/xfs/xfs_buf.c   | 14 +++++++++-----
> >  fs/xfs/xfs_buf.h   | 20 +++++++++++++++++---
> >  fs/xfs/xfs_file.c  |  7 +++++--
> >  fs/xfs/xfs_ioctl.c |  2 +-
> >  4 files changed, 32 insertions(+), 11 deletions(-)
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
