Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaBLJPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:15:39 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:55360 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaBLJPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:15:34 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/4] mfd: stw481x: Staticize stw481x_regmap_config
Date: Wed, 12 Feb 2014 14:40:12 +0530
Message-Id: <1392196213-20576-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392196213-20576-1-git-send-email-sachin.kamat@linaro.org>
References: <1392196213-20576-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stw481x_regmap_config is local to this file.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/stw481x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/stw481x.c b/drivers/mfd/stw481x.c
index 1243d5c6a448..cc42f88586f6 100644
--- a/drivers/mfd/stw481x.c
+++ b/drivers/mfd/stw481x.c
@@ -167,7 +167,7 @@ static struct mfd_cell stw481x_cells[] = {
 	},
 };
 
-const struct regmap_config stw481x_regmap_config = {
+static const struct regmap_config stw481x_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 };
-- 
1.7.9.5

