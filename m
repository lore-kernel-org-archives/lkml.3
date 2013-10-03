Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3JCUQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:16:34 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3145 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468Ab3JCUNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:13:54 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Christian Daudt" <bcm@fixthebug.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, "Chris Ball" <cjb@laptop.org>
cc: "Tim Kryger" <tim.kryger@linaro.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, patches@linaro.org
Subject: [PATCH 3/6] ARM: dts: Specify clocks for SDHCIs on bcm11351
Date: Thu, 3 Oct 2013 13:13:11 -0700
Message-ID: <1380831194-27238-4-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1380831194-27238-1-git-send-email-tim.kryger@linaro.org>
References: <1380831194-27238-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
X-WSS-ID: 7E5310730UO13716385-02-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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
index 406c050..d1ce441 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -101,6 +101,7 @@
 	sdio1: sdio@3f180000 {
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f180000 0x10000>;
+		clocks = <&sdio1_clk>;
 		interrupts = <0x0 77 0x4>;
 		status = "disabled";
 	};
@@ -108,6 +109,7 @@
 	sdio2: sdio@3f190000 {
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f190000 0x10000>;
+		clocks = <&sdio2_clk>;
 		interrupts = <0x0 76 0x4>;
 		status = "disabled";
 	};
@@ -115,6 +117,7 @@
 	sdio3: sdio@3f1a0000 {
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f1a0000 0x10000>;
+		clocks = <&sdio3_clk>;
 		interrupts = <0x0 74 0x4>;
 		status = "disabled";
 	};
@@ -122,6 +125,7 @@
 	sdio4: sdio@3f1b0000 {
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f1b0000 0x10000>;
+		clocks = <&sdio4_clk>;
 		interrupts = <0x0 73 0x4>;
 		status = "disabled";
 	};
-- 
1.8.0.1


