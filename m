Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab3LYEiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 23:38:07 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53299 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3LYEiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 23:38:05 -0500
Message-ID: <1387946278.6422.2.camel@phoenix>
Subject: [PATCH RFT] regulator: act8865: Remove set_suspend_[en|dis]able
 implementation
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Dec 2013 12:37:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no suspend enable/disable settings mentioned in datasheet,
so just don't implement .set_suspend_[en|dis]able callbacks.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/act8865-regulator.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
index dfae294..e7dbdc0 100644
--- a/drivers/regulator/act8865-regulator.c
+++ b/drivers/regulator/act8865-regulator.c
@@ -85,8 +85,6 @@ static struct regulator_ops act8865_ops = {
 	.enable			= regulator_enable_regmap,
 	.disable		= regulator_disable_regmap,
 	.is_enabled		= regulator_is_enabled_regmap,
-	.set_suspend_enable	= regulator_enable_regmap,
-	.set_suspend_disable	= regulator_disable_regmap,
 };
 
 static const struct regulator_desc act8865_reg[] = {
-- 
1.8.1.2



