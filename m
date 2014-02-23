Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbaBWMiY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 07:38:24 -0500
Received: from sauhun.de ([89.238.76.85]:42980 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbaBWMiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 07:38:23 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-sh@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: pfc: r8a7791: add mux data for IIC(B) cores
Date: Sun, 23 Feb 2014 13:38:12 +0100
Message-Id: <1393159095-14269-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <wsa@sang-engineering.com>

Signed-off-by: Wolfram Sang <wsa@sang-engineering.com>
---
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c | 64 ++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
index 77d103f..cd28cec 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
@@ -1943,6 +1943,50 @@ static const unsigned int i2c4_c_pins[] = {
 static const unsigned int i2c4_c_mux[] = {
 	SCL4_C_MARK, SDA4_C_MARK,
 };
+/* - I2C7 ------------------------------------------------------------------- */
+static const unsigned int i2c7_pins[] = {
+	/* SCL, SDA */
+	RCAR_GP_PIN(5, 15), RCAR_GP_PIN(5, 16),
+};
+static const unsigned int i2c7_mux[] = {
+	SCL7_MARK, SDA7_MARK,
+};
+static const unsigned int i2c7_b_pins[] = {
+	/* SCL, SDA */
+	RCAR_GP_PIN(2, 2), RCAR_GP_PIN(2, 3),
+};
+static const unsigned int i2c7_b_mux[] = {
+	SCL7_B_MARK, SDA7_B_MARK,
+};
+static const unsigned int i2c7_c_pins[] = {
+	/* SCL, SDA */
+	RCAR_GP_PIN(6, 28), RCAR_GP_PIN(6, 29),
+};
+static const unsigned int i2c7_c_mux[] = {
+	SCL7_C_MARK, SDA7_C_MARK,
+};
+/* - I2C8 ------------------------------------------------------------------- */
+static const unsigned int i2c8_pins[] = {
+	/* SCL, SDA */
+	RCAR_GP_PIN(4, 13), RCAR_GP_PIN(4, 14),
+};
+static const unsigned int i2c8_mux[] = {
+	SCL8_MARK, SDA8_MARK,
+};
+static const unsigned int i2c8_b_pins[] = {
+	/* SCL, SDA */
+	RCAR_GP_PIN(2, 4), RCAR_GP_PIN(2, 5),
+};
+static const unsigned int i2c8_b_mux[] = {
+	SCL8_B_MARK, SDA8_B_MARK,
+};
+static const unsigned int i2c8_c_pins[] = {
+	/* SCL, SDA */
+	RCAR_GP_PIN(6, 22), RCAR_GP_PIN(6, 23),
+};
+static const unsigned int i2c8_c_mux[] = {
+	SCL8_C_MARK, SDA8_C_MARK,
+};
 /* - INTC ------------------------------------------------------------------- */
 static const unsigned int intc_irq0_pins[] = {
 	/* IRQ */
@@ -3123,6 +3167,12 @@ static const struct sh_pfc_pin_group pinmux_groups[] = {
 	SH_PFC_PIN_GROUP(i2c4),
 	SH_PFC_PIN_GROUP(i2c4_b),
 	SH_PFC_PIN_GROUP(i2c4_c),
+	SH_PFC_PIN_GROUP(i2c7),
+	SH_PFC_PIN_GROUP(i2c7_b),
+	SH_PFC_PIN_GROUP(i2c7_c),
+	SH_PFC_PIN_GROUP(i2c8),
+	SH_PFC_PIN_GROUP(i2c8_b),
+	SH_PFC_PIN_GROUP(i2c8_c),
 	SH_PFC_PIN_GROUP(intc_irq0),
 	SH_PFC_PIN_GROUP(intc_irq1),
 	SH_PFC_PIN_GROUP(intc_irq2),
@@ -3335,6 +3385,18 @@ static const char * const i2c4_groups[] = {
 	"i2c4_c",
 };
 
+static const char * const i2c7_groups[] = {
+	"i2c7",
+	"i2c7_b",
+	"i2c7_c",
+};
+
+static const char * const i2c8_groups[] = {
+	"i2c8",
+	"i2c8_b",
+	"i2c8_c",
+};
+
 static const char * const intc_groups[] = {
 	"intc_irq0",
 	"intc_irq1",
@@ -3566,6 +3628,8 @@ static const struct sh_pfc_function pinmux_functions[] = {
 	SH_PFC_FUNCTION(i2c2),
 	SH_PFC_FUNCTION(i2c3),
 	SH_PFC_FUNCTION(i2c4),
+	SH_PFC_FUNCTION(i2c7),
+	SH_PFC_FUNCTION(i2c8),
 	SH_PFC_FUNCTION(intc),
 	SH_PFC_FUNCTION(mmc),
 	SH_PFC_FUNCTION(msiof0),
-- 
1.8.5.1

