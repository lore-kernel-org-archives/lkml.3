Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3FIQhc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 12:37:32 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56949 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab3FIQg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 12:36:26 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 3/6] pinctrl: sunxi: Add Allwinner A10s pins
Date: Sun,  9 Jun 2013 18:36:04 +0200
Message-Id: <1370795767-9769-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1370795767-9769-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1370795767-9769-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/pinctrl/pinctrl-sunxi-pins.h | 645 +++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-sunxi.c      |   1 +
 2 files changed, 646 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-sunxi-pins.h b/drivers/pinctrl/pinctrl-sunxi-pins.h
index 92c6b14..2eeae0c 100644
--- a/drivers/pinctrl/pinctrl-sunxi-pins.h
+++ b/drivers/pinctrl/pinctrl-sunxi-pins.h
@@ -1004,6 +1004,646 @@ static const struct sunxi_desc_pin sun4i_a10_pins[] = {
 		  SUNXI_FUNCTION(0x4, "hdmi")),		/* HSDA */
 };
 
+static const struct sunxi_desc_pin sun5i_a10s_pins[] = {
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA0,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "emac"),		/* ERXD3 */
+		  SUNXI_FUNCTION(0x3, "ts0"),		/* CLK */
+		  SUNXI_FUNCTION(0x5, "keypad")),	/* IN0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA1,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "emac"),		/* ERXD2 */
+		  SUNXI_FUNCTION(0x3, "ts0"),		/* ERR */
+		  SUNXI_FUNCTION(0x5, "keypad")),	/* IN1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA2,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "emac"),		/* ERXD1 */
+		  SUNXI_FUNCTION(0x3, "ts0"),		/* SYNC */
+		  SUNXI_FUNCTION(0x5, "keypad")),	/* IN2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA3,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "emac"),		/* ERXD0 */
+		  SUNXI_FUNCTION(0x3, "ts0"),		/* DLVD */
+		  SUNXI_FUNCTION(0x5, "keypad")),	/* IN3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA4,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "emac"),		/* ETXD3 */
+		  SUNXI_FUNCTION(0x3, "ts0"),		/* D0 */
+		  SUNXI_FUNCTION(0x5, "keypad")),	/* IN4 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA5,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "emac"),		/* ETXD2 */
+		  SUNXI_FUNCTION(0x3, "ts0"),		/* D1 */
+		  SUNXI_FUNCTION(0x5, "keypad")),	/* IN5 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA6,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "emac"),		/* ETXD1 */
+		  SUNXI_FUNCTION(0x3, "ts0"),		/* D2 */
+		  SUNXI_FUNCTION(0x5, "keypad")),	/* IN6 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA7,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "emac"),		/* ETXD0 */
+		  SUNXI_FUNCTION(0x3, "ts0"),		/* D3 */
+		  SUNXI_FUNCTION(0x5, "keypad")),	/* IN7 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA8,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "emac"),		/* ERXCK */
+		  SUNXI_FUNCTION(0x3, "ts0"),		/* D4 */
+		  SUNXI_FUNCTION(0x4, "uart1"),		/* DTR */
+		  SUNXI_FUNCTION(0x5, "keypad")),	/* OUT0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA9,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "emac"),		/* ERXERR */
+		  SUNXI_FUNCTION(0x3, "ts0"),		/* D5 */
+		  SUNXI_FUNCTION(0x4, "uart1"),		/* DSR */
+		  SUNXI_FUNCTION(0x5, "keypad")),	/* OUT1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA10,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "emac"),		/* ERXDV */
+		  SUNXI_FUNCTION(0x3, "ts0"),		/* D6 */
+		  SUNXI_FUNCTION(0x4, "uart1"),		/* DCD */
+		  SUNXI_FUNCTION(0x5, "keypad")),	/* OUT2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA11,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "emac"),		/* EMDC */
+		  SUNXI_FUNCTION(0x3, "ts0"),		/* D7 */
+		  SUNXI_FUNCTION(0x4, "uart1"),		/* RING */
+		  SUNXI_FUNCTION(0x5, "keypad")),	/* OUT3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA12,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "emac"),		/* EMDIO */
+		  SUNXI_FUNCTION(0x3, "uart1"),		/* TX */
+		  SUNXI_FUNCTION(0x5, "keypad")),	/* OUT4 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA13,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "emac"),		/* ETXEN */
+		  SUNXI_FUNCTION(0x3, "uart1"),		/* RX */
+		  SUNXI_FUNCTION(0x5, "keypad")),	/* OUT5 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA14,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "emac"),		/* ETXCK */
+		  SUNXI_FUNCTION(0x3, "uart1"),		/* CTS */
+		  SUNXI_FUNCTION(0x4, "uart3"),		/* TX */
+		  SUNXI_FUNCTION(0x5, "keypad")),	/* OUT6 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA15,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "emac"),		/* ECRS */
+		  SUNXI_FUNCTION(0x3, "uart1"),		/* RTS */
+		  SUNXI_FUNCTION(0x4, "uart3"),		/* RX */
+		  SUNXI_FUNCTION(0x5, "keypad")),	/* OUT7 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA16,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "emac"),		/* ECOL */
+		  SUNXI_FUNCTION(0x3, "uart2")),	/* TX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA17,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "emac"),		/* ETXERR */
+		  SUNXI_FUNCTION(0x3, "uart2"),		/* RX */
+		  SUNXI_FUNCTION_IRQ(0x6, 31)),		/* EINT31 */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB0,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2c0")),		/* SCK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB1,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2c0")),		/* SDA */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB2,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "pwm"),		/* PWM0 */
+		  SUNXI_FUNCTION_IRQ(0x6, 16)),		/* EINT16 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB3,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "ir0"),		/* TX */
+		  SUNXI_FUNCTION_IRQ(0x6, 17)),		/* EINT17 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB4,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "ir0"),		/* RX */
+		  SUNXI_FUNCTION_IRQ(0x6, 18)),		/* EINT18 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB5,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2s"),		/* MCLK */
+		  SUNXI_FUNCTION_IRQ(0x6, 19)),		/* EINT19 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB6,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2s"),		/* BCLK */
+		  SUNXI_FUNCTION_IRQ(0x6, 20)),		/* EINT20 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB7,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2s"),		/* LRCK */
+		  SUNXI_FUNCTION_IRQ(0x6, 21)),		/* EINT21 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB8,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2s"),		/* DO */
+		  SUNXI_FUNCTION_IRQ(0x6, 22)),		/* EINT22 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB9,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2s"),		/* DI */
+		  SUNXI_FUNCTION_IRQ(0x6, 23)),		/* EINT23 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB10,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "spi2"),		/* CS1 */
+		  SUNXI_FUNCTION_IRQ(0x6, 24)),		/* EINT24 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB11,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "spi2"),		/* CS0 */
+		  SUNXI_FUNCTION(0x3, "jtag"),		/* MS0 */
+		  SUNXI_FUNCTION_IRQ(0x6, 25)),		/* EINT25 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB12,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "spi2"),		/* CLK */
+		  SUNXI_FUNCTION(0x3, "jtag"),		/* CK0 */
+		  SUNXI_FUNCTION_IRQ(0x6, 26)),		/* EINT26 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB13,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "spi2"),		/* MOSI */
+		  SUNXI_FUNCTION(0x3, "jtag"),		/* DO0 */
+		  SUNXI_FUNCTION_IRQ(0x6, 27)),		/* EINT27 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB14,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "spi2"),		/* MISO */
+		  SUNXI_FUNCTION(0x3, "jtag"),		/* DI0 */
+		  SUNXI_FUNCTION_IRQ(0x6, 28)),		/* EINT28 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB15,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2c1")),		/* SCK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB16,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2c1")),		/* SDA */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB17,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2c2")),		/* SCK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB18,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "i2c2")),		/* SDA */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB19,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "uart0"),		/* TX */
+		  SUNXI_FUNCTION_IRQ(0x6, 29)),		/* EINT29 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB20,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "uart0"),		/* RX */
+		  SUNXI_FUNCTION_IRQ(0x6, 30)),		/* EINT30 */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC0,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* NWE */
+		  SUNXI_FUNCTION(0x3, "spi0")),		/* MOSI */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC1,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* NALE */
+		  SUNXI_FUNCTION(0x3, "spi0")),		/* MISO */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC2,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* NCLE */
+		  SUNXI_FUNCTION(0x3, "spi0")),		/* SCK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC3,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* NCE1 */
+		  SUNXI_FUNCTION(0x3, "spi0")),		/* CS0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC4,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0")),	/* NCE0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC5,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0")),	/* NRE */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC6,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* NRB0 */
+		  SUNXI_FUNCTION(0x3, "mmc2")),		/* CMD */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC7,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* NRB1 */
+		  SUNXI_FUNCTION(0x3, "mmc2")),		/* CLK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC8,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* NDQ0 */
+		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC9,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* NDQ1 */
+		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC10,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* NDQ2 */
+		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC11,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* NDQ3 */
+		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC12,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* NDQ4 */
+		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D4 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC13,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* NDQ5 */
+		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D5 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC14,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* NDQ6 */
+		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D6 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC15,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* NDQ7 */
+		  SUNXI_FUNCTION(0x3, "mmc2")),		/* D7 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC16,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* NWP */
+		  SUNXI_FUNCTION(0x4, "uart3")),	/* TX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC17,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* NCE2 */
+		  SUNXI_FUNCTION(0x4, "uart3")),	/* RX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC18,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* NCE3 */
+		  SUNXI_FUNCTION(0x3, "uart2"),		/* TX */
+		  SUNXI_FUNCTION(0x4, "uart3")),	/* CTS */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC19,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "nand0"),		/* NCE4 */
+		  SUNXI_FUNCTION(0x3, "uart2"),		/* RX */
+		  SUNXI_FUNCTION(0x4, "uart3")),	/* RTS */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD0,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD1,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD2,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D2 */
+		  SUNXI_FUNCTION(0x3, "uart2")),	/* TX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD3,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D3 */
+		  SUNXI_FUNCTION(0x3, "uart2")),	/* RX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD4,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D4 */
+		  SUNXI_FUNCTION(0x3, "uart2")),	/* CTS */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD5,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D5 */
+		  SUNXI_FUNCTION(0x3, "uart2")),	/* RTS */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD6,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D6 */
+		  SUNXI_FUNCTION(0x3, "emac")),		/* ECRS */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD7,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D7 */
+		  SUNXI_FUNCTION(0x3, "emac")),		/* ECOL */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD8,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D8 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD9,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D9 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD10,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D10 */
+		  SUNXI_FUNCTION(0x3, "emac")),		/* ERXD0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD11,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D11 */
+		  SUNXI_FUNCTION(0x3, "emac")),		/* ERXD1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD12,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D12 */
+		  SUNXI_FUNCTION(0x3, "emac")),		/* ERXD2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD13,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D13 */
+		  SUNXI_FUNCTION(0x3, "emac")),		/* ERXD3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD14,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D14 */
+		  SUNXI_FUNCTION(0x3, "emac")),		/* ERXCK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD15,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D15 */
+		  SUNXI_FUNCTION(0x3, "emac")),		/* ERXERR */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD16,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D16 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD17,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0")),		/* D17 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD18,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D18 */
+		  SUNXI_FUNCTION(0x3, "emac")),		/* ERXDV */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD19,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D19 */
+		  SUNXI_FUNCTION(0x3, "emac")),		/* ETXD0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD20,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D20 */
+		  SUNXI_FUNCTION(0x3, "emac")),		/* ETXD1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD21,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D21 */
+		  SUNXI_FUNCTION(0x3, "emac")),		/* ETXD2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD22,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D22 */
+		  SUNXI_FUNCTION(0x3, "emac")),		/* ETXD3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD23,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* D23 */
+		  SUNXI_FUNCTION(0x3, "emac")),		/* ETXEN */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD24,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* CLK */
+		  SUNXI_FUNCTION(0x3, "emac")),		/* ETXCK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD25,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* DE */
+		  SUNXI_FUNCTION(0x3, "emac")),		/* ETXERR */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD26,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* HSYNC */
+		  SUNXI_FUNCTION(0x3, "emac")),		/* EMDC */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD27,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "lcd0"),		/* VSYNC */
+		  SUNXI_FUNCTION(0x3, "emac")),		/* EMDIO */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE0,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x2, "ts0"),		/* CLK */
+		  SUNXI_FUNCTION(0x3, "csi0"),		/* PCK */
+		  SUNXI_FUNCTION(0x4, "spi2"),		/* CS0 */
+		  SUNXI_FUNCTION_IRQ(0x6, 14)),		/* EINT14 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE1,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x2, "ts0"),		/* ERR */
+		  SUNXI_FUNCTION(0x3, "csi0"),		/* CK */
+		  SUNXI_FUNCTION(0x4, "spi2"),		/* CLK */
+		  SUNXI_FUNCTION_IRQ(0x6, 15)),		/* EINT15 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE2,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x2, "ts0"),		/* SYNC */
+		  SUNXI_FUNCTION(0x3, "csi0"),		/* HSYNC */
+		  SUNXI_FUNCTION(0x4, "spi2")),		/* MOSI */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE3,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "ts0"),		/* DVLD */
+		  SUNXI_FUNCTION(0x3, "csi0"),		/* VSYNC */
+		  SUNXI_FUNCTION(0x4, "spi2")),		/* MISO */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE4,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "ts0"),		/* D0 */
+		  SUNXI_FUNCTION(0x3, "csi0"),		/* D0 */
+		  SUNXI_FUNCTION(0x4, "mmc2")),		/* D0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE5,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "ts0"),		/* D1 */
+		  SUNXI_FUNCTION(0x3, "csi0"),		/* D1 */
+		  SUNXI_FUNCTION(0x4, "mmc2")),		/* D1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE6,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "ts0"),		/* D2 */
+		  SUNXI_FUNCTION(0x3, "csi0"),		/* D2 */
+		  SUNXI_FUNCTION(0x4, "mmc2")),		/* D2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE7,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "ts0"),		/* D3 */
+		  SUNXI_FUNCTION(0x3, "csi0"),		/* D3 */
+		  SUNXI_FUNCTION(0x4, "mmc2")),		/* D3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE8,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "ts0"),		/* D4 */
+		  SUNXI_FUNCTION(0x3, "csi0"),		/* D4 */
+		  SUNXI_FUNCTION(0x4, "mmc2")),		/* CMD */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE9,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "ts0"),		/* D5 */
+		  SUNXI_FUNCTION(0x3, "csi0"),		/* D5 */
+		  SUNXI_FUNCTION(0x4, "mmc2")),		/* CLK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE10,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "ts0"),		/* D6 */
+		  SUNXI_FUNCTION(0x3, "csi0"),		/* D6 */
+		  SUNXI_FUNCTION(0x4, "uart1")),	/* TX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE11,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "ts0"),		/* D7 */
+		  SUNXI_FUNCTION(0x3, "csi0"),		/* D7 */
+		  SUNXI_FUNCTION(0x4, "uart1")),	/* RX */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF0,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc0"),		/* D1 */
+		  SUNXI_FUNCTION(0x4, "jtag")),		/* MS1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF1,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc0"),		/* D0 */
+		  SUNXI_FUNCTION(0x4, "jtag")),		/* DI1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF2,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc0"),		/* CLK */
+		  SUNXI_FUNCTION(0x4, "uart0")),	/* TX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF3,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc0"),		/* CMD */
+		  SUNXI_FUNCTION(0x4, "jtag")),		/* DO1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF4,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc0"),		/* D3 */
+		  SUNXI_FUNCTION(0x4, "uart0")),	/* RX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF5,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc0"),		/* D2 */
+		  SUNXI_FUNCTION(0x4, "jtag")),		/* CK1 */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG0,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x2, "gps"),		/* CLK */
+		  SUNXI_FUNCTION_IRQ(0x6, 0)),		/* EINT0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG1,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x2, "gps"),		/* SIGN */
+		  SUNXI_FUNCTION_IRQ(0x6, 1)),		/* EINT1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG2,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x2, "gps"),		/* MAG */
+		  SUNXI_FUNCTION_IRQ(0x6, 2)),		/* EINT2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG3,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc1"),		/* CMD */
+		  SUNXI_FUNCTION(0x4, "uart1"),		/* TX */
+		  SUNXI_FUNCTION_IRQ(0x6, 3)),		/* EINT3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG4,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc1"),		/* CLK */
+		  SUNXI_FUNCTION(0x4, "uart1"),		/* RX */
+		  SUNXI_FUNCTION_IRQ(0x6, 4)),		/* EINT4 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG5,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc1"),		/* DO */
+		  SUNXI_FUNCTION(0x4, "uart1"),		/* CTS */
+		  SUNXI_FUNCTION_IRQ(0x6, 5)),		/* EINT5 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG6,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc1"),		/* D1 */
+		  SUNXI_FUNCTION(0x4, "uart1"),		/* RTS */
+		  SUNXI_FUNCTION(0x5, "uart2"),		/* RTS */
+		  SUNXI_FUNCTION_IRQ(0x6, 6)),		/* EINT6 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG7,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc1"),		/* D2 */
+		  SUNXI_FUNCTION(0x5, "uart2"),		/* TX */
+		  SUNXI_FUNCTION_IRQ(0x6, 7)),		/* EINT7 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG8,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "mmc1"),		/* D3 */
+		  SUNXI_FUNCTION(0x5, "uart2"),		/* RX */
+		  SUNXI_FUNCTION_IRQ(0x6, 8)),		/* EINT8 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG9,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "spi1"),		/* CS0 */
+		  SUNXI_FUNCTION(0x3, "uart3"),		/* TX */
+		  SUNXI_FUNCTION_IRQ(0x6, 9)),		/* EINT9 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG10,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "spi1"),		/* CLK */
+		  SUNXI_FUNCTION(0x3, "uart3"),		/* RX */
+		  SUNXI_FUNCTION_IRQ(0x6, 10)),		/* EINT10 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG11,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "spi1"),		/* MOSI */
+		  SUNXI_FUNCTION(0x3, "uart3"),		/* CTS */
+		  SUNXI_FUNCTION_IRQ(0x6, 11)),		/* EINT11 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG12,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "spi1"),		/* MISO */
+		  SUNXI_FUNCTION(0x3, "uart3"),		/* RTS */
+		  SUNXI_FUNCTION_IRQ(0x6, 12)),		/* EINT12 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG13,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x2, "spi1"),		/* CS1 */
+		  SUNXI_FUNCTION(0x3, "uart3"),		/* PWM1 */
+		  SUNXI_FUNCTION(0x5, "uart2"),		/* CTS */
+		  SUNXI_FUNCTION_IRQ(0x6, 13)),		/* EINT13 */
+};
+
 static const struct sunxi_desc_pin sun5i_a13_pins[] = {
 	/* Hole */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB0,
@@ -1370,6 +2010,11 @@ static const struct sunxi_pinctrl_desc sun4i_a10_pinctrl_data = {
 	.npins = ARRAY_SIZE(sun4i_a10_pins),
 };
 
+static const struct sunxi_pinctrl_desc sun5i_a10s_pinctrl_data = {
+	.pins = sun5i_a10s_pins,
+	.npins = ARRAY_SIZE(sun5i_a10s_pins),
+};
+
 static const struct sunxi_pinctrl_desc sun5i_a13_pinctrl_data = {
 	.pins = sun5i_a13_pins,
 	.npins = ARRAY_SIZE(sun5i_a13_pins),
diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index d6af459..0a34219 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -629,6 +629,7 @@ static void sunxi_pinctrl_irq_handler(unsigned irq, struct irq_desc *desc)
 
 static struct of_device_id sunxi_pinctrl_match[] = {
 	{ .compatible = "allwinner,sun4i-a10-pinctrl", .data = (void *)&sun4i_a10_pinctrl_data },
+	{ .compatible = "allwinner,sun5i-a10s-pinctrl", .data = (void *)&sun5i_a10s_pinctrl_data },
 	{ .compatible = "allwinner,sun5i-a13-pinctrl", .data = (void *)&sun5i_a13_pinctrl_data },
 	{}
 };
-- 
1.8.3

