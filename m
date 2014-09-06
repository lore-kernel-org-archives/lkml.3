Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaIFI4I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 04:56:08 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:34138 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbaIFIzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 04:55:18 -0400
From: Mikko Perttunen <cyndis@kapsi.fi>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, wni@nvidia.com,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v3 3/5] ARM: tegra124: Add I2C controller ids to device tree
Date: Sat,  6 Sep 2014 11:54:43 +0300
Message-Id: <1409993685-21911-4-git-send-email-cyndis@kapsi.fi>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409993685-21911-1-git-send-email-cyndis@kapsi.fi>
References: <1409993685-21911-1-git-send-email-cyndis@kapsi.fi>
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: cyndis@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

I2C controller ids are required when programming hardware blocks
that send messages to devices connected to an I2C bus, such as
when the PMC sends a poweroff message to the PMIC. Add ids
to all I2C controllers in Tegra124.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Reviewed-by: Wei Ni <wni@nvidia.com>
Tested-by: Wei Ni <wni@nvidia.com>
---
 arch/arm/boot/dts/tegra124.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
index a7608a4..65daa9e 100644
--- a/arch/arm/boot/dts/tegra124.dtsi
+++ b/arch/arm/boot/dts/tegra124.dtsi
@@ -356,6 +356,7 @@
 		reset-names = "i2c";
 		dmas = <&apbdma 21>, <&apbdma 21>;
 		dma-names = "rx", "tx";
+		nvidia,controller-id = <0>;
 		status = "disabled";
 	};
 
@@ -371,6 +372,7 @@
 		reset-names = "i2c";
 		dmas = <&apbdma 22>, <&apbdma 22>;
 		dma-names = "rx", "tx";
+		nvidia,controller-id = <1>;
 		status = "disabled";
 	};
 
@@ -386,6 +388,7 @@
 		reset-names = "i2c";
 		dmas = <&apbdma 23>, <&apbdma 23>;
 		dma-names = "rx", "tx";
+		nvidia,controller-id = <2>;
 		status = "disabled";
 	};
 
@@ -401,6 +404,7 @@
 		reset-names = "i2c";
 		dmas = <&apbdma 26>, <&apbdma 26>;
 		dma-names = "rx", "tx";
+		nvidia,controller-id = <3>;
 		status = "disabled";
 	};
 
@@ -416,6 +420,7 @@
 		reset-names = "i2c";
 		dmas = <&apbdma 24>, <&apbdma 24>;
 		dma-names = "rx", "tx";
+		nvidia,controller-id = <4>;
 		status = "disabled";
 	};
 
@@ -431,6 +436,7 @@
 		reset-names = "i2c";
 		dmas = <&apbdma 30>, <&apbdma 30>;
 		dma-names = "rx", "tx";
+		nvidia,controller-id = <5>;
 		status = "disabled";
 	};
 
-- 
2.1.0

