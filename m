Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578AbaDINxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:53:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60873 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933471AbaDINvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:51:37 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 14/15] pinctrl: sunxi: define A31 PL0/PL1 pins
Date: Wed,  9 Apr 2014 15:51:17 +0200
Message-Id: <1397051478-4113-15-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define PL0/PL1 pins available on the A31 SoC.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/pinctrl/pinctrl-sunxi-pins.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-sunxi-pins.h b/drivers/pinctrl/pinctrl-sunxi-pins.h
index 3d60669..274cefa 100644
--- a/drivers/pinctrl/pinctrl-sunxi-pins.h
+++ b/drivers/pinctrl/pinctrl-sunxi-pins.h
@@ -2818,6 +2818,14 @@ static const struct sunxi_desc_pin sun6i_a31_pins[] = {
 		  SUNXI_FUNCTION(0x0, "gpio_in"),
 		  SUNXI_FUNCTION(0x1, "gpio_out"),
 		  SUNXI_FUNCTION(0x2, "nand1")),	/* CE3 */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PL0,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x3, "p2wi")),		/* SCL */
+	SUNXI_PIN(SUNXI_PINCTRL_PIN_PL1,
+		  SUNXI_FUNCTION(0x0, "gpio_in"),
+		  SUNXI_FUNCTION(0x1, "gpio_out"),
+		  SUNXI_FUNCTION(0x3, "p2wi")),		/* SDA */
 };
 
 static const struct sunxi_desc_pin sun7i_a20_pins[] = {
-- 
1.8.3.2

