Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab3EOKyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 06:54:06 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63614 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab3EOKyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 06:54:04 -0400
From: Leon Romanovsky <leon@leon.nu>
To: sbkim73@samsung.com, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Leon Romanovsky <leon@leon.nu>
Subject: [PATCH] drivers: mfd: sec-code: Fix sizeof argument
Date: Wed, 15 May 2013 13:53:56 +0300
Message-Id: <1368615236-21345-1-git-send-email-leon@leon.nu>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Leon Romanovsky <leon@leon.nu>
---
 drivers/mfd/sec-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 77ee26ef..5b740a3 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -121,7 +121,7 @@ static struct sec_platform_data *sec_pmic_i2c_parse_dt_pdata(
 {
 	struct sec_platform_data *pd;
 
-	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
+	pd = devm_kzalloc(dev, sizeof(struct sec_platform_data), GFP_KERNEL);
 	if (!pd) {
 		dev_err(dev, "could not allocate memory for pdata\n");
 		return ERR_PTR(-ENOMEM);
-- 
1.8.1.5

