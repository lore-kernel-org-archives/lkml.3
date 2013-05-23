Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720Ab3EWQQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:16:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759699Ab3EWQQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:16:20 -0400
Date: Thu, 23 May 2013 09:16:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core fixes for 3.10-rc3
Message-ID: <20130523161619.GA14545@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.10-rc2

for you to fetch changes up to ac5a2962b02f57dea76d314ef2521a2170b28ab6:

  klist: del waiter from klist_remove_waiters before wakeup waitting process (2013-05-21 10:16:39 -0700)

----------------------------------------------------------------
Driver core fixes for 3.10-rc2

Here are 3 tiny driver core fixes for 3.10-rc2.

A needed symbol export, a change to make it easier to track down
offending sysfs files with incorrect attributes, and a klist bugfix.

All have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      driver core: export subsys_virtual_register

dyoung@redhat.com (1):
      driver core: print sysfs attribute name when warning about bogus permissions

wang, biao (1):
      klist: del waiter from klist_remove_waiters before wakeup waitting process

 drivers/base/bus.c  | 1 +
 drivers/base/core.c | 6 ++++--
 lib/klist.c         | 2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)
