Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934547Ab3CZOe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:34:58 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:61814 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934503Ab3CZOe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:34:56 -0400
Message-ID: <1364308490.4090.0.camel@phoenix>
Subject: [PATCH] pwm: ab8500: Fix trivial typo in dev_err message
From: Axel Lin <axel.lin@ingics.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arun R Murthy <arun.murthy@stericsson.com>, linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 22:34:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pwm/pwm-ab8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-ab8500.c b/drivers/pwm/pwm-ab8500.c
index 93af1bb..3beb2b5 100644
--- a/drivers/pwm/pwm-ab8500.c
+++ b/drivers/pwm/pwm-ab8500.c
@@ -66,7 +66,7 @@ static int ab8500_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
 				1 << (chip->base - 1), ENABLE_PWM);
 	if (ret < 0)
-		dev_err(chip->dev, "%s: Failed to disable PWM, Error %d\n",
+		dev_err(chip->dev, "%s: Failed to enable PWM, Error %d\n",
 							pwm->label, ret);
 	return ret;
 }
-- 
1.7.10.4



