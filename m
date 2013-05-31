Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab3EaDNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 23:13:24 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:3387 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3EaDNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 23:13:18 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <wim@iguana.be>, <linux@arm.linux.org.uk>, <nicolas.ferre@atmel.com>,
        <plagnioj@jcrosoft.com>, <ludovic.desroches@atmel.com>,
        <richard.genoud@gmail.com>, <linux-kernel@vger.kernel.org>,
        <wenyou.yang@atmel.com>, <jm.lin@atmel.com>
Subject: [PATCH 2/2] ARM: dts: add the watchdog nodes for at91 boards
Date: Fri, 31 May 2013 11:11:33 +0800
Message-ID: <1369969893-7992-2-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369969893-7992-1-git-send-email-wenyou.yang@atmel.com>
References: <1369969744-3428-1-git-send-email-wenyou.yang@atmel.com>
 <1369969893-7992-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

boards include:
at91sam9263ek, at91sam9g20ek, at91sam9m10g45ek, at91sam9n12ek, at91sam9x5ek

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 arch/arm/boot/dts/at91sam9263ek.dts         |    4 ++++
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi |    4 ++++
 arch/arm/boot/dts/at91sam9m10g45ek.dts      |    4 ++++
 arch/arm/boot/dts/at91sam9n12ek.dts         |    4 ++++
 arch/arm/boot/dts/at91sam9x5ek.dtsi         |    4 ++++
 5 files changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9263ek.dts b/arch/arm/boot/dts/at91sam9263ek.dts
index 3b82d91..9143842 100644
--- a/arch/arm/boot/dts/at91sam9263ek.dts
+++ b/arch/arm/boot/dts/at91sam9263ek.dts
@@ -89,6 +89,10 @@
 					reg = <0>;
 				};
 			};
+
+			watchdog@fffffd40 {
+				status = "okay";
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
index 6a92c5b..6d6b888 100644
--- a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
@@ -106,6 +106,10 @@
 					reg = <1>;
 				};
 			};
+
+			watchdog@fffffd40 {
+				status = "okay";
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9m10g45ek.dts b/arch/arm/boot/dts/at91sam9m10g45ek.dts
index 51d9251b5..03f391a 100644
--- a/arch/arm/boot/dts/at91sam9m10g45ek.dts
+++ b/arch/arm/boot/dts/at91sam9m10g45ek.dts
@@ -59,6 +59,10 @@
 				status = "okay";
 			};
 
+			watchdog@fffffd40 {
+				status = "okay";
+			};
+
 			mmc0: mmc@fff80000 {
 				pinctrl-0 = <
 					&pinctrl_board_mmc0
diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts b/arch/arm/boot/dts/at91sam9n12ek.dts
index d30e48b..32e073f 100644
--- a/arch/arm/boot/dts/at91sam9n12ek.dts
+++ b/arch/arm/boot/dts/at91sam9n12ek.dts
@@ -77,6 +77,10 @@
 					reg = <0>;
 				};
 			};
+
+			watchdog@fffffe40 {
+				status = "okay";
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi b/arch/arm/boot/dts/at91sam9x5ek.dtsi
index 1fa48d2..e60b05a 100644
--- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
@@ -56,6 +56,10 @@
 				status = "okay";
 			};
 
+			watchdog@fffffe40 {
+				status = "okay";
+			};
+
 			pinctrl@fffff400 {
 				mmc0 {
 					pinctrl_board_mmc0: mmc0-board {
-- 
1.7.9.5

