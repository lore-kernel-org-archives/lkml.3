Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaD0AgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 20:36:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaD0AgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 20:36:22 -0400
Date: Sat, 26 Apr 2014 17:37:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.15-rc3
Message-ID: <20140427003704.GA3068@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:

  Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.15-rc3

for you to fetch changes up to 2704f807f9498054b8153002bafa3e818079e9a5:

  staging: comedi: usbdux: bug fix for accessing 'ao_chanlist' in private data (2014-04-23 16:20:15 -0700)

----------------------------------------------------------------
Staging / IIO driver fixes for 3.15-rc3

Here are some small staging and IIO driver fixes for 3.15-rc3.

Nothing major at all, just some assorted issues that people have reported.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alec Berg (1):
      iio: querying buffer scan_mask should return 0/1

Alexandre Belloni (5):
      iio: adc: at91_adc: Repair broken platform_data support
      ARM: at91: at91sam9g45: change at91_adc name
      ARM: at91: at91sam9260: change at91_adc name
      iio: adc: at91_adc: correct default shtim value
      iio: adc: mxs-lradc: fix warning when buidling on avr32

Beomho Seo (1):
      iio: cm32181: Fix read integration time function

Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.15a' of git://git.kernel.org/.../jic23/iio into staging-linus

H Hartley Sweeten (1):
      staging: comedi: usbdux: bug fix for accessing 'ao_chanlist' in private data

Jimmy Li (1):
      staging:iio:ad2s1200 fix a missing break

Krzysztof Kozlowski (1):
      iio: cm36651: Fix i2c client leak and possible NULL pointer dereference

 arch/arm/mach-at91/at91sam9260_devices.c |  2 +-
 arch/arm/mach-at91/at91sam9g45_devices.c |  2 +-
 drivers/iio/adc/at91_adc.c               | 33 ++++++++++++++++++++++++++------
 drivers/iio/industrialio-buffer.c        |  6 ++++--
 drivers/iio/light/cm32181.c              |  1 +
 drivers/iio/light/cm36651.c              | 22 +++++++++++++++++++--
 drivers/staging/comedi/drivers/usbdux.c  |  9 +++------
 drivers/staging/iio/adc/mxs-lradc.c      |  2 +-
 drivers/staging/iio/resolver/ad2s1200.c  |  1 +
 9 files changed, 59 insertions(+), 19 deletions(-)
