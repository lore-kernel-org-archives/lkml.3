Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013Ab3CZN2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:28:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41154 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932367Ab3CZN2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:28:04 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: arizona: Increase ramp delay for high current regulators
Date: Tue, 26 Mar 2013 13:27:59 +0000
Message-Id: <1364304479-26980-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per latest evaluation.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-ldo1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index ed7beec..81d8681 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -131,7 +131,7 @@ static const struct regulator_desc arizona_ldo1_hc = {
 	.min_uV = 900000,
 	.uV_step = 50000,
 	.n_voltages = 8,
-	.enable_time = 500,
+	.enable_time = 1500,
 
 	.owner = THIS_MODULE,
 };
-- 
1.7.10.4

