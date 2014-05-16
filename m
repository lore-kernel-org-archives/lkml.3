Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaEPNDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:03:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55304 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbaEPNDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:03:18 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL 00/11] PHY: for 3.16
Date: Fri, 16 May 2014 18:32:55 +0530
Message-ID: <1400245387-14445-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's the pull request for 3.16. It contains mostly bug fixes and cleanup
apart from one new driver for exynos5 usb3 PHY. Please consider merging them
to your usb tree.

Let me know if I have to change anything.

Cheers
Kishon

The following changes since commit 38583f095c5a8138ae2a1c9173d0fd8a9f10e8aa:

  Merge branch 'akpm' (incoming from Andrew) (2014-05-06 13:07:41 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git tags/for-3.16

for you to fetch changes up to eadd43123933e8c0a55245c51de68668e620e27f:

  phy: usb: sunxi: Introduce Allwinner A31 USB PHY support (2014-05-14 19:41:13 +0530)

----------------------------------------------------------------
for 3.16 merge window

Bunch of fixes and a new driver for Exynos5 USB 3.0 PHY.

----------------------------------------------------------------
Antoine Ténart (1):
      phy: exynos-mipi-video: fix check on array index

Arnd Bergmann (2):
      PHY: Exynos: fix SATA phy license typo
      phy: kona2: use 'select GENERIC_PHY' in Kconfig

Maxime Ripard (3):
      phy: sunxi: Rework phy initialization
      Documentation: dt: Add new compatible for the A31 USB Phy
      phy: usb: sunxi: Introduce Allwinner A31 USB PHY support

Roger Quadros (2):
      phy: omap-usb2: Use generic clock names "wkupclk" and "refclk"
      phy: omap-usb2: Add clock names to Documentation binding

Vivek Gautam (3):
      Documentation: Document Exynos5 USB 3.0 DRD PHY
      phy: Add new Exynos5 USB 3.0 PHY driver
      phy: exynos5-usbdrd: Add facility for VBUS supply

 .../devicetree/bindings/phy/samsung-phy.txt        |   47 ++
 .../devicetree/bindings/phy/sun4i-usb-phy.txt      |   23 +-
 Documentation/devicetree/bindings/phy/ti-phy.txt   |    7 +
 drivers/phy/Kconfig                                |   13 +-
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-exynos-mipi-video.c                |    2 +-
 drivers/phy/phy-exynos5-usbdrd.c                   |  676 ++++++++++++++++++++
 drivers/phy/phy-exynos5250-sata.c                  |    2 +-
 drivers/phy/phy-omap-usb2.c                        |   30 +-
 drivers/phy/phy-sun4i-usb.c                        |   75 ++-
 include/linux/mfd/syscon/exynos5-pmu.h             |   44 ++
 11 files changed, 869 insertions(+), 51 deletions(-)
 create mode 100644 drivers/phy/phy-exynos5-usbdrd.c
 create mode 100644 include/linux/mfd/syscon/exynos5-pmu.h

-- 
1.7.9.5

