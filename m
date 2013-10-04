Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab3JDJsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 05:48:54 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:50151 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab3JDJst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 05:48:49 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, patches@opensource.wolfsonmicro.com,
        sachin.kamat@linaro.org
Subject: [PATCH 2/2] regulator: gpio: Remove redundant break
Date: Fri,  4 Oct 2013 15:18:18 +0530
Message-Id: <1380880098-25188-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380880098-25188-1-git-send-email-sachin.kamat@linaro.org>
References: <1380880098-25188-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'break' after goto has no effect. Remove it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/gpio-regulator.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 98a98ff..04406a9 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -283,7 +283,6 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "No regulator type set\n");
 		ret = -EINVAL;
 		goto err_memgpio;
-		break;
 	}
 
 	drvdata->nr_gpios = config->nr_gpios;
-- 
1.7.9.5

