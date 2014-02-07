Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbaBGLs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:48:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41664 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbaBGLsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 058/233] ARM: at91: at91sam9g45: set default mmc pinctrl-names
Date: Fri,  7 Feb 2014 11:44:37 +0000
Message-Id: <1391773652-25214-59-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ludovic Desroches <ludovic.desroches@atmel.com>

commit 0645b93f6c223b594c0dca348e2ae0a23bccf6e3 upstream.

pinctrl-names property was missing from mmc nodes.

Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/dts/at91sam9g45.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index c3e5148..cf7de80 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -618,6 +618,7 @@
 				compatible = "atmel,hsmci";
 				reg = <0xfff80000 0x600>;
 				interrupts = <11 IRQ_TYPE_LEVEL_HIGH 0>;
+				pinctrl-names = "default";
 				dmas = <&dma 1 AT91_DMA_CFG_PER_ID(0)>;
 				dma-names = "rxtx";
 				#address-cells = <1>;
@@ -629,6 +630,7 @@
 				compatible = "atmel,hsmci";
 				reg = <0xfffd0000 0x600>;
 				interrupts = <29 IRQ_TYPE_LEVEL_HIGH 0>;
+				pinctrl-names = "default";
 				dmas = <&dma 1 AT91_DMA_CFG_PER_ID(13)>;
 				dma-names = "rxtx";
 				#address-cells = <1>;
-- 
1.8.3.2

