Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaFXInZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:43:25 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55838 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaFXInW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:43:22 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sbkim73@samsung.com, lgirdwood@gmail.com, broonie@kernel.org,
        spk.linux@gmail.com
Subject: [PATCH 1/1] regulator: s5m8767: Remove unused variable
Date: Tue, 24 Jun 2014 14:10:04 +0530
Message-Id: <1403599204-5975-1-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'size' is not used in the function. Remove it.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
 drivers/regulator/s5m8767.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index c79af943a5c0..0ab5cbeeb797 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -686,7 +686,7 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 	struct sec_platform_data *pdata = iodev->pdata;
 	struct regulator_config config = { };
 	struct s5m8767_info *s5m8767;
-	int i, ret, size, buck_init;
+	int i, ret, buck_init;
 
 	if (!pdata) {
 		dev_err(pdev->dev.parent, "Platform data not supplied\n");
@@ -725,8 +725,6 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 	if (!s5m8767)
 		return -ENOMEM;
 
-	size = sizeof(struct regulator_dev *) * (S5M8767_REG_MAX - 2);
-
 	s5m8767->dev = &pdev->dev;
 	s5m8767->iodev = iodev;
 	s5m8767->num_regulators = pdata->num_regulators;
-- 
1.7.9.5

