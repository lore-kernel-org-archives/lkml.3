Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaAILDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:03:05 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5562 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaAILCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:02:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 09 Jan 2014 03:02:55 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] ARM: tegra: add system-power-controller property for PMIC node
Date: Thu, 9 Jan 2014 16:31:48 +0530
Message-ID: <1389265308-26405-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add system-power-controller property to system PMIC, ams AS3722,
node to enable power off functionality through PMIC.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra124-venice2.dts |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts/tegra124-venice2.dts
index c6dcef5..1ad3f33 100644
--- a/arch/arm/boot/dts/tegra124-venice2.dts
+++ b/arch/arm/boot/dts/tegra124-venice2.dts
@@ -616,6 +616,8 @@
 			reg = <0x40>;
 			interrupts = <0 86 IRQ_TYPE_LEVEL_HIGH>;
 
+			ams,system-power-controller;
+
 			#interrupt-cells = <2>;
 			interrupt-controller;
 
-- 
1.7.9.5

