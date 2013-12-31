Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab3LaM4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 07:56:14 -0500
Received: from mail-gg0-f175.google.com ([209.85.161.175]:54963 "EHLO
	mail-gg0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab3LaM4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 07:56:13 -0500
From: Fabio Estevam <festevam@gmail.com>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] regulator: anatop-regulator: Add MODULE_ALIAS()
Date: Tue, 31 Dec 2013 10:56:00 -0200
Message-Id: <1388494560-25639-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Provide a MODULE_ALIAS() entry to the driver.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/anatop-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index c734d09..a004144 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -259,3 +259,4 @@ MODULE_AUTHOR("Nancy Chen <Nancy.Chen@freescale.com>");
 MODULE_AUTHOR("Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>");
 MODULE_DESCRIPTION("ANATOP Regulator driver");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:anatop_regulator");
-- 
1.8.1.2

