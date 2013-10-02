Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab3JBMy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:54:26 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:51906 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3JBMyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:54:24 -0400
Message-ID: <1380718460.7307.5.camel@phoenix>
Subject: [PATCH] regulator: stw481x-vmmc: Set missing .of_match_table to
 stw481x_vmmc_match
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 02 Oct 2013 20:54:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/stw481x-vmmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/stw481x-vmmc.c b/drivers/regulator/stw481x-vmmc.c
index 5ae72a8..f78857b 100644
--- a/drivers/regulator/stw481x-vmmc.c
+++ b/drivers/regulator/stw481x-vmmc.c
@@ -102,6 +102,7 @@ static struct platform_driver stw481x_vmmc_regulator_driver = {
 	.driver = {
 		.name  = "stw481x-vmmc-regulator",
 		.owner = THIS_MODULE,
+		.of_match_table = stw481x_vmmc_match,
 	},
 	.probe = stw481x_vmmc_regulator_probe,
 	.remove = stw481x_vmmc_regulator_remove,
-- 
1.8.1.2



