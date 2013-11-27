Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab3K0Wr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:47:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3K0Wr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:47:26 -0500
Date: Wed, 27 Nov 2013 14:47:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Driver core / sysfs fixes for 3.13-rc2
Message-ID: <20131127224725.GA2699@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.13-rc2

for you to fetch changes up to 81440e73744446adbe5b5d1f19460203d275028f:

  Revert "sysfs: handle duplicate removal attempts in sysfs_remove_group()" (2013-11-27 09:44:55 -0800)

----------------------------------------------------------------
Driver core fixes for 3.13-rc2

Here are 3 patches for sysfs issues that have been reported.  Well, 1
patch really, the first one is reverted as it's not really needed (the
correct fix is coming in through the different driver subsystems
instead.)  But that 1 sysfs fix is needed, so this is still a good thing
to pull in now.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      Revert "sysfs: handle duplicate removal attempts in sysfs_remove_group()"

Mika Westerberg (1):
      sysfs: handle duplicate removal attempts in sysfs_remove_group()

Tejun Heo (1):
      sysfs: use a separate locking class for open files depending on mmap

 fs/sysfs/file.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)
