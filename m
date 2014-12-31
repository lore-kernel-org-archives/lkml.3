Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaLaIpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 03:45:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40851 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaLaIpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 03:45:52 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL 0/3] phy: fixes for 3.19 -rc cycle
Date: Wed, 31 Dec 2014 14:15:46 +0530
Message-ID: <1420015549-20697-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Please find the pull request for 3.19 -rc cycle. This contains misc fixes
in PHY drivers.

Let me know if I have to change something.

Thanks
Kishon

The following changes since commit aa39477b5692611b91ac9455ae588738852b3f60:

  Merge tag 'dm-3.19-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm (2014-12-22 14:47:17 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git tags/for-3.19-rc

for you to fetch changes up to 0bc09f9cdc589e0b54724096138996a00b19babb:

  phy: phy-ti-pipe3: fix inconsistent enumeration of PCIe gen2 cards (2014-12-23 15:44:32 +0530)

----------------------------------------------------------------
misc fixes in PHY drivers

----------------------------------------------------------------
Dan Carpenter (1):
      phy: miphy28lp: unlock on error in miphy28lp_init()

Hans de Goede (1):
      phy-sun4i-usb: Change disconnect threshold value for sun6i

Vignesh R (1):
      phy: phy-ti-pipe3: fix inconsistent enumeration of PCIe gen2 cards

 drivers/phy/phy-miphy28lp.c          |    3 ++-
 drivers/phy/phy-omap-control.c       |    7 +++----
 drivers/phy/phy-sun4i-usb.c          |    3 ++-
 drivers/phy/phy-ti-pipe3.c           |   10 ++++++----
 include/linux/phy/omap_control_phy.h |    6 +++---
 5 files changed, 16 insertions(+), 13 deletions(-)

-- 
1.7.9.5

