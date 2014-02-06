Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbaBFPah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:30:37 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:36399 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533AbaBFPae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:30:34 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, bjorn.andersson@sonymobile.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 1/2] pinctrl-msm: Add SPI8 pin definitions
Date: Thu,  6 Feb 2014 17:28:48 +0200
Message-Id: <1391700529-11816-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Add pin, group and function definitions for SPI#8
controller.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/pinctrl/pinctrl-msm8x74.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-msm8x74.c b/drivers/pinctrl/pinctrl-msm8x74.c
index f944bf2..9aeeb38 100644
--- a/drivers/pinctrl/pinctrl-msm8x74.c
+++ b/drivers/pinctrl/pinctrl-msm8x74.c
@@ -406,6 +406,7 @@ enum msm8x74_functions {
 	MSM_MUX_blsp_i2c6,
 	MSM_MUX_blsp_i2c11,
 	MSM_MUX_blsp_spi1,
+	MSM_MUX_blsp_spi8,
 	MSM_MUX_blsp_uart2,
 	MSM_MUX_blsp_uart8,
 	MSM_MUX_slimbus,
@@ -416,6 +417,9 @@ static const char * const blsp_i2c2_groups[] = { "gpio6", "gpio7" };
 static const char * const blsp_i2c6_groups[] = { "gpio29", "gpio30" };
 static const char * const blsp_i2c11_groups[] = { "gpio83", "gpio84" };
 static const char * const blsp_spi1_groups[] = { "gpio0", "gpio1", "gpio2", "gpio3" };
+static const char * const blsp_spi8_groups[] = {
+	"gpio45", "gpio46", "gpio47", "gpio48"
+};
 static const char * const blsp_uart2_groups[] = { "gpio4", "gpio5" };
 static const char * const blsp_uart8_groups[] = { "gpio45", "gpio46" };
 static const char * const slimbus_groups[] = { "gpio70", "gpio71" };
@@ -425,6 +429,7 @@ static const struct msm_function msm8x74_functions[] = {
 	FUNCTION(blsp_i2c6),
 	FUNCTION(blsp_i2c11),
 	FUNCTION(blsp_spi1),
+	FUNCTION(blsp_spi8),
 	FUNCTION(blsp_uart2),
 	FUNCTION(blsp_uart8),
 	FUNCTION(slimbus),
@@ -476,10 +481,10 @@ static const struct msm_pingroup msm8x74_groups[] = {
 	PINGROUP(42,  NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(43,  NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(44,  NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(45,  NA, blsp_uart8, NA, NA, NA, NA, NA),
-	PINGROUP(46,  NA, blsp_uart8, NA, NA, NA, NA, NA),
-	PINGROUP(47,  NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(48,  NA, NA, NA, NA, NA, NA, NA),
+	PINGROUP(45,  blsp_spi8, blsp_uart8, NA, NA, NA, NA, NA),
+	PINGROUP(46,  blsp_spi8, blsp_uart8, NA, NA, NA, NA, NA),
+	PINGROUP(47,  blsp_spi8, NA, NA, NA, NA, NA, NA),
+	PINGROUP(48,  blsp_spi8, NA, NA, NA, NA, NA, NA),
 	PINGROUP(49,  NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(50,  NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(51,  NA, NA, NA, NA, NA, NA, NA),
-- 
1.7.9.5

