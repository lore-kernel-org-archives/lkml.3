Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaHQD4Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 23:56:25 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:58655 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaHQDya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 23:54:30 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] ARM: dts: sun8i: ippo-q8h: Add pinctrl properties for R_UART
Date: Sun, 17 Aug 2014 11:52:11 +0800
Message-Id: <1408247538-16950-6-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408247538-16950-1-git-send-email-wens@csie.org>
References: <1408247538-16950-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have R_PIO controller support and the pinmux for R_UART,
add the correct pinctrl properties to the R_UART node.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts b/arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts
index 34002e3..224f53e 100644
--- a/arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts
+++ b/arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts
@@ -24,6 +24,8 @@
 
 	soc@01c00000 {
 		r_uart: serial@01f02800 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&r_uart_pins_a>;
 			status = "okay";
 		};
 	};
-- 
2.1.0

