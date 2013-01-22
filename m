Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab3AVRvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:51:06 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:55326 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab3AVRvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:51:03 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <richard.genoud@gmail.com>, <linux-arm@overkiz.com>,
        <manabian@gmail.com>, <dgilbert@interlog.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Josh Wu <josh.wu@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/6] ARM: at91/at91-pinctrl documentation: fix typo and add some details
Date: Tue, 22 Jan 2013 18:50:41 +0100
Message-ID: <78cd1baa823719d7f07f051528eb83e0f902b6ed.1358876553.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1358876553.git.nicolas.ferre@atmel.com>
References: <cover.1358876553.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Genoud <richard.genoud@gmail.com>

The relation between PIN_BANK numbers and pio letters wasn't made very
clear.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
index 3a26812..bc50899 100644
--- a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
@@ -81,7 +81,8 @@ PA31	TXD4
 Required properties for pin configuration node:
 - atmel,pins: 4 integers array, represents a group of pins mux and config
   setting. The format is atmel,pins = <PIN_BANK PIN_BANK_NUM PERIPH CONFIG>.
-  The PERIPH 0 means gpio.
+  The PERIPH 0 means gpio, PERIPH 1 is periph A, PERIPH 2 is periph B...
+  PIN_BANK 0 is pioA, PIN_BANK 1 is pioB...
 
 Bits used for CONFIG:
 PULL_UP		(1 << 0): indicate this pin need a pull up.
@@ -126,7 +127,7 @@ pinctrl@fffff400 {
 		pinctrl_dbgu: dbgu-0 {
 			atmel,pins =
 				<1 14 0x1 0x0	/* PB14 periph A */
-				 1 15 0x1 0x1>;	/* PB15 periph with pullup */
+				 1 15 0x1 0x1>;	/* PB15 periph A with pullup */
 		};
 	};
 };
-- 
1.8.0

