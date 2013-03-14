Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab3CNMFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:05:41 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:40513 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab3CNMFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:05:39 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: srinidhi.kasagar@stericsson.com, linus.walleij@linaro.org,
        sachin.kamat@linaro.org
Subject: [PATCH 2/2] pinctrl/nomadik: Fix checkpatch errors
Date: Thu, 14 Mar 2013 17:24:44 +0530
Message-Id: <1363262084-18929-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363262084-18929-1-git-send-email-sachin.kamat@linaro.org>
References: <1363262084-18929-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following types of checkpatch errors:
ERROR: space required after that ',' (ctx:VxV)
ERROR: space prohibited before that close parenthesis ')'

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 2328baa..267d81c 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1565,8 +1565,8 @@ static int nmk_dt_add_map_configs(struct pinctrl_map **map,
 	return 0;
 }
 
-#define NMK_CONFIG_PIN(x,y) { .property = x, .config = y, }
-#define NMK_CONFIG_PIN_ARRAY(x,y) { .property = x, .choice = y, \
+#define NMK_CONFIG_PIN(x, y) { .property = x, .config = y, }
+#define NMK_CONFIG_PIN_ARRAY(x, y) { .property = x, .choice = y, \
 	.size = ARRAY_SIZE(y), }
 
 static const unsigned long nmk_pin_input_modes[] = {
@@ -2068,7 +2068,7 @@ static int nmk_pin_config_set(struct pinctrl_dev *pctldev, unsigned pin,
 		pin, cfg, pullnames[pull], slpmnames[slpm],
 		output ? "output " : "input",
 		output ? (val ? "high" : "low") : "",
-		lowemi ? "on" : "off" );
+		lowemi ? "on" : "off");
 
 	clk_enable(nmk_chip->clk);
 	bit = pin % NMK_GPIO_PER_CHIP;
-- 
1.7.4.1

