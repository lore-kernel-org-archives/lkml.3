Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaA2BMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 20:12:15 -0500
Received: from relay2.sgi.com ([192.48.179.30]:42829 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754026AbaA2BMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 20:12:14 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update #2 for 3.14-rc1
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20140129011209.253624266DC@whiskey.americas.sgi.com>
Date: Tue, 28 Jan 2014 19:12:09 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull this xfs update for 3.14.  This is to allow logical sector sized
   direct io on advanced format disks.

Thanks,
	Ben

The following changes since commit bf3964c188d686424ff7b69a45941851b9f437f0:

  Merge branch 'xfs-extent-list-locking-fixes' into for-next (2014-01-09 16:03:18 -0600)

are available in the git repository at:


  git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-v3.14-rc1-2

for you to fetch changes up to 7c71ee78031c248dca13fc94dea9a4cc217db6cf:

  xfs: allow logical-sector sized O_DIRECT (2014-01-24 11:55:42 -0600)

----------------------------------------------------------------
xfs: update #2 for v3.14-rc1

- allow logical sector sized direct io on 'advanced format' 4k/512 disk.

----------------------------------------------------------------
Eric Sandeen (3):
      xfs: clean up xfs_buftarg
      xfs: rename xfs_buftarg structure members
      xfs: allow logical-sector sized O_DIRECT

 fs/xfs/xfs_buf.c   | 14 +++++++++-----
 fs/xfs/xfs_buf.h   | 20 +++++++++++++++++---
 fs/xfs/xfs_file.c  |  7 +++++--
 fs/xfs/xfs_ioctl.c |  2 +-
 4 files changed, 32 insertions(+), 11 deletions(-)
