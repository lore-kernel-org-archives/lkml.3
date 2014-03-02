Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaCBWIa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 17:08:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaCBWI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 17:08:29 -0500
Date: Sun, 2 Mar 2014 14:08:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.14-rc5
Message-ID: <20140302220840.GA12720@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:

  Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.14-rc5

for you to fetch changes up to 9f4a9b83f13544df61efd3645308f64205dc8db9:

  Merge iio fixes into staging-linus (2014-03-02 14:04:01 -0800)

----------------------------------------------------------------

Staging tree fixes for 3.14-rc5

Here are a few IIO fixes, and a new device id for a staging driver for
3.14-rc5.  All have been in linux-next for a while, I did a final merge
to get the IIO fixes into this tree, they were incorrectly in the
char-misc tree for a few weeks, and I forgot to tell you to pull them
from there.  This makes it a single pull request for you.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Beomho Seo (2):
      iio: cm36651: Fix read/write integration time function.
      iio: cm32181: Change cm32181 ambient light sensor driver

Denis CIOCCA (1):
      iio:gyro: bug on L3GD20H gyroscope support

Greg Kroah-Hartman (4):
      Merge tag 'iio-fixes-for-3.14c' of git://git.kernel.org/.../jic23/iio into char-misc-linus
      Merge 3.14-rc4 into char-misc-linus
      Merge tag 'fixes-for-3.14d' of git://git.kernel.org/.../jic23/iio into staging-linus
      Merge iio fixes into staging-linus

Juergen Beisert (1):
      staging:iio:adc:MXS:LRADC: fix touchscreen statemachine

Manu Gupta (1):
      staging: r8188eu: Add new device ID

 drivers/iio/gyro/Kconfig                    |  2 +-
 drivers/iio/gyro/st_gyro.h                  |  1 -
 drivers/iio/gyro/st_gyro_core.c             |  9 +++---
 drivers/iio/gyro/st_gyro_i2c.c              |  1 -
 drivers/iio/gyro/st_gyro_spi.c              |  1 -
 drivers/iio/light/cm32181.c                 | 16 +++++-----
 drivers/iio/light/cm36651.c                 | 45 +++++++++++++++--------------
 drivers/staging/iio/adc/mxs-lradc.c         |  1 +
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |  1 +
 9 files changed, 38 insertions(+), 39 deletions(-)
