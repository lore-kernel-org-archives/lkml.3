Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaK1Wm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 17:42:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaK1WmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 17:42:25 -0500
Date: Fri, 28 Nov 2014 14:41:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.18-rc7
Message-ID: <20141128224103.GA29627@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:

  Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.18-rc7

for you to fetch changes up to 6d4556fc0309608f760f1d329df56d77fdd0c31a:

  staging: r8188eu: Add new device ID for DLink GO-USB-N150 (2014-11-27 08:55:01 -0800)

----------------------------------------------------------------
Staging/IIO driver fixes for 3.18-rc7

Here are some Staging and IIO driver fixes for 3.18-rc7 that resolve a
number of reported issues, and a new device id for a staging wireless
driver.

All of these have been in linux-next.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Axel Lin (1):
      iio: adc: men_z188_adc: Add terminating entry for men_z188_ids

Cristina Ciocan (1):
      iio: Fix IIO_EVENT_CODE_EXTRACT_DIR bit mask

Daniel Baluta (1):
      iio: accel: kxcjk-1013: Fix kxcjk10013_set_range

Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.18c' of git://git.kernel.org/.../jic23/iio into staging-linus

Larry Finger (2):
      staging: r8188eu: Fix scheduling while atomic error introduced in commit fadbe0cd
      staging: r8188eu: Add new device ID for DLink GO-USB-N150

Srinivas Pandruvada (8):
      iio: gyro: bmg160: Error handling when mode set fails
      iio: gyro: bmg160: Don't let interrupt mode to be open drain
      iio: gyro: bmg160: Send x, y and z motion separately
      iio: gyro: bmg160: Fix iio_event_spec direction
      iio: accel: bmc150: Error handling when mode set fails
      iio: accel: bmc150: Send x, y and z motion separately
      iio: accel: bmc150: Fix iio_event_spec direction
      iio: accel: bmc150: set low default thresholds

 drivers/iio/accel/bmc150-accel.c               | 40 +++++++++++++++----
 drivers/iio/accel/kxcjk-1013.c                 |  2 +
 drivers/iio/adc/men_z188_adc.c                 |  1 +
 drivers/iio/gyro/bmg160.c                      | 53 ++++++++++++++++++++++++--
 drivers/staging/rtl8188eu/core/rtw_cmd.c       | 22 +++++------
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c  | 12 +++---
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c |  2 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c    |  1 +
 include/linux/iio/events.h                     |  2 +-
 9 files changed, 105 insertions(+), 30 deletions(-)
