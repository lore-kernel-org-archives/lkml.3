Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbaGZTog (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:44:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaGZTNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Vasut <marex@denx.de>, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 3.14 84/87] ARM: dts: imx: Add alias for ethernet controller
Date: Sat, 26 Jul 2014 12:02:58 -0700
Message-Id: <20140726190217.337461228@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

commit 22970070e027cbbb9b2878f8f7c31d0d7f29e94d upstream.

Add alias for FEC ethernet on i.MX to allow bootloaders (like U-Boot)
patch-in the MAC address for FEC using this alias.

Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx25.dtsi |    1 +
 arch/arm/boot/dts/imx27.dtsi |    1 +
 arch/arm/boot/dts/imx51.dtsi |    1 +
 arch/arm/boot/dts/imx53.dtsi |    1 +
 4 files changed, 4 insertions(+)

--- a/arch/arm/boot/dts/imx25.dtsi
+++ b/arch/arm/boot/dts/imx25.dtsi
@@ -30,6 +30,7 @@
 		spi2 = &spi3;
 		usb0 = &usbotg;
 		usb1 = &usbhost1;
+		ethernet0 = &fec;
 	};
 
 	cpus {
--- a/arch/arm/boot/dts/imx27.dtsi
+++ b/arch/arm/boot/dts/imx27.dtsi
@@ -30,6 +30,7 @@
 		spi0 = &cspi1;
 		spi1 = &cspi2;
 		spi2 = &cspi3;
+		ethernet0 = &fec;
 	};
 
 	aitc: aitc-interrupt-controller@e0000000 {
--- a/arch/arm/boot/dts/imx51.dtsi
+++ b/arch/arm/boot/dts/imx51.dtsi
@@ -27,6 +27,7 @@
 		spi0 = &ecspi1;
 		spi1 = &ecspi2;
 		spi2 = &cspi;
+		ethernet0 = &fec;
 	};
 
 	tzic: tz-interrupt-controller@e0000000 {
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@ -33,6 +33,7 @@
 		spi0 = &ecspi1;
 		spi1 = &ecspi2;
 		spi2 = &cspi;
+		ethernet0 = &fec;
 	};
 
 	cpus {


