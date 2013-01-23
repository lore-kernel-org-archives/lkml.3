Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3AWJuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:50:23 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:34941 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3AWJuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:50:21 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <richard.genoud@gmail.com>, <linux-arm@overkiz.com>,
        <manabian@gmail.com>, <dgilbert@interlog.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Josh Wu <josh.wu@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 9/9] ARM: at91/dts: correct comment in at91sam9x5.dtsi for mii
Date: Wed, 23 Jan 2013 10:48:56 +0100
Message-ID: <8461c2f6fdd3ef0b26f931d561435df8cae2a9a5.1358934163.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1358934163.git.nicolas.ferre@atmel.com>
References: <cover.1358934163.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Douglas Gilbert <dgilbert@interlog.com>

Concerning pinctrl_macb0_rmii_mii, values were okay, but not comments.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9x5.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index cb711a5..8ecca69 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -260,14 +260,14 @@
 
 					pinctrl_macb0_rmii_mii: macb0_rmii_mii-0 {
 						atmel,pins =
-							<1 8 0x1 0x0	/* PA8 periph A */
-							 1 11 0x1 0x0	/* PA11 periph A */
-							 1 12 0x1 0x0	/* PA12 periph A */
-							 1 13 0x1 0x0	/* PA13 periph A */
-							 1 14 0x1 0x0	/* PA14 periph A */
-							 1 15 0x1 0x0	/* PA15 periph A */
-							 1 16 0x1 0x0	/* PA16 periph A */
-							 1 17 0x1 0x0>;	/* PA17 periph A */
+							<1 8 0x1 0x0	/* PB8 periph A */
+							 1 11 0x1 0x0	/* PB11 periph A */
+							 1 12 0x1 0x0	/* PB12 periph A */
+							 1 13 0x1 0x0	/* PB13 periph A */
+							 1 14 0x1 0x0	/* PB14 periph A */
+							 1 15 0x1 0x0	/* PB15 periph A */
+							 1 16 0x1 0x0	/* PB16 periph A */
+							 1 17 0x1 0x0>;	/* PB17 periph A */
 					};
 				};
 
-- 
1.8.0

