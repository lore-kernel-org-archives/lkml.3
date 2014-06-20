Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbaFTT7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:59:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbaFTT7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:59:38 -0400
Date: Fri, 20 Jun 2014 13:03:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.16-rc2
Message-ID: <20140620200340.GA28726@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.16-rc2

for you to fetch changes up to c026a3f3972344d0adf8ae060cddc357096c9815:

  imx-drm: parallel-display: Fix DPMS default state. (2014-06-19 17:33:37 -0700)

----------------------------------------------------------------
Staging driver fixes for 3.16-rc2

Here are a few fixes for staging and iio drivers that resolve issues
reported in 3.16-rc1.

All have been in linux-next just fine.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Archana Patni (1):
      iio: hid-sensors: Get feature report from sensor hub after changing power state

Arnd Bergmann (2):
      staging/iio: IIO_SIMPLE_DUMMY_BUFFER neds IIO_BUFFER
      staging: comedi: addi_apci_1564: add addi_watchdog dependency

Dan Carpenter (2):
      iio: adc: at91: signedness bug in at91_adc_get_trigger_value_by_name()
      iio: adc: checking for NULL instead of IS_ERR() in probe

Denis Carikli (1):
      imx-drm: parallel-display: Fix DPMS default state.

Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.16a' of git://git.kernel.org/.../jic23/iio into staging-linus

Jes Sorensen (2):
      staging: rtl8723au: Request correct firmware file for A-cut parts
      staging: rtl8723au: Reference correct firmwarefiles with MODULE_FIRMWARE()

Mario Schuknecht (1):
      staging: iio: tsl2x7x_core: fix proximity treshold

Paul Kocialkowski (1):
      twl4030-madc: Request processed values in twl4030_get_madc_conversion

Peter Meerwald (2):
      iio: Fix two mpl3115 issues in measurement conversion
      iio: Fix endianness issue in ak8975_read_axis()

Robert Hodaszi (1):
      iio: mxs-lradc: fix divider

Yi Zhang (1):
      staging: android: timed_output: fix use after free of dev

 drivers/iio/adc/at91_adc.c                          | 16 ++++++++--------
 drivers/iio/adc/men_z188_adc.c                      |  4 ++--
 drivers/iio/adc/twl4030-madc.c                      |  1 +
 drivers/iio/common/hid-sensors/hid-sensor-trigger.c |  3 +++
 drivers/iio/magnetometer/ak8975.c                   |  9 +--------
 drivers/iio/pressure/mpl3115.c                      |  6 +++---
 drivers/staging/android/timed_output.c              |  1 -
 drivers/staging/comedi/Kconfig                      |  1 +
 drivers/staging/iio/Kconfig                         |  9 +++++----
 drivers/staging/iio/adc/mxs-lradc.c                 | 12 ++++++++----
 drivers/staging/iio/light/tsl2x7x_core.c            |  8 ++++++--
 drivers/staging/imx-drm/parallel-display.c          |  7 +++++++
 drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c   |  2 +-
 drivers/staging/rtl8723au/os_dep/os_intfs.c         |  4 +++-
 14 files changed, 49 insertions(+), 34 deletions(-)
