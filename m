Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab3CNMFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:05:38 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:51567 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3CNMFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:05:36 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: srinidhi.kasagar@stericsson.com, linus.walleij@linaro.org,
        sachin.kamat@linaro.org
Subject: [PATCH 1/2] pinctrl/nomadik-db8500: Fix checkpatch errors
Date: Thu, 14 Mar 2013 17:24:43 +0530
Message-Id: <1363262084-18929-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silences the following type of checkpatch errors:
ERROR: space required after that ',' (ctx:VxV)

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik-db8500.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik-db8500.c b/drivers/pinctrl/pinctrl-nomadik-db8500.c
index 30b4da9..c748407 100644
--- a/drivers/pinctrl/pinctrl-nomadik-db8500.c
+++ b/drivers/pinctrl/pinctrl-nomadik-db8500.c
@@ -466,7 +466,7 @@ static const unsigned mc1_a_1_pins[] = { DB8500_PIN_AH16, DB8500_PIN_AG15,
 	DB8500_PIN_AJ15, DB8500_PIN_AG14, DB8500_PIN_AF13, DB8500_PIN_AG13,
 	DB8500_PIN_AH15 };
 static const unsigned mc1_a_2_pins[] = { DB8500_PIN_AH16, DB8500_PIN_AJ15,
-	DB8500_PIN_AG14, DB8500_PIN_AF13, DB8500_PIN_AG13,DB8500_PIN_AH15 };
+	DB8500_PIN_AG14, DB8500_PIN_AF13, DB8500_PIN_AG13, DB8500_PIN_AH15 };
 static const unsigned mc1dir_a_1_pins[] = { DB8500_PIN_AH13, DB8500_PIN_AG12,
 	DB8500_PIN_AH12, DB8500_PIN_AH11 };
 static const unsigned hsir_a_1_pins[] = { DB8500_PIN_AG10, DB8500_PIN_AH10,
@@ -663,7 +663,7 @@ static const unsigned hwobs_oc4_1_pins[] = { DB8500_PIN_D17, DB8500_PIN_D16,
 	DB8500_PIN_D21, DB8500_PIN_D20,	DB8500_PIN_C20, DB8500_PIN_B21,
 	DB8500_PIN_C21, DB8500_PIN_A22, DB8500_PIN_B24, DB8500_PIN_C22 };
 
-#define DB8500_PIN_GROUP(a,b) { .name = #a, .pins = a##_pins,		\
+#define DB8500_PIN_GROUP(a, b) { .name = #a, .pins = a##_pins,		\
 			.npins = ARRAY_SIZE(a##_pins), .altsetting = b }
 
 static const struct nmk_pingroup nmk_db8500_groups[] = {
-- 
1.7.4.1

