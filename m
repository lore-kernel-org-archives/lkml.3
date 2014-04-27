Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaD0AgK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 20:36:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbaD0AgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 20:36:04 -0400
Date: Sat, 26 Apr 2014 17:36:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] Driver core / sysfs fixes for 3.15-rc3
Message-ID: <20140427003646.GA3018@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:

  Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.15-rc3

for you to fetch changes up to 0c8c77d35582c3f7989f1316368da5ae7f14ad4b:

  s390/ccwgroup: Fix memory corruption (2014-04-25 12:25:14 -0700)

----------------------------------------------------------------
Driver core fixes for 3.15-rc3

Here are some kernfs fixes for 3.15-rc3 that resolve some reported
problems.  Nothing huge, but all needed.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Christian Borntraeger (1):
      s390/ccwgroup: Fix memory corruption

Jianyu Zhan (1):
      kernfs: fix a subdir count leak

Tejun Heo (1):
      kernfs: add back missing error check in kernfs_fop_mmap()

 arch/s390/include/asm/ccwgroup.h | 2 +-
 fs/kernfs/dir.c                  | 9 ++++++---
 fs/kernfs/file.c                 | 2 ++
 3 files changed, 9 insertions(+), 4 deletions(-)
