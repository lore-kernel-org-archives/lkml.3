Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbaHBAzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 20:55:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbaHBAxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 20:53:13 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 03/10] ARM: dts: Prepare node labels for exynos5250
Date: Sat,  2 Aug 2014 02:52:23 +0200
Message-Id: <1406940750-15880-4-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406940750-15880-1-git-send-email-afaerber@suse.de>
References: <1406940750-15880-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows them to be extended by reference.

Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v6: Split off from Snow/SMDK cleanups (Doug Anderson)

 arch/arm/boot/dts/exynos5250.dtsi | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 834fb5a5306f..cf94aeaeaa84 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -215,7 +215,7 @@
 		clock-names = "fimg2d";
 	};
 
-	codec@11000000 {
+	mfc: codec@11000000 {
 		compatible = "samsung,mfc-v6";
 		reg = <0x11000000 0x10000>;
 		interrupts = <0 96 0>;
@@ -224,7 +224,7 @@
 		clock-names = "mfc";
 	};
 
-	rtc@101E0000 {
+	rtc: rtc@101E0000 {
 		clocks = <&clock CLK_RTC>;
 		clock-names = "rtc";
 		status = "disabled";
@@ -238,27 +238,27 @@
 		clock-names = "tmu_apbif";
 	};
 
-	serial@12C00000 {
+	uart0: serial@12C00000 {
 		clocks = <&clock CLK_UART0>, <&clock CLK_SCLK_UART0>;
 		clock-names = "uart", "clk_uart_baud0";
 	};
 
-	serial@12C10000 {
+	uart1: serial@12C10000 {
 		clocks = <&clock CLK_UART1>, <&clock CLK_SCLK_UART1>;
 		clock-names = "uart", "clk_uart_baud0";
 	};
 
-	serial@12C20000 {
+	uart2: serial@12C20000 {
 		clocks = <&clock CLK_UART2>, <&clock CLK_SCLK_UART2>;
 		clock-names = "uart", "clk_uart_baud0";
 	};
 
-	serial@12C30000 {
+	uart3: serial@12C30000 {
 		clocks = <&clock CLK_UART3>, <&clock CLK_SCLK_UART3>;
 		clock-names = "uart", "clk_uart_baud0";
 	};
 
-	sata@122F0000 {
+	sata: sata@122F0000 {
 		compatible = "snps,dwc-ahci";
 		samsung,sata-freq = <66>;
 		reg = <0x122F0000 0x1ff>;
@@ -570,7 +570,7 @@
 		#phy-cells = <1>;
 	};
 
-	usb@12110000 {
+	ehci: usb@12110000 {
 		compatible = "samsung,exynos4210-ehci";
 		reg = <0x12110000 0x100>;
 		interrupts = <0 71 0>;
@@ -585,7 +585,7 @@
 		};
 	};
 
-	usb@12120000 {
+	ohci: usb@12120000 {
 		compatible = "samsung,exynos4210-ohci";
 		reg = <0x12120000 0x100>;
 		interrupts = <0 71 0>;
@@ -722,7 +722,7 @@
 		clock-names = "gscl";
 	};
 
-	hdmi {
+	hdmi: hdmi {
 		compatible = "samsung,exynos4212-hdmi";
 		reg = <0x14530000 0x70000>;
 		interrupts = <0 95 0>;
@@ -748,14 +748,14 @@
 		#phy-cells = <0>;
 	};
 
-	dp-controller@145B0000 {
+	dp: dp-controller@145B0000 {
 		clocks = <&clock CLK_DP>;
 		clock-names = "dp";
 		phys = <&dp_phy>;
 		phy-names = "dp";
 	};
 
-	fimd@14400000 {
+	fimd: fimd@14400000 {
 		clocks = <&clock CLK_SCLK_FIMD1>, <&clock CLK_FIMD1>;
 		clock-names = "sclk_fimd", "fimd";
 	};
-- 
1.9.3

