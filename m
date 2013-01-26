Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab3AZOhS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 09:37:18 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:51545 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3AZOhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 09:37:09 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Alejandro Mery <amery@geeks.cl>,
        Stefan Roese <sr@denx.de>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] ARM: sunxi: Add the sun4i pinctrl and gpio nodes
Date: Sat, 26 Jan 2013 15:36:54 +0100
Message-Id: <1359211016-24097-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359211016-24097-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1359211016-24097-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun4i-a10.dtsi |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index e61fdd4..73e0dd5 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -16,4 +16,13 @@
 	memory {
 		reg = <0x40000000 0x80000000>;
 	};
+
+	soc {
+		pinctrl@01c20800 {
+			compatible = "allwinner,sun4i-a10-pinctrl";
+			reg = <0x01c20800 0x400>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+	};
 };
-- 
1.7.10.4

