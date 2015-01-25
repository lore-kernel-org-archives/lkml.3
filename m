Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbbAYS0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:26:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbbAYSKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 3.18 163/183] ARM: dts: imx25: Fix the SPI1 clocks
Date: Sun, 25 Jan 2015 10:08:05 -0800
Message-Id: <20150125180817.246922439@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx25.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


