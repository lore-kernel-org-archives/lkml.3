Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaCGJSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:18:06 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:32905 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbaCGJSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:18:02 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <balbi@ti.com>, <rogerq@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <tony@atomide.com>, <anatol.pomozov@gmail.com>,
        <bcousson@baylibre.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 4/5] ARM: dts: am437x-gp-evm: Enable USB
Date: Fri, 7 Mar 2014 14:45:57 +0530
Message-ID: <1394183758-3821-5-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1394183758-3821-1-git-send-email-george.cherian@ti.com>
References: <1394183758-3821-1-git-send-email-george.cherian@ti.com>
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
 arch/arm/boot/dts/am437x-gp-evm.dts | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am437x-gp-evm.dts
index 4eb72b8..1d516a7 100644
--- a/arch/arm/boot/dts/am437x-gp-evm.dts
+++ b/arch/arm/boot/dts/am437x-gp-evm.dts
@@ -98,3 +98,31 @@
 &gpio4 {
 	status = "okay";
 };
+
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
+	status = "okay";
+};
+
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
+	status = "okay";
+};
-- 
1.8.3.1

