Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab3C1QVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:21:43 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:38144 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275Ab3C1QVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:21:41 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 1/2] ARM: ux500: remove redundant DB8500_PIN_SLEEP definition
Date: Thu, 28 Mar 2013 17:21:08 +0100
Message-Id: <1364487669-24368-2-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364487669-24368-1-git-send-email-fabio.baltieri@linaro.org>
References: <1364487669-24368-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DB8500_PIN_SLEEP was defined twice, drop one of the two.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-pins.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index 0a3f30d..625880f 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -78,9 +78,6 @@ BIAS(out_wkup_pdis, PIN_SLPM_DIR_OUTPUT|PIN_SLPM_WAKEUP_ENABLE|
 	PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-db8500", group, func)
 #define DB8500_PIN_HOG(pin,conf) \
 	PIN_MAP_CONFIGS_PIN_HOG_DEFAULT("pinctrl-db8500", pin, conf)
-#define DB8500_PIN_SLEEP(pin, conf, dev) \
-	PIN_MAP_CONFIGS_PIN(dev, PINCTRL_STATE_SLEEP, "pinctrl-db8500",	\
-			    pin, conf)
 
 /* These are default states associated with device and changed runtime */
 #define DB8500_MUX(group,func,dev) \
-- 
1.8.1.3

