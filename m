Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbbA0MdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:33:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35269 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417AbbA0MTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 081/126] ARM: dts: imx25: Fix the SPI1 clocks
Date: Tue, 27 Jan 2015 12:16:26 +0000
Message-Id: <1422361031-19364-82-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 7a87e9cbc3a2f0ff0955815335e08c9862359130 upstream.

>From Documentation/devicetree/bindings/clock/imx25-clock.txt:

	cspi1_ipg		78
	cspi2_ipg		79
	cspi3_ipg		80

, so fix the SPI1 clocks accordingly to avoid a kernel hang when trying to
access SPI1.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/dts/imx25.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx25.dtsi b/arch/arm/boot/dts/imx25.dtsi
index bb74d9582b7e..37421df1686b 100644
--- a/arch/arm/boot/dts/imx25.dtsi
+++ b/arch/arm/boot/dts/imx25.dtsi
@@ -162,7 +162,7 @@
 				#size-cells = <0>;
 				compatible = "fsl,imx25-cspi", "fsl,imx35-cspi";
 				reg = <0x43fa4000 0x4000>;
-				clocks = <&clks 62>, <&clks 62>;
+				clocks = <&clks 78>, <&clks 78>;
 				clock-names = "ipg", "per";
 				interrupts = <14>;
 				status = "disabled";
-- 
2.1.4

