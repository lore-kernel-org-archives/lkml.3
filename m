Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab3C1RRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:17:24 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:64050 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911Ab3C1RRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:17:23 -0400
Date: Thu, 28 Mar 2013 10:17:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core fixes for 3.9-rc4
Message-ID: <20130328171721.GA2609@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a937536b868b8369b98967929045f1df54234323:

  Linux 3.9-rc3 (2013-03-17 15:59:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.9-rc4

for you to fetch changes up to e5110f411d2ee35bf8d202ccca2e89c633060dca:

  sysfs: handle failure path correctly for readdir() (2013-03-20 16:53:42 -0700)

----------------------------------------------------------------
sysfs fixes for 3.9-rc4

Here are two fixes for sysfs that resolve issues that have been found by the
Trinity fuzz tool, causing oopses in sysfs.  They both have been in linux-next
for a while to ensure that they do not cause any other problems.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Ming Lei (2):
      sysfs: fix race between readdir and lseek
      sysfs: handle failure path correctly for readdir()

 fs/sysfs/dir.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)
