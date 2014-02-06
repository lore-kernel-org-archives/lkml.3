Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbaBFVe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 16:34:56 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:53257 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025AbaBFVey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 16:34:54 -0500
MIME-Version: 1.0
In-Reply-To: <20140206173158.6A2A14266DC@whiskey.americas.sgi.com>
References: <20140206173158.6A2A14266DC@whiskey.americas.sgi.com>
Date: Thu, 6 Feb 2014 13:34:53 -0800
X-Google-Sender-Auth: _pz5cr3UFWa_mWLpaJ4KlNoWxvU
Message-ID: <CA+55aFzxUtHWL1hPcNv-zUXFWzrZtKAsh_ZVotfFUvH1hqDrMg@mail.gmail.com>
Subject: Re: [GIT PULL] XFS fix for 3.14-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ben Myers <bpm@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have no idea why you keep re-sending this.

It got merged a week ago. See commit f1499382f114.

                Linus

On Thu, Feb 6, 2014 at 9:31 AM, Ben Myers <bpm@sgi.com> wrote:
> Hi Linus,
>
>    Please pull this xfs update for 3.14.  This is to allow logical sector sized
>    direct io on advanced format disks.  Eric expressed a desire to get this fix
>    in 3.14 because this bug affects some virtualization packages.
>
> Thanks,
>         Ben
>
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
