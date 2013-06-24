Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab3FXLf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:35:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48341 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3FXLfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:35:24 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, t.figa@samsung.com, linus.walleij@linaro.org,
        sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] pinctrl: samsung: Staticize drvdata_list
Date: Mon, 24 Jun 2013 16:50:21 +0530
Message-Id: <1372072821-22450-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'drvdata_list' is used only in this file. Make it static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/pinctrl-samsung.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index 0a6c720..a7fa9e2 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -50,7 +50,7 @@ static struct pin_config {
 };
 
 /* Global list of devices (struct samsung_pinctrl_drv_data) */
-LIST_HEAD(drvdata_list);
+static LIST_HEAD(drvdata_list);
 
 static unsigned int pin_base;
 
-- 
1.7.9.5

