Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbaBFRcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 12:32:05 -0500
Received: from relay1.sgi.com ([192.48.179.29]:36196 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbaBFRcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 12:32:03 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS fix for 3.14-rc2
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20140206173158.6A2A14266DC@whiskey.americas.sgi.com>
Date: Thu,  6 Feb 2014 11:31:58 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull this xfs update for 3.14.  This is to allow logical sector sized
   direct io on advanced format disks.  Eric expressed a desire to get this fix
   in 3.14 because this bug affects some virtualization packages.

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
