Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669Ab3LFSZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:25:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab3LFSZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:25:28 -0500
Date: Fri, 6 Dec 2013 10:25:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.13-rc3
Message-ID: <20131206182527.GA30287@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit dc1ccc48159d63eca5089e507c82c7d22ef60839:

  Linux 3.13-rc2 (2013-11-29 12:57:14 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.13-rc3

for you to fetch changes up to 55ef003e4ae684d5660f984eb2352df12572d9df:

  Merge tag 'iio-fixes-for-3.13b' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-linus (2013-12-03 13:24:58 -0800)

----------------------------------------------------------------

staging driver fixes for 3.13-rc3

Here are some bugfixes for the staging and IIO drivers for 3.13-rc3.

The resolve the vm memory issue in the tidspbridge driver, fix a much-reported
build failure in an ARM driver, and some other IIO bugfixes that have been
reported.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.13b' of git://git.kernel.org/.../jic23/iio into staging-linus

Ivaylo Dimitrov (1):
      Staging: TIDSPBRIDGE: Use vm_iomap_memory for mmap-ing instead of remap_pfn_range

Russell King - ARM Linux (1):
      Fix build failure for gp2ap020a00f.c

Srinivas Pandruvada (2):
      HID: hid-sensor-hub: Add logical min and max
      iio: hid-sensors: Fix power and report state

 drivers/hid/hid-sensor-hub.c                        | 20 ++++++++------------
 drivers/iio/common/hid-sensors/Kconfig              |  9 ---------
 drivers/iio/common/hid-sensors/hid-sensor-trigger.c | 20 +++++++++++++++-----
 drivers/iio/light/Kconfig                           |  1 +
 drivers/staging/tidspbridge/rmgr/drv_interface.c    | 13 +++++--------
 include/linux/hid-sensor-hub.h                      |  2 ++
 include/linux/hid-sensor-ids.h                      | 12 ++++++++++++
 7 files changed, 43 insertions(+), 34 deletions(-)
