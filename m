Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaHTCEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 22:04:23 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40823 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaHTCEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 22:04:22 -0400
Message-ID: <1408500257.5309.2.camel@phoenix>
Subject: [PATCH] regulator: max77802: Remove unused fields from struct
 max77802_regulator_prv
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 20 Aug 2014 10:04:17 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both num_regulators and *rdev[MAX77802_REG_MAX] are not used, remove them.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max77802.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index 5f022f8..ad1caa9 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -65,8 +65,6 @@ static unsigned int ramp_table_77802_4bit[] = {
 };
 
 struct max77802_regulator_prv {
-	int num_regulators;
-	struct regulator_dev *rdev[MAX77802_REG_MAX];
 	unsigned int opmode[MAX77802_REG_MAX];
 };
 
-- 
1.9.1



