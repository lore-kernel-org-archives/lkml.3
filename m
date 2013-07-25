Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab3GYVXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 17:23:32 -0400
Received: from relay1.sgi.com ([192.48.179.29]:37300 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab3GYVXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 17:23:31 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS fix for 3.11-rc3
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20130725212326.D02C84266DC@whiskey.americas.sgi.com>
Date: Thu, 25 Jul 2013 16:23:26 -0500 (CDT)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this fix for XFS in 3.11-rc3.  This resolves a regression
introduced in the 3.11-rc1 merge window with commit cca9f93a52d2 which
results in recovery corrupting filesystems after crashes.

Thanks,
	Ben

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/for-linus-v3.11-rc3

for you to fetch changes up to e1b4271ac261b290fdab51446996fb13e68a57be:

  xfs: di_flushiter considered harmful (2013-07-25 10:41:42 -0500)

----------------------------------------------------------------
xfs: fix for 3.11-rc3

- fix for regression in commit cca9f93a52d2, recovery causing filesystem
  corruption after a crash

----------------------------------------------------------------
Dave Chinner (1):
      xfs: di_flushiter considered harmful

 fs/xfs/xfs_dinode.h      |  3 +++
 fs/xfs/xfs_inode.c       | 31 ++++++++++++++++++++++---------
 fs/xfs/xfs_log_recover.c | 13 +++++++++++--
 3 files changed, 36 insertions(+), 11 deletions(-)
