Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaBVVmF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 16:42:05 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44131 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752477AbaBVVkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 16:40:06 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-sunxi@googlegroups.com, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 6/7] ARM: dt: sun7i: Add SPI muxing options
Date: Sat, 22 Feb 2014 22:35:58 +0100
Message-Id: <1393104959-12831-7-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393104959-12831-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1393104959-12831-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 0f0ee58..6161fd8 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -571,6 +571,20 @@
 				allwinner,drive = <3>;
 				allwinner,pull = <0>;
 			};
+
+			spi1_pins_a: spi1@0 {
+				allwinner,pins = "PI16", "PI17", "PI18", "PI19";
+				allwinner,function = "spi1";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			spi2_pins_a: spi2@0 {
+				allwinner,pins = "PC19", "PC20", "PC21", "PC22";
+				allwinner,function = "spi2";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
 		};
 
 		timer@01c20c00 {
-- 
1.9.0

