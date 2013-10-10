Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab3JJKun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:50:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57508 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab3JJKuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:50:40 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <bcousson@baylibre.com>
CC: <tony@atomide.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] ARM: dts: omap5-uevm: remove always_on, boot_on from smps10_out1
Date: Thu, 10 Oct 2013 16:19:53 +0530
Message-ID: <1381402195-29257-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smps10 should be enabled only in the case of host mode. So stop
doing always_on, boot_on from smps10_out1. The driver will enable it in host
mode.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap5-uevm.dts |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
index d784b3a..e06a04a 100644
--- a/arch/arm/boot/dts/omap5-uevm.dts
+++ b/arch/arm/boot/dts/omap5-uevm.dts
@@ -334,8 +334,6 @@
 					regulator-name = "smps10_out1";
 					regulator-min-microvolt = <5000000>;
 					regulator-max-microvolt = <5000000>;
-					regulator-always-on;
-					regulator-boot-on;
 				};
 
 				ldo1_reg: ldo1 {
-- 
1.7.10.4

