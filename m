Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab3KUQoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 11:44:05 -0500
Received: from relay2.sgi.com ([192.48.179.30]:54775 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752189Ab3KUQoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 11:44:04 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update #2 for 3.13-rc1
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20131121164359.EA9BD4266DC@whiskey.americas.sgi.com>
Date: Thu, 21 Nov 2013 10:43:59 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull this xfs update for 3.13-rc1.  There are a couple of patches
   that I wasn't quite sure about in time for our initial 3.13 pull request, a
   bugfix, and an update to add Dave to MAINTAINERS.

Thanks,
	Ben

The following changes since commit 359d992bcd398273637cd9edde10afca953783c4:

  xfs: simplify kmem_{zone_}zalloc (2013-11-06 16:31:27 -0600)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-v3.13-rc1-2

for you to fetch changes up to 2fe8c1c08b3fbd87dd2641c8f032ff6e965d5803:

  xfs: open code inc_inode_iversion when logging an inode (2013-11-18 09:42:08 -0600)

----------------------------------------------------------------
xfs: update #2 for v3.13-rc1

Here we have a performance fix for inode iversion, increased inode cluster size
for v5 superblock filesystems, a fix for error handling in
xfs_bmap_add_attrfork, and a MAINTAINERS update to add Dave.

----------------------------------------------------------------
Ben Myers (1):
      xfs: update maintainers

Dave Chinner (2):
      xfs: increase inode cluster size for v5 filesystems
      xfs: open code inc_inode_iversion when logging an inode

Mark Tinguely (1):
      xfs: fix unlock in xfs_bmap_add_attrfork

 MAINTAINERS              |  2 +-
 fs/xfs/xfs_bmap.c        | 38 +++++++++++++++++++++-----------------
 fs/xfs/xfs_mount.c       | 15 +++++++++++++++
 fs/xfs/xfs_mount.h       |  2 +-
 fs/xfs/xfs_trans_inode.c |  8 +++++---
 fs/xfs/xfs_trans_resv.c  |  3 +--
 6 files changed, 44 insertions(+), 24 deletions(-)
