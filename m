Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbaEHVpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 17:45:39 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:33649 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663AbaEHVph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 17:45:37 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>
Subject: [RESEND PATCH 5/6] ARM: ux500: add VCC and VIO regulators to STMPE IC
Date: Thu,  8 May 2014 23:45:28 +0200
Message-Id: <1399585528-5451-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a VCC and VIO regulator supplies to the the STMPE expander
found on the STUIB UIB variants.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/ste-href-stuib.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/ste-href-stuib.dtsi b/arch/arm/boot/dts/ste-href-stuib.dtsi
index 1c3574435ea8..84d7c5d883f2 100644
--- a/arch/arm/boot/dts/ste-href-stuib.dtsi
+++ b/arch/arm/boot/dts/ste-href-stuib.dtsi
@@ -42,6 +42,8 @@
 				interrupts = <26 IRQ_TYPE_EDGE_FALLING>;
 				interrupt-parent = <&gpio6>;
 				interrupt-controller;
+				vcc-supply = <&db8500_vsmps2_reg>;
+				vio-supply = <&db8500_vsmps2_reg>;
 
 				wakeup-source;
 				st,autosleep-timeout = <1024>;
-- 
1.9.0

