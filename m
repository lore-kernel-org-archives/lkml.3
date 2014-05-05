Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbaEEVTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 17:19:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51156 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbaEEVTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 17:19:37 -0400
Date: Mon, 5 May 2014 14:22:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.15-rc5
Message-ID: <20140505212243.GA3758@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d1db0eea852497762cab43b905b879dfcd3b8987:

  Linux 3.15-rc3 (2014-04-27 19:29:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.15-rc4

for you to fetch changes up to 86281966c7395aa9a13a20c52e26005f5e142451:

  Merge tag 'iio-fixes-for-3.15b' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-linus (2014-04-30 14:19:23 -0700)

----------------------------------------------------------------

Staging / IIO fixes for 3.15-rc4

Here are some small IIO driver fixes for 3.15-rc4 that resolve some
reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Atilla Filiz (1):
      iio:imu:mpu6050: Fixed segfault in Invensens MPU driver due to null dereference

Doug Anderson (1):
      iio: adc: Nothing in ADC should be a bool CONFIG

Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.15b' of git://git.kernel.org/.../jic23/iio into staging-linus

Jimmy Li (1):
      staging:iio:ad2s1200 fix missing parenthesis in a for statment.

Naveen Krishna Ch (1):
      iio: exynos_adc: use indio_dev->dev structure to handle child nodes

 drivers/iio/adc/Kconfig                    | 4 ++--
 drivers/iio/adc/exynos_adc.c               | 6 +++---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c | 7 +++++--
 drivers/staging/iio/resolver/ad2s1200.c    | 3 ++-
 4 files changed, 12 insertions(+), 8 deletions(-)
