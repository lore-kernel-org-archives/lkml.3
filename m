Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab3FXKgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:36:35 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:49420 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab3FXKgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:36:33 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Wenyou Yang <wenyou.yang@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        Josh Wu <josh.wu@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/3] ARM: at91/DT: at91sam9n12: add SPI DMA client infos
Date: Mon, 24 Jun 2013 12:35:18 +0200
Message-ID: <0db25022e463d6be2111e5dc3505faaf63f9cdc9.1372069834.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1372069834.git.nicolas.ferre@atmel.com>
References: <cover.1372069834.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9n12.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index 973bf5f..bb7f564 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -492,6 +492,9 @@
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xf0000000 0x100>;
 				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 3>;
+				dmas = <&dma 1 AT91_DMA_CFG_PER_ID(1)>,
+				       <&dma 1 AT91_DMA_CFG_PER_ID(2)>;
+				dma-names = "tx", "rx";
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
 				status = "disabled";
@@ -503,6 +506,9 @@
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xf0004000 0x100>;
 				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 3>;
+				dmas = <&dma 1 AT91_DMA_CFG_PER_ID(3)>,
+				       <&dma 1 AT91_DMA_CFG_PER_ID(4)>;
+				dma-names = "tx", "rx";
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
 				status = "disabled";
-- 
1.8.2.2

