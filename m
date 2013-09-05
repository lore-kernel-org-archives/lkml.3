Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab3IEEJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 00:09:55 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:40460 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3IEEJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 00:09:54 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, sachin.kamat@linaro.org
Subject: [PATCH 1/2] regulator: core: Fix a trivial typo
Date: Thu,  5 Sep 2013 09:22:02 +0530
Message-Id: <1378353123-29604-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed automaticall -> automatically.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
This series is based on topic/devm branch of regulator tree.
---
 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c002b62..741c84c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3741,7 +3741,7 @@ static void devm_rdev_release(struct device *dev, void *res)
  *
  * Called by regulator drivers to register a regulator.  Returns a
  * valid pointer to struct regulator_dev on success or an ERR_PTR() on
- * error.  The regulator will automaticall be released when the device
+ * error.  The regulator will automatically be released when the device
  * is unbound.
  */
 struct regulator_dev *devm_regulator_register(struct device *dev,
-- 
1.7.9.5

