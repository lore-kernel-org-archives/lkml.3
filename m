Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab3CMMIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 08:08:05 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:48558 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab3CMMIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 08:08:04 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: srinidhi.kasagar@stericsson.com, linus.walleij@linaro.org,
        sachin.kamat@linaro.org
Subject: [PATCH 1/1] pinctrl: pinctrl-nomadik-stn8815: Fix checkpatch error
Date: Wed, 13 Mar 2013 17:27:13 +0530
Message-Id: <1363175833-6162-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following error:
ERROR: space required after that ',' (ctx:VxV)

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik-stn8815.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik-stn8815.c b/drivers/pinctrl/pinctrl-nomadik-stn8815.c
index 924a339..ed39dca 100644
--- a/drivers/pinctrl/pinctrl-nomadik-stn8815.c
+++ b/drivers/pinctrl/pinctrl-nomadik-stn8815.c
@@ -299,7 +299,7 @@ static const unsigned i2c0_a_1_pins[] = { STN8815_PIN_D3, STN8815_PIN_D2 };
 static const unsigned u1_b_1_pins[] = { STN8815_PIN_B16, STN8815_PIN_A16 };
 static const unsigned i2cusb_b_1_pins[] = { STN8815_PIN_C21, STN8815_PIN_C20 };
 
-#define STN8815_PIN_GROUP(a,b) { .name = #a, .pins = a##_pins,		\
+#define STN8815_PIN_GROUP(a, b) { .name = #a, .pins = a##_pins,		\
 			.npins = ARRAY_SIZE(a##_pins), .altsetting = b }
 
 static const struct nmk_pingroup nmk_stn8815_groups[] = {
-- 
1.7.4.1

