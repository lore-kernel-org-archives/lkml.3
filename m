Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3C0NMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:12:44 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:59817 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab3C0NMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:12:40 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: sunxi: Rename wemac functions to emac
Date: Wed, 27 Mar 2013 14:12:33 +0100
Message-Id: <1364389953-20688-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pin functions associated to the ethernet controller were introduced
with the label "wemac", which was the name of the ethernet driver in the
allwinner source tree, while the real name of the IP is actually "emac",
as advertised in several documents including the datasheet.

Since this is part of the device tree bindings, and that these part of
the bindings have not yet be released in a kernel version, it seems like
the good timing to change it and assure consistency.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/pinctrl/pinctrl-sunxi.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index 3e41cd1..5a15ce4 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -31,101 +31,101 @@ static const struct sunxi_desc_pin sun4i_a10_pins[] = {
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA0,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x2, "wemac"),		/* ERXD3 */
+		SUNXI_FUNCTION(0x2, "emac"),		/* ERXD3 */
 		SUNXI_FUNCTION(0x3, "spi1"),		/* CS0 */
 		SUNXI_FUNCTION(0x4, "uart2")),		/* RTS */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA1,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x2, "wemac"),		/* ERXD2 */
+		SUNXI_FUNCTION(0x2, "emac"),		/* ERXD2 */
 		SUNXI_FUNCTION(0x3, "spi1"),		/* CLK */
 		SUNXI_FUNCTION(0x4, "uart2")),		/* CTS */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA2,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x2, "wemac"),		/* ERXD1 */
+		SUNXI_FUNCTION(0x2, "emac"),		/* ERXD1 */
 		SUNXI_FUNCTION(0x3, "spi1"),		/* MOSI */
 		SUNXI_FUNCTION(0x4, "uart2")),		/* TX */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA3,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x2, "wemac"),		/* ERXD0 */
+		SUNXI_FUNCTION(0x2, "emac"),		/* ERXD0 */
 		SUNXI_FUNCTION(0x3, "spi1"),		/* MISO */
 		SUNXI_FUNCTION(0x4, "uart2")),		/* RX */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA4,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x2, "wemac"),		/* ETXD3 */
+		SUNXI_FUNCTION(0x2, "emac"),		/* ETXD3 */
 		SUNXI_FUNCTION(0x3, "spi1")),		/* CS1 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA5,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x2, "wemac"),		/* ETXD2 */
+		SUNXI_FUNCTION(0x2, "emac"),		/* ETXD2 */
 		SUNXI_FUNCTION(0x3, "spi3")),		/* CS0 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA6,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x2, "wemac"),		/* ETXD1 */
+		SUNXI_FUNCTION(0x2, "emac"),		/* ETXD1 */
 		SUNXI_FUNCTION(0x3, "spi3")),		/* CLK */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA7,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x2, "wemac"),		/* ETXD0 */
+		SUNXI_FUNCTION(0x2, "emac"),		/* ETXD0 */
 		SUNXI_FUNCTION(0x3, "spi3")),		/* MOSI */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA8,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x2, "wemac"),		/* ERXCK */
+		SUNXI_FUNCTION(0x2, "emac"),		/* ERXCK */
 		SUNXI_FUNCTION(0x3, "spi3")),		/* MISO */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA9,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x2, "wemac"),		/* ERXERR */
+		SUNXI_FUNCTION(0x2, "emac"),		/* ERXERR */
 		SUNXI_FUNCTION(0x3, "spi3")),		/* CS1 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA10,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x2, "wemac"),		/* ERXDV */
+		SUNXI_FUNCTION(0x2, "emac"),		/* ERXDV */
 		SUNXI_FUNCTION(0x4, "uart1")),		/* TX */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA11,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x2, "wemac"),		/* EMDC */
+		SUNXI_FUNCTION(0x2, "emac"),		/* EMDC */
 		SUNXI_FUNCTION(0x4, "uart1")),		/* RX */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA12,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x2, "wemac"),		/* EMDIO */
+		SUNXI_FUNCTION(0x2, "emac"),		/* EMDIO */
 		SUNXI_FUNCTION(0x3, "uart6"),		/* TX */
 		SUNXI_FUNCTION(0x4, "uart1")),		/* RTS */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA13,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x2, "wemac"),		/* ETXEN */
+		SUNXI_FUNCTION(0x2, "emac"),		/* ETXEN */
 		SUNXI_FUNCTION(0x3, "uart6"),		/* RX */
 		SUNXI_FUNCTION(0x4, "uart1")),		/* CTS */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA14,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x2, "wemac"),		/* ETXCK */
+		SUNXI_FUNCTION(0x2, "emac"),		/* ETXCK */
 		SUNXI_FUNCTION(0x3, "uart7"),		/* TX */
 		SUNXI_FUNCTION(0x4, "uart1")),		/* DTR */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA15,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x2, "wemac"),		/* ECRS */
+		SUNXI_FUNCTION(0x2, "emac"),		/* ECRS */
 		SUNXI_FUNCTION(0x3, "uart7"),		/* RX */
 		SUNXI_FUNCTION(0x4, "uart1")),		/* DSR */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA16,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x2, "wemac"),		/* ECOL */
+		SUNXI_FUNCTION(0x2, "emac"),		/* ECOL */
 		SUNXI_FUNCTION(0x3, "can"),		/* TX */
 		SUNXI_FUNCTION(0x4, "uart1")),		/* DCD */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA17,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x2, "wemac"),		/* ETXERR */
+		SUNXI_FUNCTION(0x2, "emac"),		/* ETXERR */
 		SUNXI_FUNCTION(0x3, "can"),		/* RX */
 		SUNXI_FUNCTION(0x4, "uart1")),		/* RING */
 	/* Hole */
-- 
1.7.10.4

