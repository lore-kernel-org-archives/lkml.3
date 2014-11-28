Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279AbaK1AA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 19:00:26 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38350 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaK1AAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 19:00:25 -0500
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH] of: Remove unneeded and incorrect MODULE_DEVICE_TABLE
Date: Fri, 28 Nov 2014 00:00:15 +0000
Message-Id: <1417132815-22949-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unittest code has a MODULE_DEVICE_TABLE that isn't needed by any of
the unittests, and isn't even correct. Remove it.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
This applies against my devicetree/next branch, and I am applying it right away.

 drivers/of/unittest.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index cc0c5ec5d464..7a7ae07d592f 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -965,7 +965,6 @@ static struct of_device_id selftest_match[] = {
 	{ .compatible = "selftest", },
 	{},
 };
-MODULE_DEVICE_TABLE(of, altera_jtaguart_match);
 
 static struct platform_driver selftest_driver = {
 	.probe			= selftest_probe,
-- 
1.9.1

