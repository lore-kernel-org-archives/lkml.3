Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbaCSKMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:12:30 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41517 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757582AbaCSKMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:12:21 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <balbi@ti.com>, <rogerq@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <tony@atomide.com>, <anatol.pomozov@gmail.com>,
        <bcousson@baylibre.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v5 5/5] ARM: dts: am43x-epos-evm: Enable USB
Date: Wed, 19 Mar 2014 15:40:03 +0530
Message-ID: <1395223803-4714-6-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1395223803-4714-1-git-send-email-george.cherian@ti.com>
References: <1395223803-4714-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable
	- USB PHY
	- USB

for am43x-epos-evm

Signed-off-by: George Cherian <george.cherian@ti.com>
Acked-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/am43x-epos-evm.dts | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index 167dbc8..1a4946a 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -367,3 +367,21 @@
 	pinctrl-0 = <&spi1_pins>;
 	status = "okay";
 };
+
+&usb2_phy1 {
+	status = "okay";
+};
+
+&usb1 {
+	dr_mode = "peripheral";
+	status = "okay";
+};
+
+&usb2_phy2 {
+	status = "okay";
+};
+
+&usb2 {
+	dr_mode = "host";
+	status = "okay";
+};
-- 
1.8.3.1

