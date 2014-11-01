Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760348AbaKAUUY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 16:20:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758762AbaKAUUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 16:20:22 -0400
Date: Sat, 1 Nov 2014 13:19:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.18-rc3
Message-ID: <20141101201910.GA3958@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.18-rc3

for you to fetch changes up to 238b5ad855924919e5b98d0c772d9dc78795639b:

  staging: comedi: fix memory leak / bad pointer freeing for chanlist (2014-10-29 16:18:31 +0800)

----------------------------------------------------------------
Staging fixes for 3.18-rc3

Here are some staging driver fixes for 3.18-rc3.  Mostly iio and comedi
driver fixes for issues reported by people.

All of these have been in linux-next for a while with no reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Chen Gang (1):
      drivers/staging/comedi/Kconfig: Let COMEDI_II_PCI20KC depend on HAS_IOMEM

Fabio Estevam (1):
      iio: adc: mxs-lradc: Disable the clock on probe failure

Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.18a' of git://git.kernel.org/.../jic23/iio into staging-linus

Ian Abbott (4):
      staging: comedi: (regression) channel list must be set for COMEDI_CMD ioctl
      staging: comedi: widen subdevice number argument in ioctl handlers
      staging: comedi: Kconfig: fix config COMEDI_ADDI_APCI_3120 dependants
      staging: comedi: fix memory leak / bad pointer freeing for chanlist

Jes Sorensen (1):
      staging: rtl8723au: Fix alignment of mac_addr for ether_addr_copy() usage

Lars-Peter Clausen (2):
      staging:iio:ad5933: Fix NULL pointer deref when enabling buffer
      staging:iio:ad5933: Drop "raw" from channel names

Robin van der Gracht (1):
      iio: st_sensors: Fix buffer copy

 drivers/iio/common/st_sensors/st_sensors_buffer.c |  2 +-
 drivers/staging/comedi/Kconfig                    |  2 +-
 drivers/staging/comedi/comedi_fops.c              | 26 ++++++++++++-----------
 drivers/staging/iio/adc/mxs-lradc.c               | 12 +++++++----
 drivers/staging/iio/impedance-analyzer/ad5933.c   | 15 ++++++-------
 drivers/staging/rtl8723au/include/rtw_eeprom.h    |  2 +-
 6 files changed, 31 insertions(+), 28 deletions(-)
