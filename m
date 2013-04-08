Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936044Ab3DHM6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:58:23 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:38286 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935755Ab3DHM6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:58:21 -0400
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-arm-kernel@lists.infradead.org
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 1/3] ARM: mx28: add auart2 2 pins pinmux to imx28.dtsi
Date: Mon,  8 Apr 2013 14:57:31 +0200
Message-Id: <1365425853-12457-1-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add auart2 2 pins configuration on its main pads

Signed-off-by: Eric Bénard <eric@eukrea.com>
---
 arch/arm/boot/dts/imx28.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
index 7ba4966..13799cf 100644
--- a/arch/arm/boot/dts/imx28.dtsi
+++ b/arch/arm/boot/dts/imx28.dtsi
@@ -308,6 +308,17 @@
 					fsl,pull-up = <0>;
 				};
 
+				auart2_2pins_b: auart2-2pins@1 {
+					reg = <1>;
+					fsl,pinmux-ids = <
+						0x3080 /* MX28_PAD_AUART2_RX__AUART2_RX */
+						0x3090 /* MX28_PAD_AUART2_TX__AUART2_TX */
+					>;
+					fsl,drive-strength = <0>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <0>;
+				};
+
 				auart3_pins_a: auart3@0 {
 					reg = <0>;
 					fsl,pinmux-ids = <
-- 
1.7.11.7

