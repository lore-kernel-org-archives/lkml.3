Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbaGJGZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 02:25:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35136 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaGJGZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 02:25:22 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL v2 0/5] phy: fixes for 3.16 -rc cycle
Date: Thu, 10 Jul 2014 11:54:58 +0530
Message-ID: <1404973503-3310-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Please find the updated pull requeust for 3.16 -rc cycle for PHY subsystem.

It now contains only minor fixes in phy-core and few other PHY drivers.

Let me know if I have to change something.

Cheers
Kishon

The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git tags/for-3.16-rc

for you to fetch changes up to 667a11b5a3671f4eb966ad8104cca8dbe9d3a21c:

  phy: omap-usb2: Balance pm_runtime_enable() on probe failure and remove (2014-07-10 11:46:50 +0530)

----------------------------------------------------------------
for 3.16-rc

Contains fixes in phy-core and other minor fixes in some of the other
PHY drivers.

----------------------------------------------------------------
Himangi Saraogi (1):
      phy: omap-usb2: fix devm_ioremap_resource error detection code

Maxime Ripard (1):
      phy: sun4i: depend on RESET_CONTROLLER

Roger Quadros (2):
      phy: core: Fix error path in phy_create()
      phy: omap-usb2: Balance pm_runtime_enable() on probe failure and remove

Sjoerd Simons (1):
      drivers: phy: phy-samsung-usb2.c: Add missing MODULE_DEVICE_TABLE

 drivers/phy/Kconfig            |    1 +
 drivers/phy/phy-core.c         |    7 ++++---
 drivers/phy/phy-omap-usb2.c    |   11 +++++++----
 drivers/phy/phy-samsung-usb2.c |    1 +
 4 files changed, 13 insertions(+), 7 deletions(-)

-- 
1.7.9.5

