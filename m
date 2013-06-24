Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab3FXKgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:36:13 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:49330 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3FXKgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:36:11 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Wenyou Yang <wenyou.yang@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        Josh Wu <josh.wu@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/3] ARM: at91/DT: sama5d3: add SPI DMA client infos
Date: Mon, 24 Jun 2013 12:35:17 +0200
Message-ID: <4a802034c6c31e37bf9b2066de01ff966cea7f29.1372069834.git.nicolas.ferre@atmel.com>
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
 arch/arm/boot/dts/sama5d3.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index 178fd09..a1d5e25 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -83,6 +83,9 @@
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xf0004000 0x100>;
 				interrupts = <24 IRQ_TYPE_LEVEL_HIGH 3>;
+				dmas = <&dma0 2 AT91_DMA_CFG_PER_ID(1)>,
+				       <&dma0 2 AT91_DMA_CFG_PER_ID(2)>;
+				dma-names = "tx", "rx";
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
 				status = "disabled";
@@ -206,6 +209,9 @@
 				compatible = "atmel,at91rm9200-spi";
 				reg = <0xf8008000 0x100>;
 				interrupts = <25 IRQ_TYPE_LEVEL_HIGH 3>;
+				dmas = <&dma1 2 AT91_DMA_CFG_PER_ID(15)>,
+				       <&dma1 2 AT91_DMA_CFG_PER_ID(16)>;
+				dma-names = "tx", "rx";
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
 				status = "disabled";
-- 
1.8.2.2

