Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3FFR63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:58:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3FFR62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:58:28 -0400
Date: Thu, 6 Jun 2013 10:58:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver fixes for 3.10-rc5
Message-ID: <20130606175827.GA26012@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit e4aa937ec75df0eea0bee03bffa3303ad36c986b:

  Linux 3.10-rc3 (2013-05-26 16:00:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.10-rc4

for you to fetch changes up to 1f89b8fc41b66e5761bb8c3af5517fd42bf2067d:

  Merge tag 'iio-fixes-for-3.10b' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-linus (2013-06-04 12:30:11 -0700)

----------------------------------------------------------------

Staging driver fixes for 3.10-rc5

Here are some staging and IIO driver fixes for the 3.10-rc5 release.

All of them are tiny, and fix a number of reported issues (build and
runtime.)

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Bob Liu (1):
      drivers: staging: zcache: fix compile error

Dan Carpenter (2):
      staging: alarm-dev: information leak in alarm_ioctl()
      staging: alarm-dev: information leak in alarm_compat_ioctl()

Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.10b' of git://git.kernel.org/.../jic23/iio into staging-linus

Joe Perches (1):
      inkern: iio_device_put after incorrect return/goto

Jonathan Cameron (1):
      iio:callback buffer: free the scan_mask

Michael Hennerich (2):
      iio: frequency: ad4350: Fix bug / typo in mask
      iio:inkern: Fix typo/bug in convert raw to processed.

Paul Zimmerman (1):
      staging: dwc2: fix value of dma_mask

 drivers/iio/buffer_cb.c                  | 5 ++++-
 drivers/iio/frequency/adf4350.c          | 2 +-
 drivers/iio/inkern.c                     | 4 ++--
 drivers/staging/android/alarm-dev.c      | 8 ++++++--
 drivers/staging/dwc2/hcd.c               | 5 ++---
 drivers/staging/zcache/ramster.h         | 4 ----
 drivers/staging/zcache/ramster/debug.c   | 2 ++
 drivers/staging/zcache/ramster/ramster.c | 6 ++++--
 8 files changed, 21 insertions(+), 15 deletions(-)
