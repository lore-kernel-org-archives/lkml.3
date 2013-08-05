Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab3HEJRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:17:31 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:52115 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab3HEJRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:17:30 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cw00.choi@samsung.com, myungjoo.ham@samsung.com, broonie@kernel.org,
        sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] extcon: arizona: Fix a typo in a comment
Date: Mon,  5 Aug 2013 14:30:46 +0530
Message-Id: <1375693246-28350-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes an incomplete comment introduced by commit 9c2ba270
("extcon: arizona: Simplify HPDET based identification").

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-arizona.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index e557130..5061ae5 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -514,7 +514,7 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading,
 		}
 
 		/*
-		 * If we measure the mic as 
+		 * If we measure the mic as high impedance
 		 */
 		if (!id_gpio || info->hpdet_res[1] > 50) {
 			dev_dbg(arizona->dev, "Detected mic\n");
-- 
1.7.9.5

