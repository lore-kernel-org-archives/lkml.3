Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbaKNAUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:20:13 -0500
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:34637 "HELO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754366AbaKNAUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:20:03 -0500
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, =devicetree@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>, Bao Truong <btruong@apm.com>
Subject: [PATCH V2 1/7] arm64: dts: Add APM X-Gene USB DTS node
Date: Thu, 13 Nov 2014 16:19:55 -0800
Message-Id: <1415924401-3013-2-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415924401-3013-1-git-send-email-fkan@apm.com>
References: <1415924401-3013-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This parch adds the device tree nodes for APM X-Gnene USB host controller.
Since X-Gene SOC supports maximum 2 USB ports, 2 dts node are added.

Signed-off-by: Bao Truong <btruong@apm.com>
Signed-off-by: Feng Kan <fkan@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index 295c72d..6b4c577 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -587,6 +587,22 @@
 			phy-names = "sata-phy";
 		};
 
+		usb0: dwusb@19000000 {
+			status = "disabled";
+			compatible = "xhci-platform";
+			reg =  <0x0 0x19000000 0x0 0x100000>;
+			interrupts = <0x0 0x89 0x4>;
+			dma-coherent;
+		};
+
+		usb1: dwusb@19800000 {
+			status = "disabled";
+			compatible = "xhci-platform";
+			reg =  <0x0 0x19800000 0x0 0x100000>;
+			interrupts = <0x0 0x8a 0x4>;
+			dma-coherent;
+		};
+
 		rtc: rtc@10510000 {
 			compatible = "apm,xgene-rtc";
 			reg = <0x0 0x10510000 0x0 0x400>;
-- 
1.9.1

