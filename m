Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab3LUFzk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 00:55:40 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:48092 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3LUFzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 00:55:39 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sachin.kamat@linaro.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH 1/2] mfd: twl6040: Staticize local variable
Date: Sat, 21 Dec 2013 11:22:21 +0530
Message-Id: <1387605142-4743-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'twl6040_patch' is local to this file.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index 51b6df1a7949..75316fb33448 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -86,7 +86,7 @@ static struct reg_default twl6040_defaults[] = {
 	{ 0x2E, 0x00 }, /* REG_STATUS	(ro) */
 };
 
-struct reg_default twl6040_patch[] = {
+static struct reg_default twl6040_patch[] = {
 	/* Select I2C bus access to dual access registers */
 	{ TWL6040_REG_ACCCTL, 0x09 },
 };
-- 
1.7.9.5

