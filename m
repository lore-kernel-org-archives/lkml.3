Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaBZRDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:03:01 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39821 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753357AbaBZRBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:01:24 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        b.brezillon@overkiz.com,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 3/7] ARM: at91/dt: at91-ariag25: remove useless adc properties
Date: Wed, 26 Feb 2014 18:01:10 +0100
Message-Id: <1393434074-15600-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393434074-15600-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1393434074-15600-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the properties that are not used anymore by the at91_adc driver.

Also, stop using unit-addresses for the triggers as suggested by Mark
Rutland in
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-February/234184.html

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
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

