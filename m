Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030934Ab3DSPF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 11:05:57 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:37896 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030601Ab3DSPFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 11:05:54 -0400
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-arm-kernel@lists.infradead.org
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH] ARM: mx28: add dma channels for all auarts
Date: Fri, 19 Apr 2013 17:05:06 +0200
Message-Id: <1366383906-25747-1-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only auart0 was filled.
Tested on a custom i.MX283 board for ttyAPP1/2/3/4.

Signed-off-by: Eric Bénard <eric@eukrea.com>
---
 arch/arm/boot/dts/imx28.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
index 25f2243..15933ed 100644
--- a/arch/arm/boot/dts/imx28.dtsi
+++ b/arch/arm/boot/dts/imx28.dtsi
@@ -886,6 +886,7 @@
 				compatible = "fsl,imx28-auart", "fsl,imx23-auart";
 				reg = <0x8006c000 0x2000>;
 				interrupts = <113 72 73>;
+				fsl,auart-dma-channel = <10 11>;
 				clocks = <&clks 45>;
 				status = "disabled";
 			};
@@ -894,6 +895,7 @@
 				compatible = "fsl,imx28-auart", "fsl,imx23-auart";
 				reg = <0x8006e000 0x2000>;
 				interrupts = <114 74 75>;
+				fsl,auart-dma-channel = <12 13>;
 				clocks = <&clks 45>;
 				status = "disabled";
 			};
@@ -902,6 +904,7 @@
 				compatible = "fsl,imx28-auart", "fsl,imx23-auart";
 				reg = <0x80070000 0x2000>;
 				interrupts = <115 76 77>;
+				fsl,auart-dma-channel = <14 15>;
 				clocks = <&clks 45>;
 				status = "disabled";
 			};
@@ -910,6 +913,7 @@
 				compatible = "fsl,imx28-auart", "fsl,imx23-auart";
 				reg = <0x80072000 0x2000>;
 				interrupts = <116 78 79>;
+				fsl,auart-dma-channel = <0 1>;
 				clocks = <&clks 45>;
 				status = "disabled";
 			};
-- 
1.7.11.7

