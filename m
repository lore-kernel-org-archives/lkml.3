Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161687AbaDPOpC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:45:02 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:34640 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161518AbaDPOo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:44:58 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Silvio F <silvio.fricke@gmail.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5/6] ARM: ux500: add VCC and VIO regulators to STMPE IC
Date: Wed, 16 Apr 2014 16:44:14 +0200
Message-Id: <1397659455-13638-6-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
References: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
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

