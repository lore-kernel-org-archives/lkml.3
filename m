Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaE0InM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:43:12 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:57900 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaE0InH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:43:07 -0400
Message-ID: <1401180180.7221.0.camel@phoenix>
Subject: [PATCH] regulator: tps6586x: Remove unused to_tps6586x_dev()
 function
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Alban Bedel <alban.bedel@avionic-design.de>,
        Stefan Agner <stefan@agner.ch>, Mike Rapoport <mike@compulab.co.il>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 27 May 2014 16:43:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps6586x-regulator.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index e045b7f..0a3bb3a 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -63,11 +63,6 @@ struct tps6586x_regulator {
 	int enable_reg[2];
 };
 
-static inline struct device *to_tps6586x_dev(struct regulator_dev *rdev)
-{
-	return rdev_get_dev(rdev)->parent;
-}
-
 static struct regulator_ops tps6586x_rw_regulator_ops = {
 	.list_voltage = regulator_list_voltage_table,
 	.map_voltage = regulator_map_voltage_ascend,
-- 
1.8.3.2



