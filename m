Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936029Ab3DHM6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:58:21 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:38282 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935201Ab3DHM6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:58:19 -0400
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-arm-kernel@lists.infradead.org
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 2/3] ARM: mx28: add auart3 2 pins pinmux to imx28.dtsi
Date: Mon,  8 Apr 2013 14:57:32 +0200
Message-Id: <1365425853-12457-2-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1365425853-12457-1-git-send-email-eric@eukrea.com>
References: <1365425853-12457-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add auart3 2 pins configuration on its main pads

Signed-off-by: Eric Bénard <eric@eukrea.com>
---
 arch/arm/boot/dts/imx28.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
index 13799cf..5c45f29 100644
--- a/arch/arm/boot/dts/imx28.dtsi
+++ b/arch/arm/boot/dts/imx28.dtsi
@@ -343,6 +343,17 @@
 					fsl,pull-up = <0>;
 				};
 
+				auart3_2pins_b: auart3-2pins@1 {
+					reg = <1>;
+					fsl,pinmux-ids = <
+						0x30c0 /* MX28_PAD_AUART3_RX__AUART3_RX */
+						0x30d0 /* MX28_PAD_AUART3_TX__AUART3_TX */
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

