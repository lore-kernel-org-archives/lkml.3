Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab3AYLNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:13:05 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56031 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757091Ab3AYLMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:12:13 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <balbi@ti.com>, <b-cousson@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <s-guiriec@ti.com>, <gg@slimlogic.co.uk>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 6/6] ARM: dts: palmas: update dt data for palmas-usb
Date: Fri, 25 Jan 2013 16:41:52 +0530
Message-ID: <1359112312-6918-7-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359112312-6918-1-git-send-email-kishon@ti.com>
References: <1359112312-6918-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update palmas-usb data node in palmas device tree file

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/palmas.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/palmas.dtsi b/arch/arm/boot/dts/palmas.dtsi
index d20adb4..0cf39da 100644
--- a/arch/arm/boot/dts/palmas.dtsi
+++ b/arch/arm/boot/dts/palmas.dtsi
@@ -318,8 +318,8 @@
 
 	palmas_usb {
 		compatible = "ti,palmas-usb";
-		ti,no_control_vbus = <0>;
-		ti,wakeup = <0>;
+		ti,wakeup;
+		vbus-supply = <&smps10_reg>;
 	};
 };
 
-- 
1.7.9.5

