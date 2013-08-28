Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab3H1LDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:03:10 -0400
Received: from 8.mo3.mail-out.ovh.net ([87.98.172.249]:43867 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751936Ab3H1LDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:03:07 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Joachim Eastwood <manabian@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: [PATCH 1/9] ARM: at91/dt: add rm9200 spi0 chip select pins definitions
Date: Wed, 28 Aug 2013 13:02:22 +0200
Message-Id: <1377687742-10618-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com>
References: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 15618202033942853856
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add spi0 cs pinctrl pins definitions.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91rm9200.dtsi |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/at91rm9200.dtsi b/arch/arm/boot/dts/at91rm9200.dtsi
index f770655..69b76c7 100644
--- a/arch/arm/boot/dts/at91rm9200.dtsi
+++ b/arch/arm/boot/dts/at91rm9200.dtsi
@@ -486,6 +486,26 @@
 							 AT91_PIOA 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA1 periph A SPI0_MOSI pin */
 							 AT91_PIOA 2 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PA2 periph A SPI0_SPCK pin */
 					};
+
+					pinctrl_spi0_cs0: spi0_cs0-0 {
+						atmel,pins =
+							<AT91_PIOA 3 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PA3 periph A SPI0_NPCS0 pin */
+					};
+
+					pinctrl_spi0_cs1: spi0_cs1-0 {
+						atmel,pins =
+							<AT91_PIOA 4 AT91_PERIPH_GPIO AT91_PINCTRL_MULTI_DRIVE>;	/* PA4 GPIO SPI0_NPCS1 pin */
+					};
+
+					pinctrl_spi0_cs2: spi0_cs2-0 {
+						atmel,pins =
+							<AT91_PIOA 5 AT91_PERIPH_GPIO AT91_PINCTRL_MULTI_DRIVE>;	/* PA5 GPIO SPI0_NPCS2 pin */
+					};
+
+					pinctrl_spi0_cs3: spi0_cs3-0 {
+						atmel,pins =
+							<AT91_PIOA 6 AT91_PERIPH_GPIO AT91_PINCTRL_MULTI_DRIVE>;	/* PA6 GPIO SPI0_NPCS3 pin */
+					};
 				};
 
 				pioA: gpio@fffff400 {
-- 
1.7.9.5

