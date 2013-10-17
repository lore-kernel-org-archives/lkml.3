Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587Ab3JQRgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:36:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517Ab3JQRgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:36:13 -0400
Date: Thu, 17 Oct 2013 10:36:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc fixes for 3.12-rc6
Message-ID: <20131017173612.GA8003@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:

  Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.12-rc6

for you to fetch changes up to e13cef8ded69e469b56e150e30619693b91b1864:

  Merge tag 'iio-fixes-for-3.12c' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into char-misc-linus (2013-10-17 09:40:52 -0700)

----------------------------------------------------------------

Char / misc driver fixes for 3.12-rc6

Here are some small iio and w1 driver fixes for 3.12-rc6.

There is also a hyper-v fix in here, which turned out to be incorrect,
so it was reverted.  That will probably have to wait unto 3.13-rc1 to
get accepted as it's still being discussed.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (2):
      Revert "Drivers: hv: vmbus: Fix a bug in channel rescind code"
      Merge tag 'iio-fixes-for-3.12c' of git://git.kernel.org/.../jic23/iio into char-misc-linus

Hans-Frieder Vogt (2):
      w1 - fix fops in w1_bus_notify
      w1 - call request_module with w1 master mutex unlocked

K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Fix a bug in channel rescind code

Lars-Peter Clausen (1):
      iio:buffer: Free active scan mask in iio_disable_all_buffers()

Wei Yongjun (1):
      iio: frequency: adf4350: add missing clk_disable_unprepare() on error in adf4350_probe()

 drivers/iio/frequency/adf4350.c   | 6 ++++--
 drivers/iio/industrialio-buffer.c | 3 +++
 drivers/w1/w1.c                   | 6 ++++++
 3 files changed, 13 insertions(+), 2 deletions(-)
