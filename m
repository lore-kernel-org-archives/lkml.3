Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986AbaGPIzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:55:54 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14673 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760964AbaGPIzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:55:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 16 Jul 2014 01:48:21 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <tj@kernel.org>,
        <hdegoede@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v3 8/8] ARM: tegra: Add options for Tegra AHCI support to tegra_defconfig
Date: Wed, 16 Jul 2014 11:54:23 +0300
Message-ID: <1405500863-19696-9-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1405500863-19696-1-git-send-email-mperttunen@nvidia.com>
References: <1405500863-19696-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds ATA, SATA_AHCI and AHCI_TEGRA support to tegra_defconfig
so that the SATA support will be automatically enabled.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 arch/arm/configs/tegra_defconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index 285c433..2b8be48 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -102,6 +102,9 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
 CONFIG_SCSI_MULTI_LUN=y
 # CONFIG_SCSI_LOWLEVEL is not set
+CONFIG_ATA=y
+CONFIG_SATA_AHCI=y
+CONFIG_AHCI_TEGRA=y
 CONFIG_NETDEVICES=y
 CONFIG_DUMMY=y
 CONFIG_IGB=y
-- 
1.8.1.5

