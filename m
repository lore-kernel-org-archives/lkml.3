Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab3LZQrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 11:47:35 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47138 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab3LZQre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 11:47:34 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [GIT PULL 0/4] PHY: for 3.14
Date: Thu, 26 Dec 2013 22:17:16 +0530
Message-ID: <1388076440-7620-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

here's the patches for 3.14. It contains few fixes on phy-core and added a new
PHY driver used by SATA in Marvell SoCs.

Let me know if you need any changes.

Thanks
Kishon

The following changes since commit 413541dd66d51f791a0b169d9b9014e4f56be13c:

  Linux 3.13-rc5 (2013-12-22 13:08:32 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git tags/for_3.14

for you to fetch changes up to e3eae85773ebd2165d19ca8661cca3b9c60b2ba1:

  Phy: Add a PHY driver for Marvell MVEBU SATA PHY. (2013-12-24 23:52:58 +0530)

----------------------------------------------------------------
Pull request for PHY subsystem contains few fixes in PHY-CORE mostly
w.r.t PM and reference counting and also a new PHY driver used by SATA
in Marvell SoC.

----------------------------------------------------------------
Andrew Lunn (1):
      Phy: Add a PHY driver for Marvell MVEBU SATA PHY.

Felipe Balbi (1):
      phy: core: properly handle failure of pm_runtime_get functions

Kishon Vijay Abraham I (2):
      phy: phy-core: increment refcounting variables only on 'success'
      phy: phy-core.c: remove unnecessary initialization of local variables

 drivers/phy/Kconfig          |    6 ++++++
 drivers/phy/Makefile         |    1 +
 drivers/phy/phy-core.c       |   44 +++++++++++++++++++++++++++++-------------
 drivers/phy/phy-mvebu-sata.c |  137 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 175 insertions(+), 13 deletions(-)
 create mode 100644 drivers/phy/phy-mvebu-sata.c

-- 
1.7.10.4

