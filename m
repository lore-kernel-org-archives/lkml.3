Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaGLUmY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 16:42:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaGLUmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 16:42:23 -0400
Date: Sat, 12 Jul 2014 13:46:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.16-rc5
Message-ID: <20140712204652.GA20543@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cd3de83f147601356395b57a8673e9c5ff1e59d1:

  Linux 3.16-rc4 (2014-07-06 12:37:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.16-rc5

for you to fetch changes up to bdac8ca90e07edde8bbef5396784f7011e6e5b8d:

  Merge tag 'iio-fixes-for-3.16c' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-linus (2014-07-08 15:43:45 -0700)

----------------------------------------------------------------
Staging / IIO fixes for 3.16-rc5

Here are some IIO driver fixes for 3.16-rc5.  Nothing major, just
resolves some minor issues that have been reported.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.16c' of git://git.kernel.org/.../jic23/iio into staging-linus

Jan Kardell (1):
      iio: ti_am335x_adc: Fix: Use same step id at FIFOs both ends

Peter Meerwald (1):
      iio:tcs3472: Check for buffer enabled and locking

Sachin Kamat (6):
      iio: hid-sensor-press: Fix return values
      iio: hid-sensor-accel-3d: Fix return values
      iio: hid-sensor-magn-3d: Fix return values
      iio: hid-sensor-als: Fix return values
      iio: hid-sensor-gyro-3d: Fix return values
      iio: hid-sensor-prox: Fix return values

 drivers/iio/accel/hid-sensor-accel-3d.c       |  7 ++-----
 drivers/iio/adc/ti_am335x_adc.c               |  2 +-
 drivers/iio/gyro/hid-sensor-gyro-3d.c         |  7 ++-----
 drivers/iio/light/hid-sensor-als.c            |  7 ++-----
 drivers/iio/light/hid-sensor-prox.c           |  7 ++-----
 drivers/iio/light/tcs3472.c                   | 11 ++++++++++-
 drivers/iio/magnetometer/hid-sensor-magn-3d.c |  7 ++-----
 drivers/iio/pressure/hid-sensor-press.c       |  7 ++-----
 8 files changed, 23 insertions(+), 32 deletions(-)
