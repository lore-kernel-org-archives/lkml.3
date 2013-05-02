Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab3EBKqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:46:16 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:34572 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693Ab3EBKqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:46:10 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org, Wolfram Sang <w.sang@pengutronix.de>
Cc: Emilio Lopez <emilio@elopez.com.ar>, linux-i2c@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] ARM: sun4i: dt: Add i2c muxing options
Date: Thu,  2 May 2013 12:45:55 +0200
Message-Id: <1367491557-6027-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367491557-6027-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1367491557-6027-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c controller found on the Allwinner A10 has only one muxing option
available for each controller. Add them to the dtsi

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun4i-a10.dtsi | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index 311dcd4..63f6716 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -199,6 +199,27 @@
 				allwinner,drive = <0>;
 				allwinner,pull = <0>;
 			};
+
+			i2c0_pins_a: i2c0@0 {
+				allwinner,pins = "PB0", "PB1";
+				allwinner,function = "i2c0";
+				allwinner,drive = <0>;
+				allwinner,pull = <1>;
+			};
+
+			i2c1_pins_a: i2c1@0 {
+				allwinner,pins = "PB18", "PB19";
+				allwinner,function = "i2c1";
+				allwinner,drive = <0>;
+				allwinner,pull = <1>;
+			};
+
+			i2c2_pins_a: i2c2@0 {
+				allwinner,pins = "PB20", "PB21";
+				allwinner,function = "i2c2";
+				allwinner,drive = <0>;
+				allwinner,pull = <1>;
+			};
 		};
 
 		timer@01c20c00 {
-- 
1.8.1.2

