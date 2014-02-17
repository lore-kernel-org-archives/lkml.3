Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaBQI7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:59:30 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47189 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaBQI72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:59:28 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [GIT PULL 0/8] PHY subsystem fixes for 3.14-rc4
Date: Mon, 17 Feb 2014 14:29:17 +0530
Message-ID: <1392627565-1829-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's the PULL requeust for PHY subsystem for this -rc cycle. There isn't
anything major but a bunch of obvious fixes and cleanup.

Let me know If I have to change anything.

Thanks
Kishon

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git tags/for-3.14-rc4

for you to fetch changes up to 0a06bd7ad6d603e79a2890e40190170d0c525a86:

  phy: let phy_provider_register be the last step in registering PHY (2014-02-17 13:42:10 +0530)

----------------------------------------------------------------
Bunch of obvious fixes and cleanup in PHY subsystem.

----------------------------------------------------------------
Hans de Goede (3):
      phy-core: phy_get: Leave error logging to the caller
      phy-core: Don't propagate -ENOSUPP from phy_pm_runtime_get_sync to caller
      phy-core: Don't allow building phy-core as a module

Kishon Vijay Abraham I (1):
      phy: let phy_provider_register be the last step in registering PHY

Richard Weinberger (1):
      phy,phy-bcm-kona-usb2.c: Add dependency on HAS_IOMEM

Sachin Kamat (3):
      usb: phy: twl4030-usb: Silence checkpatch warnings
      usb: phy: twl4030-usb: Remove redundant semicolon
      usb: phy: bcm-kona-usb2: Use PTR_ERR_OR_ZERO

 drivers/phy/Kconfig                 |    3 ++-
 drivers/phy/phy-bcm-kona-usb2.c     |    4 +---
 drivers/phy/phy-core.c              |   14 ++++++--------
 drivers/phy/phy-exynos-dp-video.c   |    8 ++++----
 drivers/phy/phy-exynos-mipi-video.c |   10 +++++-----
 drivers/phy/phy-mvebu-sata.c        |   10 +++++-----
 drivers/phy/phy-omap-usb2.c         |   10 +++++-----
 drivers/phy/phy-twl4030-usb.c       |   16 ++++++++--------
 8 files changed, 36 insertions(+), 39 deletions(-)

-- 
1.7.10.4

