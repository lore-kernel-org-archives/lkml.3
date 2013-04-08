Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936069Ab3DHM6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:58:35 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:38296 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935755Ab3DHM6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:58:32 -0400
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-arm-kernel@lists.infradead.org
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 3/3] ARM: mx28: add auart4 2 pins pinmux to imx28.dtsi
Date: Mon,  8 Apr 2013 14:57:33 +0200
Message-Id: <1365425853-12457-3-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1365425853-12457-1-git-send-email-eric@eukrea.com>
References: <1365425853-12457-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add auart4 2 pins configuration on SSP3 pads

Signed-off-by: Eric Bénard <eric@eukrea.com>
---
 arch/arm/boot/dts/imx28.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
index 5c45f29..25f2243 100644
--- a/arch/arm/boot/dts/imx28.dtsi
+++ b/arch/arm/boot/dts/imx28.dtsi
@@ -354,6 +354,17 @@
 					fsl,pull-up = <0>;
 				};
 
+				auart4_2pins_a: auart4@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
+						0x2181 /* MX28_PAD_SSP3_SCK__AUART4_TX */
+						0x2191 /* MX28_PAD_SSP3_MOSI__AUART4_RX */
+					>;
+					fsl,drive-strength = <0>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <0>;
+				};
+
 				mac0_pins_a: mac0@0 {
 					reg = <0>;
 					fsl,pinmux-ids = <
-- 
1.7.11.7

