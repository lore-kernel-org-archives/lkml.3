Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735AbaDBRF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:05:56 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:33004 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbaDBRFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:05:48 -0400
From: stefan@agner.ch
To: shawn.guo@freescale.com, kernel@pengutronix.de, viresh.linux@gmail.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH v2 1/2] ARM: dts: mx5: fix wrong stmpe-ts bindings
Date: Wed,  2 Apr 2014 19:05:37 +0200
Message-Id: <94a8b96fe30ce97ec89e49ef6470271888024256.1396457876.git.stefan@agner.ch>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1396457876.git.stefan@agner.ch>
References: <cover.1396457876.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

Fix bindings for STMPE touchscreen controller to match the documented
bindings and the actual bindings used by the driver.

Signed-off-by: Stefan Agner <stefan@agner.ch>
Reviewed-by: Marek Vasut <marex@denx.de>
---
 arch/arm/boot/dts/imx53-m53evk.dts | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/imx53-m53evk.dts b/arch/arm/boot/dts/imx53-m53evk.dts
index 7d304d0..e97f298 100644
--- a/arch/arm/boot/dts/imx53-m53evk.dts
+++ b/arch/arm/boot/dts/imx53-m53evk.dts
@@ -165,17 +165,17 @@
 		irq-trigger = <0x1>;
 
 		stmpe_touchscreen {
-			compatible = "stmpe,ts";
+			compatible = "st,stmpe-ts";
 			reg = <0>;
-			ts,sample-time = <4>;
-			ts,mod-12b = <1>;
-			ts,ref-sel = <0>;
-			ts,adc-freq = <1>;
-			ts,ave-ctrl = <3>;
-			ts,touch-det-delay = <3>;
-			ts,settling = <4>;
-			ts,fraction-z = <7>;
-			ts,i-drive = <1>;
+			st,sample-time = <4>;
+			st,mod-12b = <1>;
+			st,ref-sel = <0>;
+			st,adc-freq = <1>;
+			st,ave-ctrl = <3>;
+			st,touch-det-delay = <3>;
+			st,settling = <4>;
+			st,fraction-z = <7>;
+			st,i-drive = <1>;
 		};
 	};
 
-- 
1.9.1

