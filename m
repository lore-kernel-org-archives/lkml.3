Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaCJTUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 15:20:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51184 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753932AbaCJTRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 15:17:41 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCHv3 3/8] ARM: at91/dt: at91-ariag25: remove useless adc properties
Date: Mon, 10 Mar 2014 20:17:20 +0100
Message-Id: <1394479045-31852-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394479045-31852-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1394479045-31852-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the properties that are not used anymore by the at91_adc driver.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
---
 arch/arm/boot/dts/at91-ariag25.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91-ariag25.dts b/arch/arm/boot/dts/at91-ariag25.dts
index cce45f5177f9..55ab6180e350 100644
--- a/arch/arm/boot/dts/at91-ariag25.dts
+++ b/arch/arm/boot/dts/at91-ariag25.dts
@@ -129,7 +129,6 @@
 			adc0: adc@f804c000 {
 				status = "okay";
 				atmel,adc-channels-used = <0xf>;
-				atmel,adc-num-channels = <4>;
 			};
 
 			dbgu: serial@fffff200 {
-- 
1.8.3.2

