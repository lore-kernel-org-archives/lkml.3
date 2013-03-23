Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3CWKAu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 06:00:50 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41298 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3CWKAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 06:00:49 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: Fix typo in of_get_regulator function comments
Date: Sat, 23 Mar 2013 11:00:41 +0100
Message-Id: <1364032842-6467-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index da9782b..edfa223 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -116,7 +116,7 @@ static const char *rdev_get_name(struct regulator_dev *rdev)
  * @supply: regulator supply name
  *
  * Extract the regulator device node corresponding to the supply name.
- * retruns the device node corresponding to the regulator if found, else
+ * returns the device node corresponding to the regulator if found, else
  * returns NULL.
  */
 static struct device_node *of_get_regulator(struct device *dev, const char *supply)
-- 
1.7.10.4

