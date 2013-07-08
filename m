Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab3GHNab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:30:31 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:55131 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3GHNaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:30:22 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Mark Brown <broonie@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: Bo Shen <voice.shen@atmel.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        devicetree-discuss@lists.ozlabs.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH v2 2/5] ARM: AT91: DTS: sam9x5: add SSC DMA parameters
Date: Mon,  8 Jul 2013 15:29:50 +0200
Message-Id: <1373290193-25300-3-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com>
References: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 arch/arm/boot/dts/at91sam9x5.dtsi |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 57d45f5..cf78ac0 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -542,6 +542,9 @@
 				compatible = "atmel,at91sam9g45-ssc";
 				reg = <0xf0010000 0x4000>;
 				interrupts = <28 IRQ_TYPE_LEVEL_HIGH 5>;
+				dmas = <&dma0 1 AT91_DMA_CFG_PER_ID(13)>,
+				       <&dma0 1 AT91_DMA_CFG_PER_ID(14)>;
+				dma-names = "tx", "rx";
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
 				status = "disabled";
-- 
1.7.10.4

