Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbaFYRx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:53:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43430 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757928AbaFYRx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:53:26 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <rogerq@ti.com>, <balbi@ti.com>
Subject: [PATCH 0/2] dra7: Add PCIe PHY support
Date: Wed, 25 Jun 2014 23:22:55 +0530
Message-ID: <1403718777-9227-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1] is split into separate series in order for individual subsystem
Maintainers to pick up the patches. This series handles the PCIe
PHY support for DRA7.

The only change from previous version is added 'id' property in-order
to differentiate between each individual lanes of PCIe PHY.

[1] -> https://lkml.org/lkml/2014/5/29/258

Kishon Vijay Abraham I (2):
  phy: phy-omap-pipe3: Add support for PCIe PHY
  phy: pipe3: insert delay to enumerate in GEN2 mode

 Documentation/devicetree/bindings/phy/ti-phy.txt |   23 +++--
 drivers/phy/phy-omap-control.c                   |   52 ++++++++++-
 drivers/phy/phy-ti-pipe3.c                       |  105 +++++++++++++++++-----
 include/linux/phy/omap_control_phy.h             |   10 +++
 4 files changed, 161 insertions(+), 29 deletions(-)

-- 
1.7.9.5

