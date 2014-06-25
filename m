Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbaFYSDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:03:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43568 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814AbaFYSDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:03:35 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <paul@pwsan.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <rnayak@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [PATCH 0/2] arm: hwmod: dra7: Add PCIe data and PCIe PHY data
Date: Wed, 25 Jun 2014 23:32:44 +0530
Message-ID: <1403719366-9656-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1] is split into separate series in order for individual subsystem
Maintainers to pick up the patches. This series handles the PCIe
hwmod data for DRA7.

Please find the bootlog with these hwmod patches @ [2]

[1] -> https://lkml.org/lkml/2014/5/29/258
[2] -> http://paste.ubuntu.com/7701601/

Kishon Vijay Abraham I (2):
  arm: dra7xx: Add hwmod data for pcie1 phy and pcie2 phy
  arm: dra7xx: Add hwmod data for pcie1 and pcie2 subsystems

 arch/arm/mach-omap2/cm2_7xx.h             |    4 ++
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c |  112 +++++++++++++++++++++++++++++
 arch/arm/mach-omap2/prm7xx.h              |    4 ++
 3 files changed, 120 insertions(+)

-- 
1.7.9.5

