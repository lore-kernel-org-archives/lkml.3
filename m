Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbaEGMac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:30:32 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43084 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaEGMaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:30:30 -0400
From: John Church <sleeveroller@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        georgiana.chelu93@gmail.com, waydi1@gmail.com
Cc: dan.carpenter@oracle.com, linux-kernel@vger.kernel.org,
        John Church <sleeveroller@gmail.com>
Subject: [PATCH] staging : android: Fixes a coding style issue in timed_gpio.c
Date: Wed,  7 May 2014 13:30:02 +0100
Message-Id: <1399465802-9309-1-git-send-email-sleeveroller@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a coding style issue for a line that was over 80 characters long.

Signed-off-by: John Church <sleeveroller@gmail.com>

---
 drivers/staging/android/timed_gpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/timed_gpio.c b/drivers/staging/android/timed_gpio.c
index f7d124d..180c209 100644
--- a/drivers/staging/android/timed_gpio.c
+++ b/drivers/staging/android/timed_gpio.c
@@ -92,8 +92,8 @@ static int timed_gpio_probe(struct platform_device *pdev)
 		return -EBUSY;
 
 	gpio_data = devm_kzalloc(&pdev->dev,
-				sizeof(struct timed_gpio_data) * pdata->num_gpios,
-				GFP_KERNEL);
+			sizeof(struct timed_gpio_data) * pdata->num_gpios,
+			GFP_KERNEL);
 	if (!gpio_data)
 		return -ENOMEM;
 
-- 
1.7.10.4

