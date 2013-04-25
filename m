Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab3DYOP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:15:29 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:34507 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256Ab3DYOP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:15:28 -0400
Message-ID: <1366899321.8012.1.camel@phoenix>
Subject: [PATCH] regulator: max8952: Add missing config.of_node setting for
 regulator register
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 25 Apr 2013 22:15:21 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max8952.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index 4259c78..5259c2f 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -225,6 +225,7 @@ static int max8952_pmic_probe(struct i2c_client *client,
 	config.dev = max8952->dev;
 	config.init_data = pdata->reg_data;
 	config.driver_data = max8952;
+	config.of_node = client->dev.of_node;
 
 	config.ena_gpio = pdata->gpio_en;
 	if (pdata->reg_data->constraints.boot_on)
-- 
1.7.10.4



