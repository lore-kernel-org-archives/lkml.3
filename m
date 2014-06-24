Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaFXKi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:38:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54301 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753129AbaFXKf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:35:27 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, p.zabel@pengutronix.de
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/12] ARM: dts: berlin: add a required reset property in the chip controller node
Date: Tue, 24 Jun 2014 12:35:13 +0200
Message-Id: <1403606121-6368-5-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The chip controller node now also describes the Marvell Berlin reset
controller. Add the required 'reset-cells' property.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2.dtsi   | 1 +
 arch/arm/boot/dts/berlin2cd.dtsi | 1 +
 arch/arm/boot/dts/berlin2q.dtsi  | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
index 2477dac4d643..97b12492675e 100644
--- a/arch/arm/boot/dts/berlin2.dtsi
+++ b/arch/arm/boot/dts/berlin2.dtsi
@@ -243,6 +243,7 @@
 		chip: chip-control@ea0000 {
 			compatible = "marvell,berlin2-chip-ctrl";
 			#clock-cells = <1>;
+			#reset-cells = <2>;
 			reg = <0xea0000 0x400>;
 			clocks = <&refclk>;
 			clock-names = "refclk";
diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
index cc1df65da504..68f7032b4686 100644
--- a/arch/arm/boot/dts/berlin2cd.dtsi
+++ b/arch/arm/boot/dts/berlin2cd.dtsi
@@ -231,6 +231,7 @@
 		chip: chip-control@ea0000 {
 			compatible = "marvell,berlin2cd-chip-ctrl";
 			#clock-cells = <1>;
+			#reset-cells = <2>;
 			reg = <0xea0000 0x400>;
 			clocks = <&refclk>;
 			clock-names = "refclk";
diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 635a16a64cb4..a6f7ec325200 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -298,6 +298,7 @@
 		chip: chip-control@ea0000 {
 			compatible = "marvell,berlin2q-chip-ctrl";
 			#clock-cells = <1>;
+			#reset-cells = <2>;
 			reg = <0xea0000 0x400>, <0xdd0170 0x10>;
 			clocks = <&refclk>;
 			clock-names = "refclk";
-- 
1.9.1

