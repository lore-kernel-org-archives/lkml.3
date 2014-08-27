Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbaH0Gvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 02:51:32 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15130 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbaH0Gvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 02:51:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 26 Aug 2014 23:41:26 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <linux@arm.linux.org.uk>, <olof@lixom.net>, <swarren@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH] ARM: multi_v7_defconfig: Enable Tegra AHCI driver
Date: Wed, 27 Aug 2014 09:51:15 +0300
Message-ID: <1409122275-16464-1-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables AHCI_TEGRA by default. This driver is required
for Serial ATA support on Tegra124-based boards.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 5fb95fb..affd9ee 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -132,6 +132,7 @@ CONFIG_ATA=y
 CONFIG_SATA_AHCI_PLATFORM=y
 CONFIG_AHCI_ST=y
 CONFIG_AHCI_SUNXI=y
+CONFIG_AHCI_TEGRA=y
 CONFIG_SATA_HIGHBANK=y
 CONFIG_SATA_MV=y
 CONFIG_NETDEVICES=y
-- 
1.8.1.5

