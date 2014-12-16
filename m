Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaLPJ1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:27:48 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59375 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaLPJ0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:26:38 -0500
From: Vignesh R <vigneshr@ti.com>
To: Benoit Cousson <bcousson@baylibre.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>
CC: <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Vignesh R <vigneshr@ti.com>
Subject: [PATCH 0/2] PCIe related fixes for DRA7xx
Date: Tue, 16 Dec 2014 14:52:49 +0530
Message-ID: <1418721771-31184-1-git-send-email-vigneshr@ti.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix inconsistent enumeration of PCIe gen2 cards on DRA7xx
boards. Tested this patch series, after applying some out of the
tree patches for resetting PCIe.

Vignesh R (2):
  phy: phy-ti-pipe3: fix inconsistent enumeration of PCIe gen2 cards
  ARM: dts: DRA7X: drop id property in pcie_phy

 arch/arm/boot/dts/dra7.dtsi          |  2 --
 drivers/phy/phy-omap-control.c       |  7 +++----
 drivers/phy/phy-ti-pipe3.c           | 10 ++++++----
 include/linux/phy/omap_control_phy.h |  6 +++---
 4 files changed, 12 insertions(+), 13 deletions(-)

-- 
1.9.1

