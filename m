Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaFFGTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 02:19:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49968 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbaFFGTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 02:19:34 -0400
From: George Cherian <george.cherian@ti.com>
To: <tony@atomide.com>, <bcousson@baylibre.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH] ARM: dts: am43x-epos-evm: Add Missing cpsw-phy-sel for am43x-epos-evm
Date: Fri, 6 Jun 2014 11:47:34 +0530
Message-ID: <1402035454-25676-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AM437x EPOS evm use external clock for RMII interface.
Enable the same in DT. 

Signed-off-by: George Cherian <george.cherian@ti.com>
Reported-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/am43x-epos-evm.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index 19f1f7e..90098f9 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -319,6 +319,10 @@
 	phy-mode = "rmii";
 };
 
+&phy_sel {
+	rmii-clock-ext;
+};
+
 &i2c0 {
 	status = "okay";
 	pinctrl-names = "default";
-- 
1.8.3.1

