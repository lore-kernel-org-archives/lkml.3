Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3LRRl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:41:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab3LRRlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:41:24 -0500
Date: Wed, 18 Dec 2013 09:41:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Driver core / sysfs fixes for 3.13-rc5
Message-ID: <20131218174126.GA32489@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 374b105797c3d4f29c685f3be535c35f5689b30e:

  Linux 3.13-rc3 (2013-12-06 09:34:04 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.13-rc5

for you to fetch changes up to a8b14744429f90763f258ad0f69601cdcad610aa:

  sysfs: give different locking key to regular and bin files (2013-12-07 21:22:00 -0800)

----------------------------------------------------------------
Driver core fix for 3.13-rc5

Here's a single sysfs fix for 3.13-rc5 that resolves a lockdep issue in
sysfs that has been reported.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Tejun Heo (1):
      sysfs: give different locking key to regular and bin files

 fs/sysfs/file.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)
