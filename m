Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934380Ab3GWWZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:25:58 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51713 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934308Ab3GWWZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:25:31 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, albert.u.boot@aribaud.net,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 07/10] pinctrl: sunxi: Add Allwinner A31 pins set
Date: Wed, 24 Jul 2013 00:25:09 +0200
Message-Id: <1374618312-19001-8-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A31 SoC uses the same IP than the one found in the
A10/A13, with only different pins. Add the pins and the associated
functions found in the A31.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/pinctrl/pinctrl-sunxi-pins.h | 820 +++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-sunxi.c      |   1 +
 2 files changed, 821 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-sunxi-pins.h b/drivers/pinctrl/pinctrl-sunxi-pins.h
index 2eeae0c..5b783cb 100644
--- a/drivers/pinctrl/pinctrl-sunxi-pins.h
+++ b/drivers/pinctrl/pinctrl-sunxi-pins.h
@@ -2005,6 +2005,821 @@ static const struct sunxi_desc_pin sun5i_a13_pins[] = {
 		  SUNXI_FUNCTION_IRQ(0x6, 12)),		/* EINT12 */
 };
 
+static const struct sunxi_desc_pin sun6i_a31_pins[] = {
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA0,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* TXD0 */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* D0 */
+		SUNXI_FUNCTION(0x4, "uart1")),		/* DTR */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA1,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* TXD1 */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* D1 */
+		SUNXI_FUNCTION(0x4, "uart1")),		/* DSR */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA2,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* TXD2 */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* D2 */
+		SUNXI_FUNCTION(0x4, "uart1")),		/* DCD */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA3,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* TXD3 */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* D3 */
+		SUNXI_FUNCTION(0x4, "uart1")),		/* RING */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA4,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* TXD4 */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* D4 */
+		SUNXI_FUNCTION(0x4, "uart1")),		/* TX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA5,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* TXD5 */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* D5 */
+		SUNXI_FUNCTION(0x4, "uart1")),		/* RX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA6,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* TXD6 */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* D6 */
+		SUNXI_FUNCTION(0x4, "uart1")),		/* RTS */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA7,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* TXD7 */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* D7 */
+		SUNXI_FUNCTION(0x4, "uart1")),		/* CTS */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA8,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* TXCLK */
+		SUNXI_FUNCTION(0x3, "lcd1")),		/* D8 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA9,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* TXEN */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* D9 */
+		SUNXI_FUNCTION(0x4, "mmc3"),		/* CMD */
+		SUNXI_FUNCTION(0x5, "mmc2")),		/* CMD */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA10,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* GTXCLK */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* D10 */
+		SUNXI_FUNCTION(0x4, "mmc3"),		/* CLK */
+		SUNXI_FUNCTION(0x5, "mmc2")),		/* CLK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA11,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* RXD0 */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* D11 */
+		SUNXI_FUNCTION(0x4, "mmc3"),		/* D0 */
+		SUNXI_FUNCTION(0x5, "mmc2")),		/* D0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA12,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* RXD1 */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* D12 */
+		SUNXI_FUNCTION(0x4, "mmc3"),		/* D1 */
+		SUNXI_FUNCTION(0x5, "mmc2")),		/* D1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA13,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* RXD2 */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* D13 */
+		SUNXI_FUNCTION(0x4, "mmc3"),		/* D2 */
+		SUNXI_FUNCTION(0x5, "mmc2")),		/* D2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA14,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* RXD3 */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* D14 */
+		SUNXI_FUNCTION(0x4, "mmc3"),		/* D3 */
+		SUNXI_FUNCTION(0x5, "mmc2")),		/* D3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA15,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* RXD4 */
+		SUNXI_FUNCTION(0x3, "lcd1")),		/* D15 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA16,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* RXD5 */
+		SUNXI_FUNCTION(0x3, "lcd1")),		/* D16 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA17,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* RXD6 */
+		SUNXI_FUNCTION(0x3, "lcd1")),		/* D17 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA18,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* RXD7 */
+		SUNXI_FUNCTION(0x3, "lcd1")),		/* D18 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA19,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* RXDV */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* D19 */
+		SUNXI_FUNCTION(0x4, "pwm3")),		/* Positive */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA20,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* RXCLK */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* D20 */
+		SUNXI_FUNCTION(0x4, "pwm3")),		/* Negative */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA21,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* TXERR */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* D21 */
+		SUNXI_FUNCTION(0x4, "spi3")),		/* CS0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA22,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* RXERR */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* D22 */
+		SUNXI_FUNCTION(0x4, "spi3")),		/* CLK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA23,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* COL */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* D23 */
+		SUNXI_FUNCTION(0x4, "spi3")),		/* MOSI */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA24,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* CRS */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* CLK */
+		SUNXI_FUNCTION(0x4, "spi3")),		/* MISO */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA25,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* CLKIN */
+		SUNXI_FUNCTION(0x3, "lcd1"),		/* DE */
+		SUNXI_FUNCTION(0x4, "spi3")),		/* CS1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA26,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* MDC */
+		SUNXI_FUNCTION(0x3, "lcd1")),		/* HSYNC */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PA27,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "gmac"),		/* MDIO */
+		SUNXI_FUNCTION(0x3, "lcd1")),		/* VSYNC */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB0,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2s0"),		/* MCLK */
+		SUNXI_FUNCTION(0x3, "uart3"),		/* CTS */
+		SUNXI_FUNCTION(0x4, "csi")),		/* MCLK1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB1,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2s0")),		/* BCLK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB2,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2s0")),		/* LRCK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB3,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2s0")),		/* DO0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB4,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2s0"),		/* DO1 */
+		SUNXI_FUNCTION(0x3, "uart3")),		/* RTS */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB5,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2s0"),		/* DO2 */
+		SUNXI_FUNCTION(0x3, "uart3"),		/* TX */
+		SUNXI_FUNCTION(0x4, "i2c3")),		/* SCK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB6,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2s0"),		/* DO3 */
+		SUNXI_FUNCTION(0x3, "uart3"),		/* RX */
+		SUNXI_FUNCTION(0x4, "i2c3")),		/* SDA */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PB7,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x3, "i2s0")),		/* DI */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC0,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* WE */
+		SUNXI_FUNCTION(0x3, "spi0")),		/* MOSI */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC1,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* ALE */
+		SUNXI_FUNCTION(0x3, "spi0")),		/* MISO */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC2,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* CLE */
+		SUNXI_FUNCTION(0x3, "spi0")),		/* CLK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC3,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0")),		/* CE1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC4,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0")),		/* CE0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC5,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0")),		/* RE */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC6,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* RB0 */
+		SUNXI_FUNCTION(0x3, "mmc2"),		/* CMD */
+		SUNXI_FUNCTION(0x4, "mmc3")),		/* CMD */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC7,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* RB1 */
+		SUNXI_FUNCTION(0x3, "mmc2"),		/* CLK */
+		SUNXI_FUNCTION(0x4, "mmc3")),		/* CLK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC8,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* DQ0 */
+		SUNXI_FUNCTION(0x3, "mmc2"),		/* D0 */
+		SUNXI_FUNCTION(0x4, "mmc3")),		/* D0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC9,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* DQ1 */
+		SUNXI_FUNCTION(0x3, "mmc2"),		/* D1 */
+		SUNXI_FUNCTION(0x4, "mmc3")),		/* D1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC10,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* DQ2 */
+		SUNXI_FUNCTION(0x3, "mmc2"),		/* D2 */
+		SUNXI_FUNCTION(0x4, "mmc3")),		/* D2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC11,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* DQ3 */
+		SUNXI_FUNCTION(0x3, "mmc2"),		/* D3 */
+		SUNXI_FUNCTION(0x4, "mmc3")),		/* D3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC12,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* DQ4 */
+		SUNXI_FUNCTION(0x3, "mmc2"),		/* D4 */
+		SUNXI_FUNCTION(0x4, "mmc3")),		/* D4 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC13,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* DQ5 */
+		SUNXI_FUNCTION(0x3, "mmc2"),		/* D5 */
+		SUNXI_FUNCTION(0x4, "mmc3")),		/* D5 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC14,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* DQ6 */
+		SUNXI_FUNCTION(0x3, "mmc2"),		/* D6 */
+		SUNXI_FUNCTION(0x4, "mmc3")),		/* D6 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC15,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* DQ7 */
+		SUNXI_FUNCTION(0x3, "mmc2"),		/* D7 */
+		SUNXI_FUNCTION(0x4, "mmc3")),		/* D7 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC16,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* DQ8 */
+		SUNXI_FUNCTION(0x3, "nand1")),		/* DQ0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC17,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* DQ9 */
+		SUNXI_FUNCTION(0x3, "nand1")),		/* DQ1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC18,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* DQ10 */
+		SUNXI_FUNCTION(0x3, "nand1")),		/* DQ2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC19,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* DQ11 */
+		SUNXI_FUNCTION(0x3, "nand1")),		/* DQ3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC20,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* DQ12 */
+		SUNXI_FUNCTION(0x3, "nand1")),		/* DQ4 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC21,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* DQ13 */
+		SUNXI_FUNCTION(0x3, "nand1")),		/* DQ5 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC22,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* DQ14 */
+		SUNXI_FUNCTION(0x3, "nand1")),		/* DQ6 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC23,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* DQ15 */
+		SUNXI_FUNCTION(0x3, "nand1")),		/* DQ7 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC24,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0"),		/* DQS */
+		SUNXI_FUNCTION(0x3, "mmc2"),		/* RST */
+		SUNXI_FUNCTION(0x4, "mmc3")),		/* RST */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC25,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0")),		/* CE2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC26,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand0")),		/* CE3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PC27,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x3, "spi0")),		/* CS0 */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD0,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D0 */
+		SUNXI_FUNCTION(0x3, "lvds0")),		/* VP0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD1,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D1 */
+		SUNXI_FUNCTION(0x3, "lvds0")),		/* VN0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD2,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D2 */
+		SUNXI_FUNCTION(0x3, "lvds0")),		/* VP1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD3,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D3 */
+		SUNXI_FUNCTION(0x3, "lvds0")),		/* VN1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD4,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D4 */
+		SUNXI_FUNCTION(0x3, "lvds0")),		/* VP2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD5,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D5 */
+		SUNXI_FUNCTION(0x3, "lvds0")),		/* VN2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD6,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D6 */
+		SUNXI_FUNCTION(0x3, "lvds0")),		/* VPC */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD7,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D7 */
+		SUNXI_FUNCTION(0x3, "lvds0")),		/* VNC */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD8,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D8 */
+		SUNXI_FUNCTION(0x3, "lvds0")),		/* VP3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD9,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D9 */
+		SUNXI_FUNCTION(0x3, "lvds0")),		/* VN3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD10,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D10 */
+		SUNXI_FUNCTION(0x3, "lvds1")),		/* VP0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD11,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D11 */
+		SUNXI_FUNCTION(0x3, "lvds1")),		/* VN0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD12,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D12 */
+		SUNXI_FUNCTION(0x3, "lvds1")),		/* VP1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD13,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D13 */
+		SUNXI_FUNCTION(0x3, "lvds1")),		/* VN1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD14,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D14 */
+		SUNXI_FUNCTION(0x3, "lvds1")),		/* VP2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD15,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D15 */
+		SUNXI_FUNCTION(0x3, "lvds1")),		/* VN2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD16,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D16 */
+		SUNXI_FUNCTION(0x3, "lvds1")),		/* VPC */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD17,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D17 */
+		SUNXI_FUNCTION(0x3, "lvds1")),		/* VNC */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD18,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D18 */
+		SUNXI_FUNCTION(0x3, "lvds1")),		/* VP3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD19,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0"),		/* D19 */
+		SUNXI_FUNCTION(0x3, "lvds1")),		/* VN3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD20,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D20 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD21,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D21 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD22,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D22 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD23,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* D23 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD24,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* CLK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD25,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* DE */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD26,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* HSYNC */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PD27,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "lcd0")),		/* VSYNC */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE0,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "csi"),		/* PCLK */
+		SUNXI_FUNCTION(0x3, "ts")),		/* CLK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE1,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "csi"),		/* MCLK */
+		SUNXI_FUNCTION(0x3, "ts")),		/* ERR */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE2,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "csi"),		/* HSYNC */
+		SUNXI_FUNCTION(0x3, "ts")),		/* SYNC */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE3,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "csi"),		/* VSYNC */
+		SUNXI_FUNCTION(0x3, "ts")),		/* DVLD */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE4,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "csi"),		/* D0 */
+		SUNXI_FUNCTION(0x3, "uart5")),		/* TX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE5,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "csi"),		/* D1 */
+		SUNXI_FUNCTION(0x3, "uart5")),		/* RX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE6,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "csi"),		/* D2 */
+		SUNXI_FUNCTION(0x3, "uart5")),		/* RTS */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE7,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "csi"),		/* D3 */
+		SUNXI_FUNCTION(0x3, "uart5")),		/* CTS */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE8,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "csi"),		/* D4 */
+		SUNXI_FUNCTION(0x3, "ts")),		/* D0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE9,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "csi"),		/* D5 */
+		SUNXI_FUNCTION(0x3, "ts")),		/* D1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE10,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "csi"),		/* D6 */
+		SUNXI_FUNCTION(0x3, "ts")),		/* D2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE11,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "csi"),		/* D7 */
+		SUNXI_FUNCTION(0x3, "ts")),		/* D3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE12,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "csi"),		/* D8 */
+		SUNXI_FUNCTION(0x3, "ts")),		/* D4 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE13,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "csi"),		/* D9 */
+		SUNXI_FUNCTION(0x3, "ts")),		/* D5 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE14,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "csi"),		/* D10 */
+		SUNXI_FUNCTION(0x3, "ts")),		/* D6 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE15,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "csi"),		/* D11 */
+		SUNXI_FUNCTION(0x3, "ts")),		/* D7 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE16,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "csi")),		/* MIPI CSI MCLK */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF0,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "mmc0"),		/* D1 */
+		SUNXI_FUNCTION(0x4, "jtag")),		/* MS1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF1,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "mmc0"),		/* D0 */
+		SUNXI_FUNCTION(0x4, "jtag")),		/* DI1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF2,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "mmc0"),		/* CLK */
+		SUNXI_FUNCTION(0x4, "uart0")),		/* TX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF3,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "mmc0"),		/* CMD */
+		SUNXI_FUNCTION(0x4, "jtag")),		/* DO1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF4,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "mmc0"),		/* D3 */
+		SUNXI_FUNCTION(0x4, "uart0")),		/* RX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF5,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "mmc0"),		/* D2 */
+		SUNXI_FUNCTION(0x4, "jtag")),		/* CK1 */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG0,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "mmc1")),		/* CLK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG1,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "mmc1")),		/* CMD */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG2,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "mmc1")),		/* D0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG3,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "mmc1")),		/* D1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG4,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "mmc1")),		/* D2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG5,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "mmc1")),		/* D3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG6,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "uart2")),		/* TX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG7,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "uart2")),		/* RX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG8,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "uart2")),		/* RTS */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG9,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "uart2")),		/* CTS */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG10,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2c3"),		/* SCK */
+		SUNXI_FUNCTION(0x3, "usb")),		/* DP3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG11,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2c3"),		/* SDA */
+		SUNXI_FUNCTION(0x3, "usb")),		/* DM3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG12,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "spi1"),		/* CS1 */
+		SUNXI_FUNCTION(0x3, "i2s1")),		/* MCLK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG13,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "spi1"),		/* CS0 */
+		SUNXI_FUNCTION(0x3, "i2s1")),		/* BCLK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG14,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "spi1"),		/* CLK */
+		SUNXI_FUNCTION(0x3, "i2s1")),		/* LRCK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG15,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "spi1"),		/* MOSI */
+		SUNXI_FUNCTION(0x3, "i2s1")),		/* DIN */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG16,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "spi1"),		/* MISO */
+		SUNXI_FUNCTION(0x3, "i2s1")),		/* DOUT */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG17,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "uart4")),		/* TX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG18,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "uart4")),		/* RX */
+	/* Hole */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH0,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand1")),		/* WE */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH1,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand1")),		/* ALE */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH2,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand1")),		/* CLE */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH3,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand1")),		/* CE1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH4,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand1")),		/* CE0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH5,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand1")),		/* RE */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH6,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand1")),		/* RB0 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH7,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand1")),		/* RB1 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH8,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand1")),		/* DQS */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH9,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "spi2"),		/* CS0 */
+		SUNXI_FUNCTION(0x3, "jtag"),		/* MS0 */
+		SUNXI_FUNCTION(0x4, "pwm1")),		/* Positive */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH10,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "spi2"),		/* CLK */
+		SUNXI_FUNCTION(0x3, "jtag"),		/* CK0 */
+		SUNXI_FUNCTION(0x4, "pwm1")),		/* Negative */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH11,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "spi2"),		/* MOSI */
+		SUNXI_FUNCTION(0x3, "jtag"),		/* DO0 */
+		SUNXI_FUNCTION(0x4, "pwm2")),		/* Positive */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH12,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "spi2"),		/* MISO */
+		SUNXI_FUNCTION(0x3, "jtag"),		/* DI0 */
+		SUNXI_FUNCTION(0x4, "pwm2")),		/* Negative */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH13,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "pwm0")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH14,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2c0")),		/* SCK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH15,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2c0")),		/* SDA */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH16,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2c1")),		/* SCK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH17,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2c1")),		/* SDA */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH18,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2c2")),		/* SCK */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH19,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "i2c2")),		/* SDA */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH20,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "uart0")),		/* TX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH21,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "uart0")),		/* RX */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH22,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH23,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH24,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH25,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH26,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH27,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH28,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out")),
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH29,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand1")),		/* CE2 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH30,
+		SUNXI_FUNCTION(0x0, "gpio_in"),
+		SUNXI_FUNCTION(0x1, "gpio_out"),
+		SUNXI_FUNCTION(0x2, "nand1")),		/* CE3 */
+};
+
 static const struct sunxi_pinctrl_desc sun4i_a10_pinctrl_data = {
 	.pins = sun4i_a10_pins,
 	.npins = ARRAY_SIZE(sun4i_a10_pins),
@@ -2020,4 +2835,9 @@ static const struct sunxi_pinctrl_desc sun5i_a13_pinctrl_data = {
 	.npins = ARRAY_SIZE(sun5i_a13_pins),
 };
 
+static const struct sunxi_pinctrl_desc sun6i_a31_pinctrl_data = {
+	.pins = sun6i_a31_pins,
+	.npins = ARRAY_SIZE(sun6i_a31_pins),
+};
+
 #endif /* __PINCTRL_SUNXI_PINS_H */
diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index c47fd1e..5985e60 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -631,6 +631,7 @@ static struct of_device_id sunxi_pinctrl_match[] = {
 	{ .compatible = "allwinner,sun4i-a10-pinctrl", .data = (void *)&sun4i_a10_pinctrl_data },
 	{ .compatible = "allwinner,sun5i-a10s-pinctrl", .data = (void *)&sun5i_a10s_pinctrl_data },
 	{ .compatible = "allwinner,sun5i-a13-pinctrl", .data = (void *)&sun5i_a13_pinctrl_data },
+	{ .compatible = "allwinner,sun6i-a31-pinctrl", .data = (void *)&sun6i_a31_pinctrl_data },
 	{}
 };
 MODULE_DEVICE_TABLE(of, sunxi_pinctrl_match);
-- 
1.8.3.2

