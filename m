Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab3FRIxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:53:13 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:48015 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab3FRIwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:52:12 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/3] ARM: ux500: Provide a AB8500 GPIO Device Tree node
Date: Tue, 18 Jun 2013 09:51:57 +0100
Message-Id: <1371545519-27119-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371545519-27119-1-git-send-email-lee.jones@linaro.org>
References: <1371545519-27119-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we're adding a node for the AB8500 GPIO device. This will allow
other DT:ed components to obtain GPIOs for use within their drivers.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index a082f0b..a152945 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -360,6 +360,11 @@
 				interrupt-controller;
 				#interrupt-cells = <2>;
 
+				ab8500_gpio: ab8500-gpio {
+					gpio-controller;
+					#gpio-cells = <2>;
+				};
+
 				ab8500-rtc {
 					compatible = "stericsson,ab8500-rtc";
 					interrupts = <17 IRQ_TYPE_LEVEL_HIGH
-- 
1.8.1.2

