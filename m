Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab3GKQQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:16:52 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:54784 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab3GKQQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:16:50 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Mark Brown <broonie@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: Bo Shen <voice.shen@atmel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH v5 4/7] ARM: AT91: DTS: sam9x5: add SSC DMA parameters
Date: Thu, 11 Jul 2013 18:15:56 +0200
Message-Id: <1373559359-31607-5-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373559359-31607-1-git-send-email-richard.genoud@gmail.com>
References: <1373559359-31607-1-git-send-email-richard.genoud@gmail.com>
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

