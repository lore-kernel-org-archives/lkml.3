Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161489AbaDQNkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:40:03 -0400
Received: from mail.data-modul.de ([212.184.205.171]:56977 "HELO
	mailgw1.data-modul.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754753AbaDQNkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:40:01 -0400
From: Silvio Fricke <silvio.fricke@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: Silvio Fricke <silvio.fricke@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com
Subject: [PATCH] ARM: dts: imx6: edmqmx6: add vcc and vio power supplies to stmpe
Date: Thu, 17 Apr 2014 15:28:06 +0200
Message-Id: <a6a34db97a1cdcc21d0a7675d8ee31eb9bced399.1397741024.git.silvio.fricke@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1397741024.git.silvio.fricke@gmail.com>
References: <cover.1397741024.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1397741024.git.silvio.fricke@gmail.com>
References: <20140417061136.GD11602@dragon> <cover.1397741024.git.silvio.fricke@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Silvio Fricke <silvio.fricke@gmail.com>
---
 arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts b/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts
index e4ae38f..8fa08aa 100644
--- a/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts
+++ b/arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts
@@ -216,6 +216,8 @@
 		reg = <0x40>;
 		interrupts = <30 0>;
 		interrupt-parent = <&gpio3>;
+		vcc-supply = <&sw2_reg>;
+		vio-supply = <&sw2_reg>;
 
 		stmpe_gpio1: stmpe_gpio {
 			#gpio-cells = <2>;
@@ -228,6 +230,8 @@
 		reg = <0x44>;
 		interrupts = <2 0>;
 		interrupt-parent = <&gpio5>;
+		vcc-supply = <&sw2_reg>;
+		vio-supply = <&sw2_reg>;
 
 		stmpe_gpio2: stmpe_gpio {
 			#gpio-cells = <2>;
-- 
1.9.1

