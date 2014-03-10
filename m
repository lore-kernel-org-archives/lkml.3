Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaCJTSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 15:18:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51204 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753984AbaCJTRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 15:17:45 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Rodolfo Giometti <giometti@linux.it>
Subject: [PATCHv3 8/8] ARM: at91/dt: at91-cosino: remove useless adc properties
Date: Mon, 10 Mar 2014 20:17:25 +0100
Message-Id: <1394479045-31852-9-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394479045-31852-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1394479045-31852-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the properties that are not used anymore by the at91_adc driver.

Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91-cosino.dtsi         | 1 -
 arch/arm/boot/dts/at91-cosino_mega2560.dts | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91-cosino.dtsi b/arch/arm/boot/dts/at91-cosino.dtsi
index 2093c4d7cd6a..df4b78695695 100644
--- a/arch/arm/boot/dts/at91-cosino.dtsi
+++ b/arch/arm/boot/dts/at91-cosino.dtsi
@@ -64,7 +64,6 @@
 			};
 
 			adc0: adc@f804c000 {
-				atmel,adc-clock-rate = <1000000>;
 				atmel,adc-ts-wires = <4>;
 				atmel,adc-ts-pressure-threshold = <10000>;
 				status = "okay";
diff --git a/arch/arm/boot/dts/at91-cosino_mega2560.dts b/arch/arm/boot/dts/at91-cosino_mega2560.dts
index f9415dd11f17..a542d5837a17 100644
--- a/arch/arm/boot/dts/at91-cosino_mega2560.dts
+++ b/arch/arm/boot/dts/at91-cosino_mega2560.dts
@@ -27,7 +27,6 @@
 			};
 
 			adc0: adc@f804c000 {
-				atmel,adc-clock-rate = <1000000>;
 				atmel,adc-ts-wires = <4>;
 				atmel,adc-ts-pressure-threshold = <10000>;
 				status = "okay";
-- 
1.8.3.2

