Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaKHMNA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 07:13:00 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36289 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbaKHMM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 07:12:59 -0500
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: lgirdwood@gmail.com, broonie@kernel.org, badarkhe.manish@gmail.com
Subject: [PATCH] regulator: tps65218: Remove '.owner' field
Date: Sat,  8 Nov 2014 17:42:52 +0530
Message-Id: <1415448772-3895-1-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove '.owner' field of driver structure as it is
going to be filled via "module_platform_driver" call.

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
:100644 100644 f0a4028... e2b97ac... M	drivers/regulator/tps65218-regulator.c
 drivers/regulator/tps65218-regulator.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/tps65218-regulator.c
index f0a4028..e2b97ac 100644
--- a/drivers/regulator/tps65218-regulator.c
+++ b/drivers/regulator/tps65218-regulator.c
@@ -255,7 +255,6 @@ static int tps65218_regulator_probe(struct platform_device *pdev)
 static struct platform_driver tps65218_regulator_driver = {
 	.driver = {
 		.name = "tps65218-pmic",
-		.owner = THIS_MODULE,
 		.of_match_table = tps65218_of_match,
 	},
 	.probe = tps65218_regulator_probe,
-- 
1.7.10.4

