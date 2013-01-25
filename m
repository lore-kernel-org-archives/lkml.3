Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab3AYIyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:54:45 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:46527 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3AYIyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:54:21 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Brian Lilly <brian@crystalfontz.com>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ARM: dts: mxs: Add muxing options for the third PWM
Date: Fri, 25 Jan 2013 09:54:06 +0100
Message-Id: <1359104048-26823-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359104048-26823-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1359104048-26823-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/imx28.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
index 13b7053..7ba4966 100644
--- a/arch/arm/boot/dts/imx28.dtsi
+++ b/arch/arm/boot/dts/imx28.dtsi
@@ -502,6 +502,16 @@
 					fsl,pull-up = <0>;
 				};
 
+				pwm3_pins_b: pwm3@1 {
+					reg = <1>;
+					fsl,pinmux-ids = <
+						0x3141 /* MX28_PAD_SAIF0_MCLK__PWM3 */
+					>;
+					fsl,drive-strength = <0>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <0>;
+				};
+
 				pwm4_pins_a: pwm4@0 {
 					reg = <0>;
 					fsl,pinmux-ids = <
-- 
1.7.10.4

