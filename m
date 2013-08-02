Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab3HBLAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 07:00:10 -0400
Received: from up.free-electrons.com ([94.23.35.102]:58808 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964798Ab3HBKET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:04:19 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCHv2 5/9] pinctrl: sunxi: Fix inconsistent indentation
Date: Fri,  2 Aug 2013 12:02:49 +0200
Message-Id: <1375437773-3211-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375437773-3211-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1375437773-3211-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some pin functions in the array were not indented like the other
functions in this array. Fix this.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-sunxi-pins.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-sunxi-pins.h b/drivers/pinctrl/pinctrl-sunxi-pins.h
index 3368965..2c7446a 100644
--- a/drivers/pinctrl/pinctrl-sunxi-pins.h
+++ b/drivers/pinctrl/pinctrl-sunxi-pins.h
@@ -806,7 +806,7 @@ static const struct sunxi_desc_pin sun4i_a10_pins[] = {
 		  SUNXI_FUNCTION(0x3, "pata"),		/* ATAD13 */
 		  SUNXI_FUNCTION(0x4, "keypad"),	/* IN7 */
 		  SUNXI_FUNCTION(0x5, "sim"),		/* VCCEN */
-		SUNXI_FUNCTION_IRQ(0x6, 17),		/* EINT17 */
+		  SUNXI_FUNCTION_IRQ(0x6, 17),		/* EINT17 */
 		  SUNXI_FUNCTION(0x7, "csi1")),		/* D17 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH18,
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
@@ -815,7 +815,7 @@ static const struct sunxi_desc_pin sun4i_a10_pins[] = {
 		  SUNXI_FUNCTION(0x3, "pata"),		/* ATAD14 */
 		  SUNXI_FUNCTION(0x4, "keypad"),	/* OUT0 */
 		  SUNXI_FUNCTION(0x5, "sim"),		/* SCK */
-		SUNXI_FUNCTION_IRQ(0x6, 18),		/* EINT18 */
+		  SUNXI_FUNCTION_IRQ(0x6, 18),		/* EINT18 */
 		  SUNXI_FUNCTION(0x7, "csi1")),		/* D18 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH19,
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
@@ -824,7 +824,7 @@ static const struct sunxi_desc_pin sun4i_a10_pins[] = {
 		  SUNXI_FUNCTION(0x3, "pata"),		/* ATAD15 */
 		  SUNXI_FUNCTION(0x4, "keypad"),	/* OUT1 */
 		  SUNXI_FUNCTION(0x5, "sim"),		/* SDA */
-		SUNXI_FUNCTION_IRQ(0x6, 19),		/* EINT19 */
+		  SUNXI_FUNCTION_IRQ(0x6, 19),		/* EINT19 */
 		  SUNXI_FUNCTION(0x7, "csi1")),		/* D19 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH20,
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
@@ -832,7 +832,7 @@ static const struct sunxi_desc_pin sun4i_a10_pins[] = {
 		  SUNXI_FUNCTION(0x2, "lcd1"),		/* D20 */
 		  SUNXI_FUNCTION(0x3, "pata"),		/* ATAOE */
 		  SUNXI_FUNCTION(0x4, "can"),		/* TX */
-		SUNXI_FUNCTION_IRQ(0x6, 20),		/* EINT20 */
+		  SUNXI_FUNCTION_IRQ(0x6, 20),		/* EINT20 */
 		  SUNXI_FUNCTION(0x7, "csi1")),		/* D20 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH21,
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
@@ -840,7 +840,7 @@ static const struct sunxi_desc_pin sun4i_a10_pins[] = {
 		  SUNXI_FUNCTION(0x2, "lcd1"),		/* D21 */
 		  SUNXI_FUNCTION(0x3, "pata"),		/* ATADREQ */
 		  SUNXI_FUNCTION(0x4, "can"),		/* RX */
-		SUNXI_FUNCTION_IRQ(0x6, 21),		/* EINT21 */
+		  SUNXI_FUNCTION_IRQ(0x6, 21),		/* EINT21 */
 		  SUNXI_FUNCTION(0x7, "csi1")),		/* D21 */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PH22,
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
-- 
1.8.3.4

