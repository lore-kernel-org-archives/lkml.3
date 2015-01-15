Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbbAOQPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:15:46 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:54251 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbbAOQPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:15:43 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH] staging: drivers: pinctrl: Fixed checkpatch.pl warnings
Date: Thu, 15 Jan 2015 21:45:22 +0530
Message-Id: <1421338522-13248-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes two checkpatch.pl warnings

WARNING: Error trailing white space
WARNING: MIssing blank line after declaration

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 drivers/pinctrl/pinctrl-falcon.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-falcon.c b/drivers/pinctrl/pinctrl-falcon.c
index 2e62689..cc59ef6 100644
--- a/drivers/pinctrl/pinctrl-falcon.c
+++ b/drivers/pinctrl/pinctrl-falcon.c
@@ -101,6 +101,7 @@ static void lantiq_load_pin_desc(struct pinctrl_pin_desc *d, int bank, int len)
 	for (i = 0; i < len; i++) {
 		/* strlen("ioXYZ") + 1 = 6 */
 		char *name = kzalloc(6, GFP_KERNEL);
+
 		snprintf(name, 6, "io%d", base + i);
 		d[i].number = base + i;
 		d[i].name = name;
@@ -463,7 +464,7 @@ static int pinctrl_falcon_probe(struct platform_device *pdev)
 								   &res);
 		if (IS_ERR(falcon_info.membase[*bank]))
 			return PTR_ERR(falcon_info.membase[*bank]);
-		
+
 		avail = pad_r32(falcon_info.membase[*bank],
 					LTQ_PADC_AVAIL);
 		pins = fls(avail);
-- 
1.9.1

