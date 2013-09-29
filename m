Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab3I2UBf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 16:01:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab3I2UBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 16:01:31 -0400
Date: Sun, 29 Sep 2013 13:01:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core fixes for 3.12-rc3
Message-ID: <20130929200132.GA31045@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.12-rc3

for you to fetch changes up to f123db8e9d6c84c863cb3c44d17e61995dc984fb:

  driver core : Fix use after free of dev->parent in device_shutdown (2013-09-26 14:46:11 -0700)

----------------------------------------------------------------
Driver core / sysfs fixes for 3.12-rc3

Here are 2 fixes for 3.12-rc3.  One fixes a sysfs problem with mounting caused
by 3.12-rc1, and the other is a bug reported by the chromeos developers with
the driver core.

Both have been in linux-next for a bit.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Benson Leung (1):
      driver core : Fix use after free of dev->parent in device_shutdown

Eric W. Biederman (1):
      sysfs: Allow mounting without CONFIG_NET

 drivers/base/core.c | 14 +++++++-------
 lib/kobject.c       |  5 +----
 2 files changed, 8 insertions(+), 11 deletions(-)
