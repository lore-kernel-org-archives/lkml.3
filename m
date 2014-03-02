Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaCBWJI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 17:09:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbaCBWJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 17:09:07 -0500
Date: Sun, 2 Mar 2014 14:09:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] Driver core fix for 3.14-rc5
Message-ID: <20140302220918.GA12879@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.14-rc5

for you to fetch changes up to fed95bab8d29b928fcf6225be72d37ded452e8a2:

  sysfs: fix namespace refcnt leak (2014-02-25 07:37:52 -0800)

----------------------------------------------------------------
Driver core fix for 3.14-rc5

Here is a single sysfs fix for 3.14-rc5.  It fixes a reported problem
with the namespace code in sysfs.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Li Zefan (1):
      sysfs: fix namespace refcnt leak

 fs/kernfs/mount.c      | 8 +++++++-
 fs/sysfs/mount.c       | 5 +++--
 include/linux/kernfs.h | 9 +++++----
 3 files changed, 15 insertions(+), 7 deletions(-)
