Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbaJXBZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 21:25:01 -0400
Received: from exprod5og101.obsmtp.com ([64.18.0.141]:48279 "HELO
	exprod5og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751907AbaJXBYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 21:24:24 -0400
From: Feng Kan <fkan@apm.com>
To: catalin.marinas@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@apm.com
Cc: Feng Kan <fkan@apm.com>, Bao Truong <btruong@apm.com>
Subject: [PATCH 1/7] arm64: dts: Add APM X-Gene USB 2.0 DTS node
Date: Thu, 23 Oct 2014 18:24:16 -0700
Message-Id: <1414113862-15067-2-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414113862-15067-1-git-send-email-fkan@apm.com>
References: <1414113862-15067-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This parch adds the device tree nodes for APM X-Gnene USB host controller.
Since X-Gene SOC supports maximum 2 USB ports, 2 dts node are added.

Signed-off-by: Bao Truong <btruong@apm.com>
Signed-off-by: Feng Kan <fkan@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index 3eef74b..a80f2fa 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -587,6 +587,20 @@
 			phy-names = "sata-phy";
 		};
 
+		usb0: dwusb@19000000 {
+			status = "disabled";
+			compatible = "xhci-platform";
+			reg =  <0x0 0x19000000 0x0 0x100000>;
+			interrupts = <0x0 0x89 0x4>;
+		};
+
+		usb1: dwusb@19800000 {
+			status = "disabled";
+			compatible = "xhci-platform";
+			reg =  <0x0 0x19800000 0x0 0x100000>;
+			interrupts = <0x0 0x8a 0x4>;
+		};
+
 		rtc: rtc@10510000 {
 			compatible = "apm,xgene-rtc";
 			reg = <0x0 0x10510000 0x0 0x400>;
-- 
1.9.1

