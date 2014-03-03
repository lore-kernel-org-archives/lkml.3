Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaCCNzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 08:55:44 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53734 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbaCCNzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 08:55:37 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: <anatol.pomozov@gmail.com>, <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <rogerq@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <bcousson@baylibre.com>, <tony@atomide.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 3/5] ARM: dts: am437x-gp-evm: Enable USB
Date: Mon, 3 Mar 2014 19:23:52 +0530
Message-ID: <1393854834-23810-4-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393854834-23810-1-git-send-email-george.cherian@ti.com>
References: <1393854834-23810-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable
	- ocp2scp
	- USB PHY control module
	- USB PHY
	- dwc3_omap
	- USB
for am437x-gp-evm

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 arch/arm/boot/dts/am437x-gp-evm.dts | 44 +++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am437x-gp-evm.dts
index 4eb72b8..89e08cd 100644
--- a/arch/arm/boot/dts/am437x-gp-evm.dts
+++ b/arch/arm/boot/dts/am437x-gp-evm.dts
@@ -98,3 +98,47 @@
 &gpio4 {
 	status = "okay";
 };
+
+&am43xx_control_usb2phy1 {
+	status = "okay";
+};
+
+&ocp2scp0 {
+	status = "okay";
+};
+
+&usb2_phy1 {
+	status = "okay";
+};
+
+&dwc3_1 {
+	status = "okay";
+};
+
+&usb1 {
+	dr_mode = "peripheral";
+	maximum-speed = "high-speed";
+	status = "okay";
+};
+
+&am43xx_control_usb2phy2 {
+	status = "okay";
+};
+
+&ocp2scp1 {
+	status = "okay";
+};
+
+&usb2_phy2 {
+	status = "okay";
+};
+
+&dwc3_2 {
+	status = "okay";
+};
+
+&usb2 {
+	dr_mode = "host";
+	maximum-speed = "high-speed";
+	status = "okay";
+};
-- 
1.8.3.1

