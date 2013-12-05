Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab3LETbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:31:00 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:52527 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab3LETaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:30:55 -0500
X-IronPort-AV: E=Sophos;i="4.93,835,1378882800"; 
   d="scan'208";a="161131"
From: Tim Kryger <tim.kryger@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        Axel Lin <axel.lin@ingics.com>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Subject: [PATCH v4 4/8] ARM: dts: Specify clocks for SDHCIs on bcm11351
Date: Thu, 5 Dec 2013 11:20:40 -0800
Message-ID: <1386271244-3927-5-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
References: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specify the external clock label in each SDHCI node.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
 arch/arm/boot/dts/bcm11351.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
index 9b99c52..25ca128 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -118,6 +118,7 @@
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f180000 0x10000>;
 		interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&sdio1_clk>;
 		status = "disabled";
 	};
 
@@ -125,6 +126,7 @@
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f190000 0x10000>;
 		interrupts = <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&sdio2_clk>;
 		status = "disabled";
 	};
 
@@ -132,6 +134,7 @@
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f1a0000 0x10000>;
 		interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&sdio3_clk>;
 		status = "disabled";
 	};
 
@@ -139,6 +142,7 @@
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f1b0000 0x10000>;
 		interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&sdio4_clk>;
 		status = "disabled";
 	};
 
-- 
1.8.0.1

