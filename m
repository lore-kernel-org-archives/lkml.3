Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab3FKSqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:46:09 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:48318 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab3FKSqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:46:07 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Christian Daudt <csd@broadcom.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Cc: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH] ARM: dts: bcm281xx: change comment to C89 style
Date: Tue, 11 Jun 2013 14:45:58 -0400
Message-Id: <1370976358-18014-1-git-send-email-matt.porter@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CodingStyle does not allow C99 style comments. Since the
dts files live in the kernel for now, make this compliant.

Signed-off-by: Matt Porter <matt.porter@linaro.org>
Acked-by: Christian Daudt <csd@broadcom.com>
---
 arch/arm/boot/dts/bcm11351.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
index 824bebe..0651a72 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -36,7 +36,7 @@
 
 	smc@0x3404c000 {
 		compatible = "bcm,bcm11351-smc", "bcm,kona-smc";
-		reg = <0x3404c000 0x400>; //1 KiB in SRAM
+		reg = <0x3404c000 0x400>; /* 1 KiB in SRAM */
 	};
 
 	uart@3e000000 {
-- 
1.7.9.5

