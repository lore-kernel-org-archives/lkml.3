Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab3BAHIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 02:08:05 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:8028 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225Ab3BAHHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 02:07:55 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, fabio.porcedda@gmail.com,
        JM.Lin@atmel.com, wenyou.yang@atmel.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 8/8] ARM: dts: add the watchdog nodes for at91sam9g25ek and at91sam9m10g45ek boards
Date: Fri,  1 Feb 2013 15:06:26 +0800
Message-Id: <1359702386-21284-9-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359702386-21284-1-git-send-email-wenyou.yang@atmel.com>
References: <1359702386-21284-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 01 Feb 2013 07:07:31.0856 (UTC) FILETIME=[CDACD900:01CE004A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested on the at91sam9g25ek and at91sam9m10g45ek boards

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/at91sam9m10g45ek.dts |    4 ++++
 arch/arm/boot/dts/at91sam9x5ek.dtsi    |    4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9m10g45ek.dts b/arch/arm/boot/dts/at91sam9m10g45ek.dts
index 20c3191..0832c7a 100644
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
diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi b/arch/arm/boot/dts/at91sam9x5ek.dtsi
index 8a7cf1d..afddf75 100644
--- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
@@ -69,6 +69,10 @@
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

