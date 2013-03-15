Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3COFUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:20:47 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:35175 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3COFUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:20:45 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 1/1] pinctrl: coh901: Fix checkpatch error
Date: Fri, 15 Mar 2013 10:39:52 +0530
Message-Id: <1363324192-9384-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch error:
ERROR: space required before the open parenthesis '('

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/pinctrl-coh901.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
index 8b7e7bc..86887850 100644
--- a/drivers/pinctrl/pinctrl-coh901.c
+++ b/drivers/pinctrl/pinctrl-coh901.c
@@ -359,7 +359,7 @@ int u300_gpio_config_get(struct gpio_chip *chip,
 	drmode &= (U300_GPIO_PXPCR_PIN_MODE_MASK << ((offset & 0x07) << 1));
 	drmode >>= ((offset & 0x07) << 1);
 
-	switch(param) {
+	switch (param) {
 	case PIN_CONFIG_BIAS_HIGH_IMPEDANCE:
 		*config = 0;
 		if (biasmode)
-- 
1.7.4.1

