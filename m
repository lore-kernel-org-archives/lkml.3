Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3AZOhJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 09:37:09 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:51529 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3AZOhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 09:37:05 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Alejandro Mery <amery@geeks.cl>,
        Stefan Roese <sr@denx.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] pinctrl: sunxi: Document sun5i pins functions
Date: Sat, 26 Jan 2013 15:36:52 +0100
Message-Id: <1359211016-24097-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359211016-24097-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1359211016-24097-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/pinctrl/pinctrl-sunxi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index 4ed0e7e..34b4e90 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -217,11 +217,11 @@ static const struct sunxi_desc_pin sun5i_a13_pins[] = {
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE10,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x4, "uart1")),
+		SUNXI_FUNCTION(0x4, "uart1")),		/* TX */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PE11,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x4, "uart1")),
+		SUNXI_FUNCTION(0x4, "uart1")),		/* RX */
 	/* Hole */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PF0,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
@@ -254,11 +254,11 @@ static const struct sunxi_desc_pin sun5i_a13_pins[] = {
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG3,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x4, "uart1")),
+		SUNXI_FUNCTION(0x4, "uart1")),		/* TX */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG4,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
 		SUNXI_FUNCTION(0x1, "gpio_out"),
-		SUNXI_FUNCTION(0x4, "uart1")),
+		SUNXI_FUNCTION(0x4, "uart1")),		/* RX */
 	/* Hole */
 	SUNXI_PIN(SUNXI_PINCTRL_PIN_PG9,
 		SUNXI_FUNCTION(0x0, "gpio_in"),
-- 
1.7.10.4

