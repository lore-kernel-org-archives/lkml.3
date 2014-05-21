Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbaEUEwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 00:52:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaEUEwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 00:52:03 -0400
Date: Wed, 21 May 2014 13:51:53 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.15-rc6
Message-ID: <20140521045153.GA11245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 86281966c7395aa9a13a20c52e26005f5e142451:

  Merge tag 'iio-fixes-for-3.15b' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-linus (2014-04-30 14:19:23 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ staging-3.15-rc6

for you to fetch changes up to bb4e506565cfc0a2f534dfda1fb7ca5c26f7a604:

  staging: rtl8723au: Do not reset wdev->iftype in netdev_close() (2014-05-16 15:23:11 -0700)

----------------------------------------------------------------
Staging driver fixes for 3.15-rc6

Here are 5 staging driver fixes for 3.15-rc6 that resolve some reported
issues.  They are for the imx and rtl8723au drivers.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      Merge branch 'imx-drm-fixes-urgent' of git://ftp.arm.linux.org.uk/~rmk/linux-arm into staging-linus

Jes Sorensen (2):
      staging: rtl8723au: Use correct pipe type for USB interrupts
      staging: rtl8723au: Do not reset wdev->iftype in netdev_close()

Philipp Zabel (1):
      imx-drm: imx-drm-core: fix imx_drm_encoder_get_mux_id

Shawn Guo (2):
      imx-drm: imx-drm-core: skip components whose parent device is disabled
      imx-drm: imx-tve: correct DDC property name to 'ddc-i2c-bus'

 arch/arm/boot/dts/imx53-mba53.dts                | 2 +-
 drivers/staging/imx-drm/imx-drm-core.c           | 7 ++++++-
 drivers/staging/imx-drm/imx-tve.c                | 2 +-
 drivers/staging/rtl8723au/os_dep/os_intfs.c      | 2 --
 drivers/staging/rtl8723au/os_dep/usb_ops_linux.c | 2 +-
 5 files changed, 9 insertions(+), 6 deletions(-)
