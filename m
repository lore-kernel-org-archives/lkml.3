Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934105Ab3CTMMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:12:19 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:50811 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933892Ab3CTMKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:10:47 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org
Cc: santosh.shilimkar@ti.com, khilman@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH 07/10] gpio: gpio-stp-xway.c: fix checkpatch error
Date: Wed, 20 Mar 2013 13:16:01 +0100
Message-Id: <1363781764-17330-8-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363781764-17330-1-git-send-email-laurent.navet@gmail.com>
References: <1363781764-17330-1-git-send-email-laurent.navet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix :
 gpio/gpio-stp-xway.c:220: ERROR: trailing whitespace

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/gpio/gpio-stp-xway.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-stp-xway.c b/drivers/gpio/gpio-stp-xway.c
index c20e051..04882a9 100644
--- a/drivers/gpio/gpio-stp-xway.c
+++ b/drivers/gpio/gpio-stp-xway.c
@@ -217,7 +217,7 @@ static int xway_stp_probe(struct platform_device *pdev)
 	chip->virt = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(chip->virt))
 		return PTR_ERR(chip->virt);
-	
+
 	chip->gc.dev = &pdev->dev;
 	chip->gc.label = "stp-xway";
 	chip->gc.direction_output = xway_stp_dir_out;
-- 
1.7.10.4

