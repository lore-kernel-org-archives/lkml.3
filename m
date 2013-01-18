Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab3ARVa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:30:56 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:47077 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab3ARVay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:30:54 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Stefan Roese <sr@denx.de>, Alejandro Mery <amery@geeks.cl>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] ARM: sunxi: Add uart1 pinctrl groups
Date: Fri, 18 Jan 2013 22:30:37 +0100
Message-Id: <1358544639-14761-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358544639-14761-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1358544639-14761-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun5i-a13.dtsi |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index 707bef5..e112189 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -24,6 +24,20 @@
 			reg = <0x01c20800 0x400>;
 			#address-cells = <1>;
 			#size-cells = <0>;
+
+			uart1_pins_a: uart1@0 {
+				allwinner,pins = "PE10", "PE11";
+				allwinner,function = "uart1";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			uart1_pins_b: uart1@1 {
+				allwinner,pins = "PG3", "PG4";
+				allwinner,function = "uart1";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
 		};
 	};
 };
-- 
1.7.10.4

